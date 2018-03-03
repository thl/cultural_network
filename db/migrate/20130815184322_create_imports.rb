class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :spreadsheet_id, :null => false
      t.integer :item_id, :null => false
      t.string :item_type, :null => false

      t.timestamps
    end
  end
end
