# == Schema Information
#
# Table name: note_titles
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class NoteTitle < ActiveRecord::Base
  attr_accessible :title
  
  validates_presence_of :title
  has_many :notes
  
  def to_s
    self.title
  end

  def self.search(filter_value)
    self.where(build_like_conditions(%W(title), filter_value))
  end  
end