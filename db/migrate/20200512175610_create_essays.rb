class CreateEssays < ActiveRecord::Migration[5.2]
  def change
    create_table :essays do |t|
      t.references :feature, foreign_key: true, null: false
      t.integer :text_id, null: false
      t.integer :language_id, null: false
      t.timestamps
    end
  end
end
