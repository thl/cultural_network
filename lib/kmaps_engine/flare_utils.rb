module KmapsEngine
  class FlareUtils
    
    INTERVAL = 100
    START_HOUR=8
    END_HOUR = 17
    
    def self.reindex_all(options)
      from = options[:from]
      to = options[:to]
      daylight = options[:daylight]
      from_i = from.blank? ? nil : from.to_i
      to_i = to.blank? ? nil : to.to_i
      features = Feature.where(is_public: true).order(:fid)
      features = features.where(['fid >= ?', from_i]) if !from_i.nil?
      features = features.where(['fid <= ?', to_i]) if !to_i.nil?
      
      count = 0
      current = 0
      puts "#{Time.now}: Indexing of #{features.size} features about to start..."
      while current<features.size
        limit = current + INTERVAL
        limit = features.size if limit > features.size
        self.wait_if_business_hours(daylight)
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
    
    def self.reindex_fids(fids, daylight)
      count = 0
      current = 0
      view = View.get_by_code('roman.scholar')
      puts "#{Time.now}: Indexing of #{fids.size} terms about to start..."
      while current<fids.size
        limit = current + INTERVAL
        limit = fids.size if limit > fids.size
        self.wait_if_business_hours(daylight)
        sid = Spawnling.new do
          puts "Spawning sub-process #{Process.pid}."
          fids[current...limit].each do |fid|
            f = Feature.get_by_fid(fid)
            if f.index
              name = f.prioritized_name(view)
              puts "#{Time.now}: Reindexed #{name.name if !name.blank?} (#{f.fid})."
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
    
    def self.wait_if_business_hours(daylight)
      return if daylight.blank?
      now = self.now
      end_time = self.end_time
      if now.wday<6 && self.start_time<now && now<end_time
        delay = self.end_time-now
        puts "#{Time.now}: Resting until #{end_time}..."
        sleep(delay)
      end
    end
    
    private
    
    def self.now
      Time.now
    end
    
    def self.start_time
      now = self.now
      Time.new(now.year, now.month, now.day, START_HOUR)
    end
    
    def self.end_time
      now = self.now
      Time.new(now.year, now.month, now.day, END_HOUR)
    end    
  end
end