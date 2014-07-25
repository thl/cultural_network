class CreateWebPages < ActiveRecord::Migration
  def change
    create_table :web_pages do |t|
      t.string :path, :null => false
      t.string :title, :null => false
      t.integer :citation_id, :null => false

      t.timestamps
    end
  end
end
