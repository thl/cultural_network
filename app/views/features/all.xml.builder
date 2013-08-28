xml.instruct!
xml << render(:partial => 'recursive_stripped_feature.xml.builder', :locals => {:feature => @feature})