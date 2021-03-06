module CulturalNetwork
  module CategoryCachingUtils
    def self.clear_caching_tables
      CachedCategoryCount.connection.execute('TRUNCATE TABLE cached_category_counts')
      CumulativeCategoryFeatureAssociation.connection.execute('TRUNCATE TABLE cumulative_category_feature_associations')
    end

    def self.create_cumulative_feature_associations
      CategoryFeature.find(:all, :select =>'DISTINCT(category_id)', :order => 'category_id').collect(&:category).each do |category|
        if !category.nil?
          feature_ids = CategoryFeature.where(:category_id => category.id).order('feature_id').collect(&:feature_id)
          ([category] + category.ancestors).each do |c|
            feature_ids.each { |feature_id| CumulativeCategoryFeatureAssociation.create(:category_id => c.id, :feature_id => feature_id, :skip_update => true) if (c.id==category.id || c.cumulative?) && CumulativeCategoryFeatureAssociation.where(:category_id => c.id, :feature_id => feature_id).first.nil? }
            CachedCategoryCount.updated_count(c.id, true)
          end
        end
      end
    end

    def self.clear_feature_relation_category_table
      CachedFeatureRelationCategory.connection.execute('TRUNCATE TABLE cached_feature_relation_categories')
    end

    def self.create_feature_relation_categories
      Feature.find(:all).each{|f| f.update_cached_feature_relation_categories}
    end
  end
end