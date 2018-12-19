module KmapsEngine
  module ProgressBar
    extend ActiveSupport::Concern
    STATUS_LENGTH = 36
    FID_LENGTH = 7

    included do
      attr_accessor :feature
      attr_accessor :log
      attr_accessor :bar
      attr_accessor :num_errors
      attr_accessor :valid_point
      attr_accessor :output
    end
    
    def initialize
      self.output = STDERR.tty? ? STDERR : STDOUT
      self.reset_progress_bar
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
        self.output.printf("\r%-#{STATUS_LENGTH*2}s\n", "\rDone. #{num} items processed with #{self.num_errors} errors.")
        self.reset_progress_bar
      else
        longitude = (num.to_f / total * STATUS_LENGTH).to_i
        if longitude > self.bar.size
          self.bar << (self.valid_point ? '=' : 'X')
          self.valid_point = true
        end
        if output.tty?
          self.output.printf("\rProcessing %-#{FID_LENGTH}s [%-#{STATUS_LENGTH}s]", current, self.bar)
        else
          self.output.puts("Processing #{current} (#{num}/#{total})")
        end
      end
    end

    module ClassMethods
    end
  end
end