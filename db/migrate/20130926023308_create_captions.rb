class CreateCaptions < ActiveRecord::Migration
  def change
    create_table :captions do |t|
      t.integer :language_id, :null => false
      t.string :content, :null => false, :limit => 150
      t.integer :author_id, :null => false
      t.integer :feature_id, :null => false

      t.timestamps
    end
  end
end
