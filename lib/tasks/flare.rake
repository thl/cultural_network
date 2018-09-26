require 'kmaps_engine/flare_utils'
namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr. rake kmaps_engine:flare:reindex_all [FROM=fid] [TO=fid]"
    task :reindex_all => :environment do
      KmapsEngine::FlareUtils.reindex_all(from: ENV['FROM'], to: ENV['TO'], daylight: ENV['DAYLIGHT'])
    end
  end
end