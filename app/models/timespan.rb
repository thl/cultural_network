# == Schema Information
#
# Table name: timespans
#
#  id              :integer          not null, primary key
#  dateable_type   :string           not null
#  end_date        :date
#  end_date_fuzz   :integer
#  is_current      :integer
#  start_date      :date
#  start_date_fuzz :integer
#  created_at      :datetime
#  updated_at      :datetime
#  dateable_id     :integer          not null
#
# Indexes
#
#  timespans_1_idx           (dateable_id,dateable_type)
#  timespans_end_date_idx    (end_date)
#  timespans_start_date_idx  (start_date)
#

class Timespan < ActiveRecord::Base
  belongs_to :dateable, polymorphic: true, touch: true
  
  def to_s
    id.to_s
  end
  
  def self.search(filter_value)
    # Empty constraints here... ? what conditions for timespan search?
    self.where(build_like_conditions(%W(), filter_value))
  end
end
