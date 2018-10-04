// This is a manifest file that'll be compiled into admin.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

jQuery(document).ready(function(){
  // highlightt .listGrid rows
  jQuery('.listGrid td').hover(
    function(){jQuery(this).parent().addClass('rowHighlight');},
    function(){jQuery(this).parent().removeClass('rowHighlight');}
  );
  // The #SelectNav select tag is generated by the AdminHelper::admin_select_nav
  jQuery('#SelectNav').change(function(){window.location = this.value;});

  jQuery('#flash').fadeOut(1);

  jQuery("#flash").fadeIn(500, function(){
    //setTimeout(function(){jQuery("#flash").fadeOut(2500)}, 500);
  });
})
