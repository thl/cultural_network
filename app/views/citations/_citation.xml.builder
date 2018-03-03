xml.citation do
  xml.id(citation.id, type: 'integer')
  xml.info_source_id(citation.info_source_id, type: 'integer')
  xml.info_source_type(citation.info_source_type)
  xml.notes(citation.notes)  
  xml.created_at(citation.created_at, type: 'timestamp')
  xml.updated_at(citation.updated_at, type: 'timestamp')
end