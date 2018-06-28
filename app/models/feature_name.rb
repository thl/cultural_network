# == Schema Information
#
# Table name: feature_names
#
#  id                          :integer          not null, primary key
#  feature_id                  :integer          not null
#  name                        :string(255)      not null
#  feature_name_type_id        :integer
#  ancestor_ids                :string(255)
#  position                    :integer          default(0)
#  etymology                   :text
#  writing_system_id           :integer
#  language_id                 :integer          not null
#  created_at                  :datetime
#  updated_at                  :datetime
#  is_primary_for_romanization :boolean          default(FALSE)
#

class FeatureName < ActiveRecord::Base
  attr_accessor :skip_update
  acts_as_family_tree :node, nil, tree_class: 'FeatureNameRelation'
  
  after_update do |record|
    #Rails.cache.write('tree_tmp', ( feature.parent.nil? ? feature.id : feature.parent.id))
    if !record.skip_update
      feature = record.feature
      record.ensure_one_primary
      views = feature.update_cached_feature_names
      views = (views + CachedFeatureName.where(feature_name_id: record.id).select(:view_id).collect(&:view_id)).uniq if record.name_changed?
    end
  end #{ |record| record.update_hierarchy
  
  # Too much for the importer to deal with!
  #after_destroy do |record|
  #  feature = record.feature
  #  feature.update_cached_feature_names
  #  feature.touch
  #end
  
  after_create do |record|
    if !record.skip_update
      record.ensure_one_primary
      feature = record.feature
      feature.update_name_positions
      views = feature.update_cached_feature_names
    end
  end
  
  after_destroy do |record|
    if !record.skip_update
      feature = record.feature
      views = feature.update_cached_feature_names
    end
  end
  
  # acts_as_solr
  
  extend KmapsEngine::HasTimespan
  include KmapsEngine::IsCitable
  extend IsDateable
  include KmapsEngine::IsNotable
  
  #
  # Associations
  #
  
  belongs_to :feature
  belongs_to :language
  belongs_to :writing_system, optional: true
  belongs_to :type, class_name: 'FeatureNameType', foreign_key: :feature_name_type_id, optional: true
  # belongs_to :info_source, :class_name => 'Document'
  has_many :cached_feature_names, dependent: :destroy
  has_many :imports, as: 'item', dependent: :destroy
  
  #
  #
  # Validation
  #
  #
  validates_presence_of :feature_id, :name, :language_id
  validates_numericality_of :position
  
  def to_s
    name
  end
  
  def name_details
    "#{self.language.to_s}, #{self.writing_system.to_s}, #{self.pp_display_string}"
  end
    
  def detailed_name
    "#{self.name} (#{self.name_details})"
  end
  
  def relationship_code
    r = parent_relations.first
    r = r.relationship if !r.nil?
    return r if r.nil? || r.instance_of?(String)
    r.code
  end
  
  def display_string
    return 'Original' if is_original?
    parent_relations.first.display_string
  end
  
  def pp_display_string
    return 'Original' if is_original?
    parent_relations.first.pp_display_string
  end
  
  def is_original?
    parent_relations.empty?
  end
  
  def in_western_language?
    Language.is_western_id? self[:language_id]
  end
  
  def in_language_without_transcription_system?
    Language.lacks_transcription_system_id? self.id
  end
  
  #
  # Defines Comparable module's <=> method
  #
  def <=>(object)
    return -1 if object.language.nil?
    # Put Chinese when sorting
    return -1 if object.language.code == 'zho'
    return 1 if object.language.code == 'eng'
    return self.name <=> object.name
  end
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(feature_names.name feature_names.etymology), filter_value))
  end
  
  def ensure_one_primary
    parent = self.feature
    primary_names = parent.names.where(is_primary_for_romanization: true)
    case primary_names.count
    when 0
    when 1
    else
      keep = self.is_primary_for_romanization? ? self : primary_names.order('updated_at DESC').first
      primary_names.where(['id <> ?', keep.id]).update_all(is_primary_for_romanization: false) if !keep.nil?
    end
  end
end
