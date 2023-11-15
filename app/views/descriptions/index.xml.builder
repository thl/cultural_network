xml.descriptions(type: 'array') do
  xml << render(partial: 'description', format: 'xml', collection: @descriptions) if !@descriptions.empty?
end