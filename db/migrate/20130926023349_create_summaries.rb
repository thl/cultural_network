class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.integer :language_id, :null => false
      t.text :content, :null => false, :limit => 750
      t.integer :author_id, :null => false
      t.integer :feature_id, :null => false

      t.timestamps
    end
  end
end
