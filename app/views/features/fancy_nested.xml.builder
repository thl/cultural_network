xml.instruct!
xml.features(:type => 'array') do
  xml << render(:partial => 'fancy_nested_feature.xml.builder', :locals => {:feature => @feature})
end