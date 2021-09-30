# == Schema Information
#
# Table name: feature_geo_codes
#
#  id               :integer          not null, primary key
#  geo_code_value   :string           not null
#  notes            :text
#  created_at       :datetime
#  updated_at       :datetime
#  feature_id       :integer          not null
#  geo_code_type_id :integer          not null
#  timespan_id      :integer
#

class FeatureGeoCode < ActiveRecord::Base
  belongs_to :feature, touch: true
  belongs_to :geo_code_type
  has_many :imports, :as => 'item', :dependent => :destroy

  validates :geo_code_value, presence: true
  
  # belongs_to :info_source, :class_name => 'Document'
  
  include KmapsEngine::IsCitable
  include KmapsEngine::IsNotable
  extend IsDateable
  extend KmapsEngine::HasTimespan
  
  def self.search(filter_value)
    # because a GeoCodeType is actualy a SimpleProp, this LIKE query should be checking simple_props (not geo_code_types)
    self.where(build_like_conditions(%W(feature_geo_codes.notes simple_props.code simple_props.name simple_props.notes), filter_value)
    ).includes([:feature, :geo_code_type]).references([:feature, :geo_code_type])
  end
  
  def to_s
    [geo_code_type.to_s, id.to_s].detect {|i| ! i.blank? }
  end
end
