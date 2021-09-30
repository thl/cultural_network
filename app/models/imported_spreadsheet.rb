# == Schema Information
#
# Table name: imported_spreadsheets
#
#  id          :integer          not null, primary key
#  filename    :string(255)      not null
#  imported_at :datetime         not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  task_id     :integer          not null
#

class ImportedSpreadsheet < ActiveRecord::Base
  #attr_accessible :filename, :importation_task_id, :imported_at
  belongs_to :task, :class_name => 'ImportationTask'
  has_many :imports, :class_name => 'Import', :foreign_key => 'spreadsheet_id', :dependent => :destroy
end
