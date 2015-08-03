namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr."
    task :reindex_all => :environment do
      Feature.order(:fid).each do |f|
        puts "#{Time.now}: Reindexing #{f.fid}."
        f.update_solr
      end
    end
  end
end