# == Schema Information
#
# Table name: cached_feature_names
#
#  id              :bigint           not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  feature_id      :integer          not null
#  feature_name_id :integer
#  view_id         :integer          not null
#
# Indexes
#
#  index_cached_feature_names_on_feature_id_and_view_id  (feature_id,view_id) UNIQUE
#

class CachedFeatureName < ActiveRecord::Base
  attr_accessor :skip_update
  
  validates_presence_of :feature_id, :view_id
  
  belongs_to :feature
  belongs_to :view
  belongs_to :feature_name, optional: true
end
