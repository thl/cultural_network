class AddPlaceIdToExternalPicture < ActiveRecord::Migration
  def change
    add_column :external_pictures, :place_id, :integer
  end
end
