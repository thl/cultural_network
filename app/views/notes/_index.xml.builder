xml.notes(type: 'array') do
  xml << render(partial: 'notes/note.xml.builder', collection: notes) if !notes.empty?
end