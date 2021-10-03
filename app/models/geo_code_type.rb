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

class GeoCodeType < SimpleProp
  has_many :feature_geo_codes
  has_many :features, :through => :feature_geo_codes
end
