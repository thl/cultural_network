namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid] [TO=fid]"
    task :reindex_all => :environment do
      features = Feature.where(is_public: true).order(:fid)
      from = ENV['FROM']
      to = ENV['TO']
      features = features.where(['fid >= ?', from.to_i]) if !from.blank?
      features = features.where(['fid <= ?', to.to_i]) if !to.blank?
      count = 0
      current = 0
      interval = 100
      while current<features.size
        limit = current + interval
        limit = features.size if limit > features.size
        sid = Spawnling.new do
          puts "Spawning sub-process #{Process.pid}."
          features[current...limit].each do |f|
            if f.index
              puts "#{Time.now}: Reindexed #{f.fid}."
            else
              puts "#{Time.now}: #{f.fid} failed."
            end
          end
          Feature.commit
        end
        Spawnling.wait([sid])
        current = limit
      end
    end
  end
end