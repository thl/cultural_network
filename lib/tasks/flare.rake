require 'kmaps_engine/flare_utils'

namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid] [TO=fid] [DAYLIGHT=daylight] [LOG_LEVEL=0..5]"
    task :reindex_all => :environment do
      KmapsEngine::FlareUtils.new("log/reindexing_#{Rails.env}.log", ENV['LOG_LEVEL']).reindex_all(from: ENV['FROM'], to: ENV['TO'], daylight: ENV['DAYLIGHT'])
    end
    
    desc "Deletes from index features not in db and indexes features in db not in index."
    task :cleanup => :environment do
      KmapsEngine::FlareUtils.new("log/cleaning_#{Rails.env}.log", ENV['LOG_LEVEL']).index_cleanup
    end
    
    desc "Reindexes features updated after last full reindex."
    task :reindex_stale_since_all => :environment do
      KmapsEngine::FlareUtils.reindex_stale_since_all
    end
  end
end