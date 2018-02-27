class ChangeCitationIdToNotNullForPage < ActiveRecord::Migration[5.1]
  def up
    change_column :pages, :citation_id, :integer, null: false
  end
  def down
    change_column :pages, :citation_id, :integer
  end
end
