xml.name do
  xml.id(name.id, type: 'integer')
  xml.etymology(name.etymology)
  xml.language(name: name.language.name, code: name.language.code)
  xml.name(name.name)
  w = name.writing_system
  if w.nil?
    xml.writing_system(nil)
  else
    xml.writing_system(name: w.name, code: w.code)
  end
  xml << render(partial: 'time_units/index.xml.builder', locals: {time_units: name.time_units})
  parent_relation = name.parent_relations.first
  if parent_relation.nil?
    xml.relationship(name: 'Original', code: nil, type: nil)
  else
    relationship = parent_relation.phonetic_system
    relationship = parent_relation.orthographic_system if relationship.nil?
    relationship = parent_relation.alt_spelling_system if relationship.nil?
    if relationship.nil?
      xml.relationship(name: parent_relation.is_translation ? 'Translation' : 'Unknown Relation', code: nil, type: nil)
    else
      xml.relationship(name: relationship.name, code: relationship.code, type: relationship.type)
    end
  end
  if !@feature.nil?
    xml.names(:type => 'array') do
      names = name.children.order('position')
      xml << render(:partial => 'name.xml.builder', :collection => names) if !names.empty?
    end
  end
end