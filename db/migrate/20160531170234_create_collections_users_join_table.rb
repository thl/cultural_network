class CreateCollectionsUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :collections, :users do |t|
      # t.index [:collection_id, :user_id]
      t.index [:user_id, :collection_id], unique: true
    end
  end
end
