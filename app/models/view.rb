# == Schema Information
#
# Table name: simple_props
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :text
#  name        :string(255)
#  notes       :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  simple_props_code_idx  (code)
#  simple_props_type_idx  (type)
#

class View < SimpleProp
  
  #
  #
  # Associations
  #
  #
  has_many :cached_feature_names, dependent: :delete_all
  
  include KmapsEngine::IsCitable
  extend KmapsEngine::HasTimespan
  
  #
  #
  # Validation
  #
  #
  validates_presence_of :name
    
  def to_s
    name
  end
end
