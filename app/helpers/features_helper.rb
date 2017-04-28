#
#
#
# This is the helper for the **public** view
#
#
#
module FeaturesHelper
  def has_search_scope?
    !params[:search_scope].blank?
  end
  
  def is_global_search_scope?
    'global' == params[:search_scope]
  end
  
  def is_contextual_search_scope?
    'contextual' == params[:search_scope]
  end
  
  def is_fid_search_scope?
    'fid' == params[:search_scope]
  end
  
  def node_li_value(node, target)
    if target && node.id == target.id
      f_label(node, :class=>:selected)
    else
      f_link(node, features_path(:context_id=>node.id, :filter=>params[:filter]))
      # f_link(node, feature_path(node.fid), :class => :remote)
    end
  end
  
  #
  # Common html attributes for a popup/"Thickbox" link
  #
  def popup_attrs(feature)
    {
    :class=>'thickbox',
    :title=>link_to('Link to this Feature', feature_path(feature.fid))
    }
  end
  
  #
  # The common url params used for popup/"Thickbox"
  #
  def popup_params
    {:height=>500, :width=>500, :no_layout=>true}
  end
  
  #
  # Creates a link for a feature
  # if the @no_layout param is set (see application_controller) - use popup/"Thickbox"
  # else just a standard link
  #
  def feature_link_switch(feature)
    if @no_layout
      # show feature in popup
      f_link(feature, feature_path(feature.fid, popup_params), popup_attrs(feature))
    else
      # load feature as usual
      f_link(feature, feature_path(feature.fid))
    end
  end
  
  #
  #
  #
  def f_popup_link(feature)
    html_attrs = popup_attrs(feature)
    html_attrs[:class] += feature.id.to_s==params[:context_id] ? ' selected' : ''
    f_link(feature, feature_path(feature.fid, popup_params), html_attrs)
  end
  
  #
  # Pass in a set of root FeatureNames (having the same parent)
  # to build a ul list
  # "completed" is used only by this method
  #
  def feature_name_ul(feature, use_links=true, root_names=nil, completed=[])
    root_names = feature.names.roots.order('position') if feature
    html=''
    root_names.each do |name|
      next if completed.include? name
      completed << name
      html += '<li style="margin-left:1em; list-style:none;">'
      html += '<b>&gt;</b>&nbsp;' unless name.is_original?
      html += (use_links ? link_to(feature_name_display(name), admin_feature_name_path(name)) : feature_name_display(name, {:show_association_links => true}))
      html += feature_name_ul(nil, use_links, name.children.order('position'), completed)
      html += '</li>'
    end
    (html.blank? ? '' : "<ul style='margin:0; margin-top: 5px;'>#{html}</ul>").html_safe
  end
  
  def feature_name_display(name, options={})
    if options[:show_association_links]
      name_notes_link = note_popup_link_for(name)
      name_time_units_link = time_units_for(name)
    end
    "#{name.detailed_name.s}#{name_notes_link}#{name_time_units_link}"
  end
  
  def feature_name_header(feature)
    # names = apply_name_preference(feature.names).sort
    name = feature.prioritized_name(current_view)
    name.nil? ? feature.pid : name
  end

  def generate_will_paginate_link(page, text)
    # slippery way of getting this link to be ajaxy and to 'know' its url; see views/features/_descendants.html.erb
    "<a href='#' class='ajax_get' name='#{url_for(params.merge(:page => page != 1 ? page : nil))}'>#{text}</a>".html_safe
  end
  
  def active_menu_item
    !session[:interface].blank? && !session[:interface][:menu_item].blank? ? session[:interface][:menu_item] : 'browse'
  end

  def feature_relation_tree(feature, show_siblings = false)
    v = current_view
    p = current_perspective
    ancestors = feature.current_ancestors(p)
    last_parent = ancestors.last
    parent = ancestors.shift
    tree = []
    parent_node = nil
    children_for_current = nil
    if !parent.nil?
      parent_node = {title: "<strong>#{parent.prioritized_name(v).name}</strong>", state: {expanded: true}, enableLinks: true, href: feature_path(parent.fid), key: parent.fid}
      tree = [parent_node]
      while parent = ancestors.shift
        parent_node[:children] = [{title: "<strong>#{parent.prioritized_name(v).name}</strong>", state: {expanded: true}}]
        parent_node[:href] = feature_path(parent.fid)
        parent_node = parent_node[:children].first
      end
      #parent_node[:title] << " (#{last_parent.feature_object_types.collect{|fot| fot.category.header}.join(', ')})"
    end
    if show_siblings
      parent_node[:children] = last_parent.current_children(p,v).collect do |c|
        node = {title: "<strong>#{c.prioritized_name(v).name}</strong>", href: feature_path(c.fid), key: c.fid}
        if feature.fid == c.fid
          node[:backColor] = '#eaeaea'
          node[:expanded] = true
          node[:active] = true
          node[:children] = []
          children_for_current = node[:children]
        end
        node
      end
    else
      node = { title: "<strong>#{feature.prioritized_name(v).name}</strong>",
               href: feature_path(feature.fid),
               key: feature.fid,
               backColor: '#eaeaea',
               expanded: true,
               active: true,
               children: []}
      children_for_current = node[:children]
      if parent_node.nil?
        tree = [ node ]
      else
        parent_node[:children] = [ node ]
      end
    end
    children_for_current.concat(feature.all_child_relations
      .collect{|c| {title: "<strong>#{c.child_node.prioritized_name(v).name}</strong> (from #{c.perspective.name}: #{c.feature_relation_type.asymmetric_label})", href: feature_path(c.child_node.fid), lazy: true, key: c.child_node.fid,}})
    apr = []
    if last_parent.nil?
      apr = feature.all_parent_relations
    else
      apr = feature.all_parent_relations.where.not(parent_node_id: last_parent.id)
    end
    parents_not_in_tree = apr.collect{|c| {title: "<strong>#{c.parent_node.prioritized_name(v).name}</strong> (from #{c.perspective.name}: #{c.parent_node.feature_object_types.collect{|fot| fot.category.header}.join(', ')}; #{c.feature_relation_type.label})", href: feature_path(c.parent_node.fid)}}
    {tree: tree, not_in_tree: parents_not_in_tree}
  end
end
