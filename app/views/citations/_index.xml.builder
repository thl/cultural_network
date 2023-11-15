xml.citations(type: 'array') do
  xml << render(partial: 'citations/citation', format: 'xml', collection: citations) if !citations.empty?
end