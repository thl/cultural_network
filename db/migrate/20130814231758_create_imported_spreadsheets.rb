class CreateImportedSpreadsheets < ActiveRecord::Migration
  def change
    create_table :imported_spreadsheets do |t|
      t.string :filename, :null => false
      t.integer :task_id, :null => false
      t.datetime :imported_at, :null => false

      t.timestamps
    end
  end
end
