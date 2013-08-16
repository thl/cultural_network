# == Schema Information
#
# Table name: imports
#
#  id             :integer          not null, primary key
#  spreadsheet_id :integer          not null
#  item_id        :integer          not null
#  item_type      :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Import < ActiveRecord::Base
  attr_accessible :item_id, :item_type, :spreadsheet_id, :item
  
  belongs_to :spreadsheet, :class_name => 'ImportedSpreadsheet'
  belongs_to :item, :polymorphic => true
end
