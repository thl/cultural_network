module KmapsEngine
  module ProgressBar
    extend ActiveSupport::Concern

    STATUS_LENGTH = 36
    FID_LENGTH = 7
    START_HOUR = 8
    END_HOUR = 17
    
    included do
      attr_accessor :feature
      attr_accessor :log
      attr_accessor :bar
      attr_accessor :num_errors
      attr_accessor :valid_point
      attr_accessor :output
    end

    def initialize(log_file = nil, log_level = nil)
      self.output = STDERR.tty? ? STDERR : STDOUT
      self.reset_progress_bar
      create_log(log_file, log_level) if !log_file.blank?
    end

    def create_log(log_file, log_level)
      self.log = ActiveSupport::Logger.new(log_file)
      self.log.level = log_level.nil? ? Rails.logger.level : log_level.to_i
    end

    def close_log
      self.log.close
    end

    def say(msg)
      self.log.error { "#{Time.now}: #{msg}" }
      self.num_errors += 1
      self.valid_point = false
    end

    def reset_progress_bar
      self.bar = ''
      self.valid_point = true
      self.num_errors = 0
    end

    def update_progress_bar(bar:, valid_point:, num_errors:)
      self.bar = bar
      self.valid_point = valid_point
      self.num_errors = num_errors
    end

    def progress_bar(num:, total:, current:)
      if num==total-1
        self.output.printf("\r%-#{STATUS_LENGTH*2}s\n", "\rDone. #{total} items processed with #{self.num_errors} errors.")
        self.reset_progress_bar
      else
        longitude = (num.to_f / total * STATUS_LENGTH).to_i
        if longitude > self.bar.size
          self.bar << (self.valid_point ? '=' : 'X')
          self.valid_point = true
        end
        if output.tty?
          self.output.printf("\rProcessed %-#{FID_LENGTH}s [%-#{STATUS_LENGTH}s]", current, self.bar)
        else
          self.output.puts("Processed #{current} (#{num}/#{total})")
        end
      end
    end


    module ClassMethods

      def wait_if_business_hours(daylight)
        return if daylight.blank?
        now = self.now
        end_time = self.end_time
        if !(now.saturday? || now.sunday?) && self.start_time<now && now<end_time
          delay = self.end_time - now
          self.log.debug { "#{Time.now}: Resting until #{end_time}..." }
          sleep(delay)
        end
      end

      protected

      def now
        Time.now
      end

      def start_time
        now = self.now
        Time.new(now.year, now.month, now.day, START_HOUR)
      end

      def end_time
        now = self.now
        Time.new(now.year, now.month, now.day, END_HOUR)
      end
    end
  end
end
