$(document).ready(function() {
  var menuSolrUtils = kmapsSolrUtils.init({
    assetIndex: $('#essay_js_data').data('assetIndex'),
    featureId: $('#essay_js_data').data('featureId'),
    domain: $('#essay_js_data').data('domain'),
  });
  var availableLanguages = $('#essay_js_data').data('availableLanguages');
  var defaultLanguage = availableLanguages.find(({ code }) => code === 'eng')["id"];

  var subjectsLanguages = $('#essay_js_data').data('mandalaMapLanguages');
  //From the subjectsLanguages we are going to generate an array that contains only the subjects:
  var railsLanguages = Object.keys(subjectsLanguages);

  var result = menuSolrUtils.getRelatedMandalaTexts();
  result.then(function(data){
    var textOptionContainer = $("#mandala_text_options_js");
    if (data.length == 0 ) {
      textOptionContainer.html("You haven't labeled any texts using this "+
        $('#essay_js_data').data('featureType')+
        ". For help, see <a href='https://confluence.its.virginia.edu/display/KB/Join+Related+Resources'>this guide</a>.");
      return;
    }
    var options = "<ul style='display:table'>";
    var related = {};
    data.forEach(function (text){
      related[text["id"]] = text["related"];
      var option = "<li>";
      option += "<label><input type='radio' name='mandalaTextOption' value='"+text["id"]+"'> ";
      option += text["title"]+"</label>";
      option += "</li>";
      options += option;
    });
    options += "</ul>";
    textOptionContainer.html(options);
    $('input:radio[name="mandalaTextOption"]').on('click', function(e) {
      var textId = $('input:radio[name="mandalaTextOption"]:checked').val()
      $("#text_id").val(textId);
      var matchingLanguages = related[textId].filter((language) => railsLanguages.includes(language));
      if (Array.isArray(matchingLanguages) && matchingLanguages.length) {
        //We are going to use the first match as the default
        var autoLanguage = subjectsLanguages[matchingLanguages[0]];
        $("[name='essay[language_id]'] option[value="+autoLanguage+"]").attr('selected',true);
      } else {
        $("[name='essay[language_id]'] option[value="+defaultLanguage+"]").attr('selected',true);
      }
      $("[name='essay[language_id]']").change();
    });
    var currentTextId = $("#text_id").val();
    if (!!currentTextId) {
      $('input:radio[name="mandalaTextOption"][value='+currentTextId+']').attr('checked', true);
    }
  });
});
