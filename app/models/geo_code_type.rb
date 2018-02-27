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

class GeoCodeType < SimpleProp
  has_many :feature_geo_codes
  has_many :features, :through => :feature_geo_codes
end