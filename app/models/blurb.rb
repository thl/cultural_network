# == Schema Information
#
# Table name: blurbs
#
#  id         :bigint           not null, primary key
#  code       :string
#  content    :text
#  title      :string
#  created_at :datetime
#  updated_at :datetime
#

class Blurb < ActiveRecord::Base
  #
  #
  # Validation
  #
  #
  validates_format_of :code, :with=>/\w+/
  validates_uniqueness_of :code
  
  def to_s
    code.to_s
  end
  
  def self.search(filter_value)
    where(build_like_conditions(%W(blurbs.code blurbs.title blurbs.content), filter_value))
  end
end
