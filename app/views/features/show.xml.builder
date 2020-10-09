xml.instruct!
xml << render(:partial => 'feature.xml.builder', :object => @feature) if !@feature.nil?