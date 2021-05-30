# == Schema Information
#
# Table name: timespans
#
#  id              :integer          not null, primary key
#  start_date      :date
#  end_date        :date
#  start_date_fuzz :integer
#  end_date_fuzz   :integer
#  is_current      :integer
#  dateable_id     :integer
#  dateable_type   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
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