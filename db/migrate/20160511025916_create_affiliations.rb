class CreateAffiliations < ActiveRecord::Migration
  def change
    create_table :affiliations do |t|
      t.references :collection, null: false
      t.references :feature, null: false
      t.references :perspective, default: nil
      t.boolean :descendants, null: false, default: true
      t.timestamps
    end
    add_index :affiliations, [:collection_id, :feature_id, :perspective_id], name: 'affiliations_on_dependencies', unique: true
  end
end
