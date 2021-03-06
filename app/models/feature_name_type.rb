class FeatureNameType < SimpleProp
  
  # Link up the FeatureNames associated with this type
  # by using the FeatureName.feature_name_type_id value
  has_many :feature_names, :class_name=>'FeatureName', :source=>:feature_name_type_id
  
  #
  #
  # Validation
  #
  #
  
end

# == Schema Info
# Schema version: 20110923232332
#
# Table name: simple_props
#
#  id          :integer         not null, primary key
#  code        :string(255)
#  description :text
#  name        :string(255)
#  notes       :text
#  type        :string(255)
#  created_at  :timestamp
#  updated_at  :timestamp