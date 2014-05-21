xml.name do
  xml.id(name.id, :type => 'integer')
  xml.etymology(name.etymology)
  xml.language(name.language.name, :code => name.language.code)
  xml.name(name.name)
  w = name.writing_system
  xml.writing_system(w.nil? ? nil : w.name)
  xml.relationship(name.pp_display_string)
  xml.names(:type => 'array') do
    names = name.children.order('position')
    xml << render(:partial => 'name.xml.builder', :collection => names) if !names.empty?
  end
  
end