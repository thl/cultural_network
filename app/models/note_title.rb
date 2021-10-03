# == Schema Information
#
# Table name: note_titles
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime
#  updated_at :datetime
#

class NoteTitle < ActiveRecord::Base
  validates_presence_of :title
  has_many :notes, :dependent => :nullify
  
  def to_s
    self.title
  end

  def self.search(filter_value)
    self.where(build_like_conditions(%W(title), filter_value))
  end  
end
