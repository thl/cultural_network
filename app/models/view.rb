# == Schema Information
#
# Table name: simple_props
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  name        :string
#  notes       :text
#  type        :string
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
