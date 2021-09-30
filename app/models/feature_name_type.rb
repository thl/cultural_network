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

class FeatureNameType < SimpleProp
  
  # Link up the FeatureNames associated with this type
  # by using the FeatureName.feature_name_type_id value
  has_many :feature_names, :class_name=>'FeatureName', :source=>:feature_name_type_id, :dependent => :nullify
  
  #
  #
  # Validation
  #
  #
end
