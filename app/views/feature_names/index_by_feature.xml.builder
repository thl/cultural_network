xml.instruct!
xml << render(:partial => 'index.xml.builder', :locals => { :names => @names })