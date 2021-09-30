# == Schema Information
#
# Table name: xml_documents
#
#  id         :integer          not null, primary key
#  document   :text             not null
#  created_at :datetime
#  updated_at :datetime
#  feature_id :integer          not null
#
# Indexes
#
#  xml_documents_feature_id_idx  (feature_id)
#

class XmlDocument < ActiveRecord::Base
  
  belongs_to :feature, touch: true
  
end
