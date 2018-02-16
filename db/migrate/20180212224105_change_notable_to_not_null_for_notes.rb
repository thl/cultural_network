class ChangeNotableToNotNullForNotes < ActiveRecord::Migration[5.1]
  def up
    Note.where(notable_id: nil).delete_all
    AssociationNote.where(notable_type: nil).update(notable_type: 'Feature')
    change_column :notes, :notable_id, :integer, null: false
    change_column :notes, :notable_type, :string, null: false
    change_column :notes, :content, :text, null: false
  end

  def down
    change_column :notes, :notable_id, :integer
    change_column :notes, :notable_type, :string
    change_column :notes, :content, :text
  end
end
