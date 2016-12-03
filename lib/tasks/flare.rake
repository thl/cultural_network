namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid]"
    task :reindex_all => :environment do
      features = Feature.where(is_public: true).order(:fid)
      from = ENV['FROM']
      features = features.where(['fid >= ?', from.to_i]) if !from.blank?
      count = 0
      features.each do |f|
        if f.index
          puts "#{Time.now}: Reindexed #{f.fid}."
          Feature.commit if (count+=1) % 1000 == 0 # Do commit every 1000 updates
        else
          puts "#{Time.now}: #{f.fid} failed."
        end
      end
      Feature.commit
    end
  end
end