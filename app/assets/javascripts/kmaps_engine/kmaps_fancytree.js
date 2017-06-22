/*
 *  Project: UVa KMaps
 *  Description: Plugin to handle the fancyTree implementation with Solr
 *  Author: djrc2r
 */

// the semi-colon before function invocation is a safety net against concatenated
// scripts and/or other plugins which may not be closed properly.
;(function ( $, window, document, undefined ) {
  "use strict";

  var SOLR_ROW_LIMIT = 2000;

	// undefined is used here as the undefined global variable in ECMAScript 3 is
	// mutable (ie. it can be changed by someone else). undefined isn't really being
	// passed in so we can ensure the value of it is truly undefined. In ES5, undefined
	// can no longer be modified.

	// window is passed through as local variable rather than global
	// as this (slightly) quickens the resolution process and can be more efficiently
	// minified (especially when both are regularly referenced in your plugin).

	// Create the defaults once
	var pluginName = 'kmapsFancytree',
		defaults = {
      hostname: "localhost",
      termIndex: "/solr/kmterms_dev",
      assetIndex: "/solr/kmassets_dev",
      tree: "places",
      featuresPath: "/features/",
      domain: "places",
      featureId: 1,
      perspective: "pol.admin.hier",
      seedTree: {
        descendants: false,
        directAncestors: true,
      },
		};

	// The actual plugin constructor
	function Plugin( element, options ) {
		this.element = element;

		// jQuery has an extend method which merges the contents of two or
		// more objects, storing the result in the first object. The first object
		// is generally empty as we don't want to alter the default options for
		// future instances of the plugin
		this.options = $.extend( {}, defaults, options) ;

		this._defaults = defaults;
		this._name = pluginName;

		this.init();
	}

  Plugin.prototype = {
    init: function () {
      const plugin = this;
      // Place initialization logic here
      // You already have access to the DOM element and the options via the instance,
      // e.g., this.element and this.options
      $(plugin.element).fancytree({
				extensions: ["glyph"],
        source: plugin.getAncestorTree(plugin.options.seedTree),
				glyph: {
					map: {
						doc: "",
						docOpen: "",
						error: "glyphicon glyphicon-warning-sign",
						expanderClosed: "glyphicon glyphicon-plus-sign",
						expanderLazy: "glyphicon glyphicon-plus-sign",
						// expanderLazy: "glyphicon glyphicon-expand",
						expanderOpen: "glyphicon glyphicon-minus-sign",
						// expanderOpen: "glyphicon glyphicon-collapse-down",
						folder: "",
						folderOpen: "",
						loading: "glyphicon glyphicon-refresh"
							//              loading: "icon-spinner icon-spin"
					}
        },
        activate: function(event, data){
          var node = data.node,
            orgEvent = data.originalEvent;
          if(node.data.href){
            window.location.href=node.data.href;
          }
        },
        lazyLoad: function(event,data){
          data.result = plugin.getDescendantTree(data.node.key);
        },
			});
    },
    getAncestorPath: function() {
      const plugin = this;
      const dfd = $.Deferred();
      var url =
        plugin.options.hostname +
        plugin.options.termIndex + "/select?" +
        "&q=" + "id:" + plugin.options.domain + "-" + plugin.options.featureId +
        //"&fl=ancestor*" + "cult.reg" + "*" +
        "&fl=*level*,ancestor*" + plugin.options.perspective + "*" +
        "&fq=tree:" + plugin.options.tree +
        "&indent=true" +
        "&wt=json" +
        "&json.wrf=?" +
        "&rows=" + SOLR_ROW_LIMIT +
        "&limit=" + SOLR_ROW_LIMIT;
      ;;;console.log(url);
      $.ajax({
        url: url,
        dataType: 'jsonp',
        jsonp: 'json.wrf'
      }).done(function(data){
        ;;;console.log(JSON.stringify(data));
        const response = data.response;
        if(response.numFound < 1) {
          dfd.resolve([]);
        } else {
         const path = response.docs[0]["ancestor_id_"+plugin.options.perspective+"_path"];
         const level = response.docs[0]["level_"+plugin.options.perspective+"_i"];
          ;;;console.log(level);
          var url =
            plugin.options.hostname +
            plugin.options.termIndex + "/select?" +
            "&q=" + "ancestor_id_" + plugin.options.perspective + "_path:" + path +
            //"&fl=ancestor*" + "cult.reg" + "*" +
            //"&fl=ancestor*" + plugin.options.perspective + "*" +
            "&fl=*" +
            "&fq=tree:" + plugin.options.tree +
            "&indent=true" +
            "&wt=json" +
            "&json.wrf=?" +
            "&rows=" + SOLR_ROW_LIMIT +
            "&fq=level_i:[" + 1 + "+TO+" + ( level + 1) + "]" +
            "&limit=" + SOLR_ROW_LIMIT;
          ;;;console.log("URL:");
          ;;;console.log(url);
          dfd.resolve([data]);
        }
      }).fail(function(data){
          dfd.resolve([]);
      });
      return dfd.promise();
    },
    getAncestorTree: function({descendants = false, directAncestors = true}){
      const loadDescendants = descendants, loadOnlyDirectAncestors = directAncestors;
      const dfd = $.Deferred();
      const plugin = this;
      const fieldList = [
        "header",
        "id",
        "ancestor*",
        "caption_eng",
      ].join(",");
      var url =
        plugin.options.hostname +
        plugin.options.termIndex + "/select?";
      if(loadOnlyDirectAncestors) {
        ;;;console.log("Load Only Direct Ancestors");
        url += "&q=" + "id:" + plugin.options.domain + "-" + plugin.options.featureId;
      } else {
        ;;;console.log("Load All Ancestors");
        url += "&q=" + "id:" + plugin.options.domain + "-" + plugin.options.featureId;
        ;;;console.log(plugin.getAncestorPath());
      }
      url += "&fl=" + fieldList +
        "&fq=tree:" + plugin.options.tree +
        "&indent=true" +
        "&wt=json" +
        "&json.wrf=?" +
        "&rows=" + SOLR_ROW_LIMIT +
        "&limit=" + SOLR_ROW_LIMIT;
      $.ajax({
        url: url,
        dataType: 'jsonp',
        jsonp: 'json.wrf'
      }).done(function(data){
        const response = data.response;
        const buildTree = function buildTree(doc,children) {
          ;;;console.log("AnCESTORS");
          ;;;console.log("ancestor_id_closest_" + plugin.options.perspective + "_path");
          var ancestorsKey  = "ancestor_ids_" + plugin.options.perspective;
          var ancestorsNameKey  = "ancestors_" + plugin.options.perspective;
          if( doc[ancestorsKey] === undefined ) {
            ancestorsKey  = "ancestor_ids_closest_" + plugin.options.perspective;
            ancestorsNameKey  = "ancestors_closest_" + plugin.options.perspective;
          }
          const result = doc[ancestorsKey] === undefined ? [] : doc[ancestorsKey].reduceRight(function(acc,val,index){
            const node = {
              title: doc[ancestorsNameKey][index],
              key: val,
              expanded: true,
              href: plugin.options.featuresPath+val,
              lazy: true,
              //[].concat to handle the instance when the children are sent as an argument
              children: acc === undefined ? null : [].concat(acc)
            };
            if( Number(val) === Number(plugin.options.featureId)) {
              node.active = true;
              node.backColor= '#eaeaea';
            }
            return node;
          }, children);
          dfd.resolve([result]);
        }
        if(response.numFound > 0){
          const doc = response.docs[0];
					var ancestor_ids_key = "ancestor_ids_"+plugin.options.perspective;
					var ancestors_key = "ancestors_"+plugin.options.perspective;
					if(doc[ancestor_ids_key] === undefined){
						ancestor_ids_key = "ancestor_ids_closest_"+plugin.options.perspective;
						ancestors_key = "ancestors_closest_"+plugin.options.perspective;
					}
          if (loadDescendants) {
            const featureChildren = plugin.getDescendantTree(plugin.options.featureId);
            featureChildren.then(function(value){ buildTree(doc, value)});
          } else {
            buildTree(doc);
          }
        } else {
          dfd.resolve([]);
        }
      });
      return dfd.promise();
    },
    getDescendantTree: function(featureId){
      const dfd = $.Deferred();
      const plugin = this;
      const fieldList = [
        "header",
        "id",
        "ancestor*",
        "caption_eng",
        "related_places_feature_type_s",
        "related_places_relation_label_s",
      ].join(",");
      var url =
        plugin.options.hostname +
        plugin.options.termIndex + "/select?" +
        //V0
        //"&q=" + encodeURI("ancestor_id_path:*/"+featureId+"/* OR ancestor_id_path:"+featureId+"/*") +
        //"&fl=*," + fieldList +
        //V1 of the query
        //"&q=" + "id:" + plugin.options.domain + "-" + featureId + "_*" +
        //"&fq=related_kmaps_node_type:" + "child" +
        //"&fl=*," + fieldList +
        //V2 without counts
        //"&q=" + "{!child of=block_type:parent}id:" + plugin.options.domain + "-" + featureId +
        //"&fq=" + "{!collapse field=related_places_id_s}" +
        //"&fq=related_kmaps_node_type:" + "child" +
        //"&fl=*," + fieldList +
        //V3 child count
        "&q=" + "{!child of=block_type:parent}id:" + plugin.options.domain + "-" + featureId +
        "&fl=child_count:[subquery],uid,related_places_id_s,related_places_header_s" +","+ fieldList +
        "&expand=true" +
        "&child_count.fq=related_kmaps_node_type:child" +
        "&child_count.fl=uid" +
        "&child_count.rows=" + "0" +
        "&child_count.q={!child of='block_type:parent'}{!term f=uid v=$row.related_places_id_s}" +
        "&fq=related_kmaps_node_type:" + "child" +
        "&fq="+"{!collapse field=related_places_id_s}" +
        //end of V3
        "&wt=json" +
        "&limit=" + SOLR_ROW_LIMIT +
        "&indent=true" +
        "&wt=json" +
        "&json.wrf=?" +
        "&sort=related_places_header_s+asc" +
        "&rows=" + SOLR_ROW_LIMIT;
      console.log(url);
      $.ajax({
        url: url,
        dataType: 'jsonp',
        jsonp: 'json.wrf'
      }).done(function(data){
        const response = data.response;
        if(response.numFound > 0){
          const result = response.docs.reduce(function(acc,currentNode,index){
            const regex = new RegExp(plugin.options.domain+"-(.*)");
            const match= currentNode["related_places_id_s"].match(regex);
            const key = match[1] === undefined? "" : match[1];
            const child = {
              title: currentNode["related_places_header_s"]+
              "("+currentNode["related_places_feature_type_s"]+": "+
              currentNode["related_places_relation_label_s"]+")",
              key: key,
              expanded: true,
              lazy: true,
              href: plugin.options.featuresPath+key,
            };
            if(currentNode["child_count"] !== undefined) {
              if(currentNode["child_count"]["numFound"] === 0) {
                child.lazy = false;
              }
            }
            return acc !== undefined ? acc.concat([child]): [child];
          }, []);
          dfd.resolve(result);
        } else {
          dfd.resolve([]);
        }
      });
      return dfd.promise();
    }
  };

	// You don't need to change something below:
	// A really lightweight plugin wrapper around the constructor,
	// preventing against multiple instantiations and allowing any
	// public function (ie. a function whose name doesn't start
	// with an underscore) to be called via the jQuery plugin,
	// e.g. $(element).defaultPluginName('functionName', arg1, arg2)
	$.fn[pluginName] = function ( options ) {
		var args = arguments;

		// Is the first parameter an object (options), or was omitted,
		// instantiate a new instance of the plugin.
		if (options === undefined || typeof options === 'object') {
			return this.each(function () {

				// Only allow the plugin to be instantiated once,
				// so we check that the element has no plugin instantiation yet
				if (!$.data(this, 'plugin_' + pluginName)) {

					// if it has no instance, create a new one,
					// pass options to our plugin constructor,
					// and store the plugin instance
					// in the elements jQuery data object.
					$.data(this, 'plugin_' + pluginName, new Plugin( this, options ));
				}
			});

			// If the first parameter is a string and it doesn't start
			// with an underscore or "contains" the `init`-function,
			// treat this as a call to a public method.
		} else if (typeof options === 'string' && options[0] !== '_' && options !== 'init') {

			// Cache the method call
			// to make it possible
			// to return a value
			var returns;

			this.each(function () {
				var instance = $.data(this, 'plugin_' + pluginName);

				// Tests that there's already a plugin-instance
				// and checks that the requested public method exists
				if (instance instanceof Plugin && typeof instance[options] === 'function') {

					// Call the method of our plugin instance,
					// and pass it the supplied arguments.
					returns = instance[options].apply( instance, Array.prototype.slice.call( args, 1 ) );
				}

				// Allow instances to be destroyed via the 'destroy' method
				if (options === 'destroy') {
					$.data(this, 'plugin_' + pluginName, null);
				}
			});

			// If the earlier cached method
			// gives a value back return the value,
			// otherwise return this to preserve chainability.
			return returns !== undefined ? returns : this;
		}
	};
}(jQuery, window, document));

