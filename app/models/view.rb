# == Schema Information
#
# Table name: simple_props
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :text
#  notes       :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
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