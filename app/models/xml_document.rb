# == Schema Information
#
# Table name: xml_documents
#
#  id         :integer          not null, primary key
#  feature_id :integer          not null
#  document   :text             not null
#  created_at :datetime
#  updated_at :datetime
#

class XmlDocument < ActiveRecord::Base
  
  belongs_to :feature, touch: true
  
end