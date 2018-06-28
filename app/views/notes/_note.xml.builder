#  id                :integer          not null, primary key
#  notable_type      :string(255)
#  notable_id        :integer
#  note_title_id     :integer
#  custom_note_title :string(255)
#  content           :text
#  created_at        :datetime
#  updated_at        :datetime
#  association_type  :string(255)
#  is_public         :boolean          default(TRUE)

xml.note do
  xml.id(note.id, type: 'integer')
  xml.title(note.note_title.title) if !note.note_title.nil?
  xml.custom_title(note.custom_note_title)
  xml.content(note.content)
  xml.association_type(note.association_type)
  xml.created_at(note.created_at, type: 'timestamp')
  xml.updated_at(note.updated_at, type: 'timestamp')
end