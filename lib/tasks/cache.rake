namespace :cache do
  namespace :tree do
    desc 'Run to preheat cache for all nodes of the browse tree.'
    task :heat => :environment do
      require 'kmaps_engine/tree_cache'
      fid = ENV['FID']
      perspective_code = ENV['PERSPECTIVE']
      view_code = ENV['VIEW']
      start = Time.now
      puts "#{start}: Creating cache files#{" for #{fid}" if !fid.blank?}..."
      KmapsEngine::TreeCache.reheat(fid, perspective_code, view_code) # nil specifies that all nodes should be re-created. Otherwise, this is the id for the node whose descendants and self should be re-generated
      stop = Time.now
      puts "#{stop}: Finished successfully. Time lapsed: #{stop - start}"
    end
  end
  namespace :db do
    namespace :name do
      desc 'Run to update names by view.'
      task :update do
        puts 'Updating names by view...'
        Feature.update_cached_feature_names
        puts 'Finished successfully.'
      end
    end
  end
end