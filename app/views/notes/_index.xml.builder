xml.notes(type: 'array') do
  xml << render(partial: 'notes/note', format: 'xml', collection: notes) if !notes.empty?
end