class ChangeDatableIdAndDatableTypeToNotNullForTimespan < ActiveRecord::Migration[5.1]
  def up
    Timespan.where(dateable_id: nil).delete_all
    change_column :timespans, :dateable_id, :integer, null: false
    change_column :timespans, :dateable_type, :string, null: false
  end
  def down
    change_column :timespans, :dateable_id, :integer
    change_column :timespans, :dateable_type, :string
  end
end
