xml.citations(type: 'array') do
  xml << render(partial: 'citations/citation.xml.builder', collection: citations) if !citations.empty?
end