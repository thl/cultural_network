class ChangeCaptionToText < ActiveRecord::Migration
  def up
    change_column :captions, :content, :text, :null => false
  end

  def down
    change_column :captions, :content, :string, :null => false, :limit => 150
  end
end
