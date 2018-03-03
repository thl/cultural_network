xml.names(:type => 'array') do
  xml << render(:partial => 'name.xml.builder', :collection => names) if !names.empty?
end