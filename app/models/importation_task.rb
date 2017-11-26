# == Schema Information
#
# Table name: importation_tasks
#
#  id         :integer          not null, primary key
#  task_code  :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImportationTask < ActiveRecord::Base
  has_many :spreadsheets, :class_name => 'ImportedSpreadsheet', :foreign_key => 'task_id', :dependent => :destroy
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(importation_tasks.task_code), filter_value))
  end
  
end
