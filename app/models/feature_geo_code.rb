class FeatureGeoCode < ActiveRecord::Base
  attr_accessible :geo_code_type_id, :geo_code_value
  
  belongs_to :feature
  belongs_to :geo_code_type
  # belongs_to :info_source, :class_name => 'Document'
  
  include CulturalNetwork::IsCitable
  include CulturalNetwork::IsNotable
  extend IsDateable
  extend CulturalNetwork::HasTimespan
  
  def self.search(filter_value)
    # because a GeoCodeType is actualy a SimpleProp, this LIKE query should be checking simple_props (not geo_code_types)
    self.where(build_like_conditions(%W(feature_geo_codes.notes simple_props.code simple_props.name simple_props.notes), filter_value)
    ).includes([:feature, :geo_code_type])
  end
  
  def to_s
    [geo_code_type.to_s, id.to_s].detect {|i| ! i.blank? }
  end
  
end

# == Schema Info
# Schema version: 20110923232332
#
# Table name: feature_geo_codes
#
#  id               :integer         not null, primary key
#  feature_id       :integer
#  geo_code_type_id :integer
#  timespan_id      :integer
#  geo_code_value   :string(255)
#  notes            :text
#  created_at       :timestamp
#  updated_at       :timestamp