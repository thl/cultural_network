xml.names(type: 'array') do
  xml << render(partial: 'name', format: 'xml', collection: names) if !names.empty?
end