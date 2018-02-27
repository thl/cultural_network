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

class WritingSystem < SimpleProp  
  #
  #
  # Associations
  #
  #
  has_many :feature_names
  
  #
  #
  # Validation
  #
  #
  
  def is_latin?
    code == 'latin'
  end
end