class FeatureNameRelation < ActiveRecord::Base
  attr_accessible :is_translation, :is_phonetic, :phonetic_system_id, :is_orthographic, :orthographic_system_id,
    :is_alt_spelling, :alt_spelling_system_id, :parent_node_id, :child_node_id, :ancestor_ids, :skip_update
  attr_accessor :skip_update

  acts_as_family_tree :tree, :node_class=>'FeatureName'
  
  after_save do |record|
    if !record.skip_update
      # we could update this object's (a FeatureRelation) hierarchy but the THL Places-app doesn't use that info in any way yet
      [record.parent_node, record.child_node].each {|r| r.update_hierarchy }
      feature = record.feature
      feature.update_name_positions
      feature.update_cached_feature_names
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
  extend CulturalNetwork::HasTimespan
  include CulturalNetwork::IsCitable
  include CulturalNetwork::IsNotable
  
  belongs_to :perspective
  belongs_to :phonetic_system
  belongs_to :alt_spelling_system
  belongs_to :orthographic_system
  
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

# == Schema Info
# Schema version: 20110923232332
#
# Table name: feature_name_relations
#
#  id                     :integer         not null, primary key
#  alt_spelling_system_id :integer
#  child_node_id          :integer         not null
#  orthographic_system_id :integer
#  parent_node_id         :integer         not null
#  phonetic_system_id     :integer
#  ancestor_ids           :string(255)
#  is_alt_spelling        :integer
#  is_orthographic        :integer
#  is_phonetic            :integer
#  is_translation         :integer
#  created_at             :timestamp
#  updated_at             :timestamp