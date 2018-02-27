class ChangeGeoCodeTypeGeoCodeValueAndFeatureIdToNotNullForFeatureGeoCode < ActiveRecord::Migration[5.1]
  def up
    FeatureGeoCode.where(feature_id: nil).delete_all
    change_column :feature_geo_codes, :geo_code_type_id, :integer, null: false
    change_column :feature_geo_codes, :feature_id, :integer, null: false
    change_column :feature_geo_codes, :geo_code_value, :string, null: false
  end
  def down
    change_column :feature_geo_codes, :geo_code_type_id, :integer
    change_column :feature_geo_codes, :feature_id, :integer
    change_column :feature_geo_codes, :geo_code_value, :string
  end
end
