xml.instruct!
xml << render(:partial => 'recursive_nested_feature.xml.builder', :locals => {:feature => @feature})