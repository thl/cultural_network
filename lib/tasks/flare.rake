namespace :kmaps_engine do
  namespace :flare do
    desc "Reindex all features in solr."
    task :reindex_all => :environment do
      features = Feature.where(is_public: true).order(:fid)
      from = ENV['FROM']
      features = features.where(['fid >= ?', from.to_i]) if !from.blank?
      features.each do |f|
        puts "#{Time.now}: Reindexing #{f.fid}."
        f.update_solr
      end
    end
  end
end