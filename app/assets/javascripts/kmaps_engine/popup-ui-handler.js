$(function() {
	//$('body').append("<div id=\"popup_dialog\"></div>")
	$( '#popup_dialog' ).dialog({
		autoOpen: false,
		height: 500,
		width: 520,
		modal: true,
		//close: function() { $('#popup_dialog').remove(); }
	});
});