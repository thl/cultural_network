require 'kmaps_engine/progress_bar'

module KmapsEngine
  class FlareUtils
    include KmapsEngine::ProgressBar
    
    def reindex_all(from:, to:, daylight:)
      from_i = from.blank? ? nil : from.to_i
      to_i = to.blank? ? nil : to.to_i
      features = Feature.where(is_public: true).order(:fid)
      features = features.where(['fid >= ?', from_i]) if !from_i.nil?
      features = features.where(['fid <= ?', to_i]) if !to_i.nil?
      i = 0
      self.log.debug { "#{Time.now}: Starting reindexing." }
      total = features.size
      puts "#{Time.now}: Indexing of #{total} features about to start..."
      self.wait_if_business_hours(daylight)
      features.each do |f|
        begin
          if f.queued_index(priority: Flare::IndexerJob::LOW)
            self.log.debug { "#{Time.now}: Reindexed #{f.pid}." }
          else
            self.say "#{Time.now}: #{f.pid} failed."
          end
          self.progress_bar(num: i, total: total, current: f.pid)
        rescue Exception => e
          STDOUT.flush
          self.log.fatal { "#{Time.now}: An error occured when processing #{Process.pid}:" }
          self.say "#{Time.now}: #{f.pid} failed."
          self.log.fatal { e.message }
          self.log.fatal { e.backtrace.join("\n") }
        end
        i += 1
      end
      puts "#{Time.now}: Reindexing done."
      self.log.debug "#{Time.now}: Reindexing done."
    end
    
    def reindex_fids(fids, daylight)
      i = 0
      view = View.get_by_code('roman.scholar')
      total = fids.size
      puts "#{Time.now}: Indexing of #{total} items about to start..."
      self.log.debug { "#{Time.now}: Starting reindexing." }
      self.log.debug { "#{Time.now}: Features to index: #{fids.join(', ')}." }
      self.wait_if_business_hours(daylight)
      fids.each do |fid|
        begin
          f = Feature.get_by_fid(fid)
          if f.queued_index(priority: Flare::IndexerJob::LOW)
            name = f.prioritized_name(view)
            self.log.debug { "#{Time.now}: Reindexed #{name.name if !name.blank?} (#{f.pid})." }
          else
            self.say "#{Time.now}: #{f.pid} failed."
          end
          self.progress_bar(num: i, total: total, current: f.pid)
        rescue Exception => e
          self.log.fatal { "#{Time.now}: An error occured when processing #{Process.pid}:" }
          self.say "#{Time.now}: #{f.pid} failed."
          self.log.fatal { e.message }
          self.log.fatal { e.backtrace.join("\n") }
        end
        i += 1
      end
      puts "#{Time.now}: Reindexing done."
      self.log.debug "#{Time.now}: Reindexing done."
    end
    
    def self.index_cleanup
      query = "tree:#{Feature.uid_prefix}"
      numFound = Feature.search_by(query)['numFound']
      puts 'Fetching uids from index.'
      resp = Feature.search_by(query, fl: 'uid', rows: numFound)['docs']
      features_indexed = resp.collect{|f| f['uid'].split('-').last.to_i}
      puts 'Fetching uids from db.'
      features_in_db = Feature.all.where(is_public: 1).order(:fid).select(:fid).distinct.collect(&:fid)
      features_not_indexed = features_in_db - features_indexed
      features_indexed_not_in_db = features_indexed - features_in_db
      puts "Indexing #{features_indexed_not_in_db.size} features not in index."
      features_not_indexed.each { |fid| Feature.get_by_fid(fid).queued_index }
      puts "Deleting #{features_not_indexed.size} docs not in db."
      slices = features_indexed_not_in_db.each_slice(10).to_a
      slices.each{ |s| Feature.remove(s)}
      Feature.commit
    end
    
    def self.reindex_stale_since_all(additional_classes = [])
      d = DateTime.parse(Feature.oldest_document['_timestamp_'])
      classes = [Affiliation, CachedFeatureName, Caption, Citation, Description, Essay, Feature, FeatureGeoCode, FeatureNameRelation, FeatureName, FeatureRelation, Illustration, Note, Page, Passage, Summary, TimeUnit, WebPage] + additional_classes
      puts 'Fetching index timestamps.'
      query = "tree:#{Feature.uid_prefix}"
      numFound = Feature.search_by(query)['numFound']
      resp = Feature.search_by(query, fl: 'uid,_timestamp_', rows: numFound)['docs']
      timestamps = {}
      resp.collect{|f| timestamps[f['uid'].split('-').last.to_i] = f['_timestamp_']}
      count = 0
      classes.each do |klass|
        begin
          a = klass.where(['updated_at > ?', d]).includes(:feature)
          a.first
        rescue ActiveRecord::AssociationNotFoundError => e
          a = klass.where(['updated_at > ?', d])
        end
        puts "Reindexing #{Feature.model_name.human(count: :many)} for #{a.count} #{klass.model_name.human(count: :many)}."
        a.each do |e|
          f = e.feature
          if timestamps[f.fid].nil? || !timestamps[f.fid].instance_of?(DateTime)
            timestamps[f.fid] = timestamps[f.fid].nil? ? f.updated_at - 1.day : DateTime.parse(timestamps[f.fid])
            if f.updated_at > timestamps[f.fid]
              f.queued_index
              count += 1
            end
          end
        end
      end
      puts "Reindexing a total of #{count} features."
    end
  end
end