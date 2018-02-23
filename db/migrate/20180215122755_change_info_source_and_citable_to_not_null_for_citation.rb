class ChangeInfoSourceAndCitableToNotNullForCitation < ActiveRecord::Migration[5.1]
  def up
    Citation.where(info_source_id: nil).delete_all
    Citation.where(citable_id: nil).delete_all
    change_column :citations, :info_source_id, :integer, null: false
    change_column :citations, :citable_id, :integer, null: false
    change_column :citations, :citable_type, :string, null: false
  end
  def down
    change_column :citations, :info_source_id, :integer
    change_column :citations, :citable_id, :integer
    change_column :citations, :citable_type, :string
  end
end
