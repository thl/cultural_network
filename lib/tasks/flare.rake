require 'kmaps_engine/flare_utils'

namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid] [TO=fid] [FIDS=fid1,fid2,...] [DAYLIGHT=daylight] [LOG_LEVEL=0..5]"
    task reindex_all: :environment do
      KmapsEngine::FlareUtils.new("log/reindexing_#{Rails.env}.log", ENV['LOG_LEVEL']).reindex_all(from: ENV['FROM'], to: ENV['TO'], fids: ENV['FIDS'], daylight: ENV['DAYLIGHT'])
    end
    
    desc "Deletes from index features not in db and indexes features in db not in index."
    task cleanup: :environment do
      KmapsEngine::FlareUtils.new("log/cleaning_#{Rails.env}.log", ENV['LOG_LEVEL']).index_cleanup
    end
    
    desc "Reindexes features updated after last full reindex."
    task reindex_stale_since_all: :environment do
      KmapsEngine::FlareUtils.reindex_stale_since_all
    end
    
    desc "Create solr documents in filesystem. rake kmaps_engine:flare:fs_reindex_all [FROM=fid] [TO=fid] [FIDS=fid1,fid2,...] [DAYLIGHT=daylight] [LOG_LEVEL=0..5] [FORCE=true|false]"
    task fs_reindex_all: :environment do
      force = true
      force_str = ENV['FORCE']
      force = force_str.strip.downcase=='false' if !force_str.blank?
      KmapsEngine::FlareUtils.new("log/reindexing_#{Rails.env}.log", ENV['LOG_LEVEL']).reindex_all(from: ENV['FROM'], to: ENV['TO'], fids: ENV['FIDS'], daylight: ENV['DAYLIGHT']) do |f|
        f.fs_index(force)
      end
    end
  end
end