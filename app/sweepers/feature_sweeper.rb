class FeatureSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  include ActionController::Caching::Actions
  
  observe Feature, FeatureName, FeatureRelation
  FORMATS = ['xml', 'json']
  
  def after_save(record)
    expire_cache(record) #if record.is_a?(Feature)
  end
  
  def after_destroy(record)
    expire_cache(record) #if record.is_a?(Feature)
  end
  
  def expire_cache(record)
    return if record.skip_update
    Spawnling.new do
      already_reindexed = []
      if record.instance_of? Feature
        feature = record
        return if feature.ancestor_ids_changed?
      elsif record.instance_of?(FeatureRelation)
        feature = record.child_node
        perspective = record.perspective
        perspective_id = perspective.id
        descendants = feature.descendants_by_perspective_with_parent(perspective).collect(&:first) + [record.parent_node]
        descendants.each do |f|
          Rails.cache.delete("features/#{f.fid}/parent_by_perspective/#{perspective_id}")
          Rails.cache.delete("features/#{f.fid}/closest_parent_by_perspective/#{perspective_id}")
          Rails.cache.delete("features/#{f.fid}/closest_hierarchical_feature_by_perspective/#{perspective_id}")
          Rails.cache.delete("features/#{f.fid}/ancestors_by_perspective/#{perspective_id}")
          Rails.cache.delete("features/#{f.fid}/closest_ancestors_by_perspective/#{perspective_id}")
          if f.is_public? && !already_reindexed.include?(f.fid)
            f.index
            already_reindexed << f.fid
          end
        end
      else #if record.instance_of? FeatureName
        feature = record.feature
      end
      options = {:only_path => true}
      # Relevant for solr:
      if feature.destroyed?
        feature.remove!
      elsif feature.is_public? && !already_reindexed.include?(feature.fid)
        feature.index
        already_reindexed << feature.fid
      end
      feature.parents.each do |f|
        if f.is_public? && !already_reindexed.include?(f.fid)
          f.index
          already_reindexed << f.fid
        end
      end
      feature.children.each do |f|
        if f.is_public? && !already_reindexed.include?(f.fid)
          f.index
          already_reindexed << f.fid
        end
      end
      Feature.commit
      FORMATS.each do |format|
        options[:format] = format
        if record.instance_of?(Feature)
          expire_full_path_page feature_url(feature.fid, options)
          expire_full_path_page related_feature_url(feature.fid, options)
        elsif record.instance_of?(FeatureName)
          expire_full_path_page feature_url(feature.fid, options)
          expire_full_path_page feature_names_url(feature.fid, options)
          expire_full_path_page feature_name_url(feature.fid, record.id, options)
          expire_full_path_page related_feature_url(feature.fid, options)
        elsif record.instance_of?(FeatureRelation)
          expire_full_path_page feature_url(record.parent_node.fid, options)
          child_node = record.child_node
          expire_full_path_page related_feature_url(child_node.fid, options)
        end
      end
      options[:format] = 'csv'
      ancestors_and_self = feature.ancestors + [feature]
      for f in ancestors_and_self
        expire_full_path_page feature_url(f.fid, options)
      end
    end
  end
end