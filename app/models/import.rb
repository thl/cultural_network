# == Schema Information
#
# Table name: imports
#
#  id             :bigint           not null, primary key
#  item_type      :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  item_id        :integer          not null
#  spreadsheet_id :integer          not null
#

class Import < ActiveRecord::Base
  #attr_accessible :item_id, :item_type, :spreadsheet_id, :item
  
  belongs_to :spreadsheet, :class_name => 'ImportedSpreadsheet'
  belongs_to :item, :polymorphic => true
end
