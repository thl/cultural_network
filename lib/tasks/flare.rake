namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid]"
    task :reindex_all => :environment do
      features = Feature.where(is_public: true).order(:fid)
      from = ENV['FROM']
      features = features.where(['fid >= ?', from.to_i]) if !from.blank?
      features.each do |f|
        if f.update_solr
          puts "#{Time.now}: Reindexed #{f.fid}."
        else
          puts "#{Time.now}: #{f.fid} failed."
        end
      end
    end
  end
end