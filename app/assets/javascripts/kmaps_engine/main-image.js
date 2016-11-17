//= require gallery/modernizr.custom
//= require gallery/jquery.row-grid
//= require gallery/photoswipe
//= require gallery/photoswipe-ui-default
//= require gallery/jquery.actual.min
//= require gallery/jquery.imagesloaded
//= require gallery/grid

(function ($) {
				/* Code to hide Admin menu when cursor not in upper right
				setTimeout(function() { $('#admin-menu').slideUp(); $('body').removeClass('admin-menu'); }, 1000);
				$('body').mousemove(function(event) { 
					var x = event.pageX;
					var y = event.pageY; 
					if (y < 50 && x < 200) { 
						if ($('#admin-menu').is(":hidden")) {
							$('#admin-menu').slideDown(); 
							$('body').addClass('admin-menu');
						}
					} else if (y > 200) { 
						if ($('#admin-menu').is(":visible")) {
							setTimeout(function() { $('#admin-menu').slideUp(); $('body').removeClass('admin-menu'); }, 15000);
						} 
					} 
				}); */

	
	/*
	 * popupImageCenter: jQuery extension function called in grid.js when opening popup. Positions image and lightbox link centered vertically  */
	 
    $.fn.popupImageCentering = function() {
		return this.each(function() {
			
			// Adjust top margin
			/*
			var 	wrapper = $(this).parents('.og-img-wrapper'), // get wrapper
				 	imght = $(this).height(),
					cnthgt = $(this).parents('.og-fullimg').height(),
					tmarg = (cnthgt > imght) ? -imght / 2 : -cnthgt / 2;
					
			wrapper.css("margin-top",  tmarg  + "px" );
			*/
			//console.log("tmarg: " + tmarg);
			
			// Adjust left margin
			/*
			var 	imgwdt = $(this).width(),
					cntwdt = $(this).parents('.og-fullimg').width(),
					lmarg = (cntwdt > imgwdt) ? -imgwdt / 2 : -cntwdt / 2;
			wrapper.css("margin-left",  lmarg  + "px" );
			*/
			//console.log("imgwdt: " + imgwdt);
			//console.log("cntwdt: " + cntwdt);
			//console.log("lmarg: " + lmarg);*

			// if ($(".og-img-wrapper").css("padding-bottom") == "0" ){

	             var imght = $(this).height(),
					 cnthgt = $(this).parents('.og-fullimg').height(),
					 tmarg = (cnthgt > imght) ? -imght / 2 : -cnthgt / 2;

				 // vertically align tabs based on taller tab's actual height
				 var infohgt = $( '.og-details #info' ).actual('height') ;
				 var deschgt =  $( '.og-details #desc' ).actual('height') ;
				 var panelhgt = (infohgt > deschgt) ? infohgt : deschgt;
				 var detheight = panelhgt + 70; // account for tabs above and link below info tab
				 
				if (detheight < cnthgt - 30) {
				 	var tmarg = ((cnthgt - detheight) / 2);
				 	$('.og-details').css('margin-top', tmarg + 'px');
				}

			// }

		});
   };

	  


}) (jQuery);





