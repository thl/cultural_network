require 'kmaps_engine/import/feature_data'

module KmapsEngine
  class DataImport

    require "ftools"

    def self.cleanup
      ext='.rb'
      Dir['app/models/*'].each do |n|
        next if n[-3,3]!=ext
        name = File.basename(n, ext)
        Kernel.const_get(name.classify).all.map(&:destroy)
      end

      #Feature.all.each {|f| f.destroy}
      #FeatureObjectType.all.each {|f| f.destroy}
      #FeatureRelation.all.each {|f| f.destroy}
      #FeatureName.all.each {|f| f.destroy}
      #FeatureNameRelation.all.each {|f| f.destroy}
      #Timespan.all.each {|f| f.destroy}
      #ObjectType.all.each {|ft| ft.destroy}
    end

    def self.load_thesaurus
      # I think we aren't using the thesaurus anymore, but just in case, I'm leaving this in. 
      #fd.fetch_thesauri.each do |feature_type|
      #  feature_type.save
      #end

      #puts "Vocabulary.all.size = #{Vocabulary.all.size}"
    end

    def self.all(datasource)
      #self.cleanup
      fd = KmapsEngine::FeatureData.new( datasource )
      fd.fetch_feature_docs.each do |feature_doc|
        puts "processing #{feature_doc}"
        fd.parse_document(feature_doc)
        `mv #{feature_doc} #{feature_doc + '.done'}`
      end
    end

    def self.minimum(url)

    end

  end
end
