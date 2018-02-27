class CreateIllustrations < ActiveRecord::Migration
  def change
    create_table :illustrations do |t|
      t.integer :feature_id, :null => false
      t.integer :picture_id, :null => false
      t.string :picture_type, :null => false
      t.boolean :is_primary, :null => false, :default => true

      t.timestamps
    end
  end
end
