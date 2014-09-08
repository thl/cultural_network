# == Schema Information
#
# Table name: feature_name_relations
#
#  id                     :integer          not null, primary key
#  child_node_id          :integer          not null
#  parent_node_id         :integer          not null
#  ancestor_ids           :string(255)
#  is_phonetic            :integer
#  is_orthographic        :integer
#  is_translation         :integer
#  is_alt_spelling        :integer
#  phonetic_system_id     :integer
#  orthographic_system_id :integer
#  alt_spelling_system_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

class FeatureNameRelation < ActiveRecord::Base
  attr_accessible :is_translation, :is_phonetic, :phonetic_system_id, :is_orthographic, :orthographic_system_id,
    :is_alt_spelling, :alt_spelling_system_id, :parent_node_id, :child_node_id, :ancestor_ids, :skip_update
  attr_accessor :skip_update

  acts_as_family_tree :tree, nil, :node_class=>'FeatureName'
  
  after_save do |record|
    if !record.skip_update
      # we could update this object's (a FeatureRelation) hierarchy but the THL Places-app doesn't use that info in any way yet
      [record.parent_node, record.child_node].each {|r| r.update_hierarchy }
      feature = record.feature
      feature.update_name_positions
      views = feature.update_cached_feature_names
      # logger.error "Cache expiration: triggered for saving a feature name relation for #{feature.fid}."
      feature.expire_tree_cache(:views => views) if !views.blank?
    end
  end
  
  after_destroy do |record|
    if !record.skip_update
      # we could update this object's (a FeatureRelation) hierarchy but the THL Places-app doesn't use that info in any way yet
      [record.parent_node, record.child_node].each {|r| r.update_hierarchy }
      feature = record.feature
      views = feature.update_cached_feature_names
      # logger.error "Cache expiration: triggered for deleting a feature name relation for #{feature.fid}."
      feature.expire_tree_cache(:views => views) if !views.blank?
    end
  end
  
  #TYPES=[
  #  
  #]
  
  #
  #
  # Associations
  #
  #
  extend KmapsEngine::HasTimespan
  include KmapsEngine::IsCitable
  include KmapsEngine::IsNotable
  
  belongs_to :perspective
  belongs_to :phonetic_system
  belongs_to :alt_spelling_system
  belongs_to :orthographic_system
  has_many :imports, :as => 'item', :dependent => :destroy
  
  def to_s
    "\"#{child_node}\" relation to \"#{parent_node}\""
  end
  
  def display_string
    return "phonetic-#{phonetic_system.name.downcase}" unless phonetic_system.blank?
    return "orthographic-#{orthographic_system.name.downcase}" unless orthographic_system.blank?
    return "alt-spelling-#{alt_spelling_system.name.downcase}" unless alt_spelling_system.blank?
    return "translation" unless is_translation.blank?
    "Unknown Relation"
  end
  
  def pp_display_string
    return "Transcription-#{phonetic_system.name}" unless phonetic_system.blank?
    return "Transliteration-#{orthographic_system.name}" unless orthographic_system.blank?
    return "Alt Spelling-#{alt_spelling_system.name}" unless alt_spelling_system.blank?
    return "Translation" unless is_translation.blank?
    "Unknown Relation"
  end
  
  #
  # Returns the feature that owns this FeatureNameRelation
  #
  def feature
    child_node.feature
  end
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(children.name parents.name), filter_value)
    ).joins('LEFT JOIN feature_names parents ON parents.id=feature_name_relations.parent_node_id LEFT JOIN feature_names children ON children.id=feature_name_relations.child_node_id')
  end
end