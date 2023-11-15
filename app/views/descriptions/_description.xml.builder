xml.description do
  xml.id(description.id, type: 'integer')
  xml.title(description.title)
  xml.content(description.content)
  xml.source_url(description.source_url)
  xml.is_primary(description.is_primary, type: 'boolean')
  xml.created_at(description.created_at, type: 'timestamp')
  xml.updated_at(description.updated_at, type: 'timestamp')
  xml << render(partial: 'features/stripped_feature', format: 'xml', locals: { feature: description.feature }) if @feature.nil?
  xml.authors(type: 'array') do
    authors = description.authors
    xml << render(partial: 'authenticated_system/people/show', format: 'xml', collection: authors, as: 'person') if !authors.empty?
  end
  xml << render(partial: 'time_units/index', format: 'xml', locals: {time_units: description.time_units})
  xml << render(partial: 'citations/index', format: 'xml', locals: {citations: description.citations})
  xml << render(partial: 'notes/index', format: 'xml', locals: {notes: description.notes})
end