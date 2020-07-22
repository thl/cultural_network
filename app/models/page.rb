# == Schema Information
#
# Table name: pages
#
#  id          :integer          not null, primary key
#  citation_id :integer
#  volume      :integer
#  start_page  :integer
#  start_line  :integer
#  end_page    :integer
#  end_line    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Page < ActiveRecord::Base
  belongs_to :citation
  has_many :imports, :as => 'item', :dependent => :destroy
  
  validate :presence_of_some_data
  
  def presence_of_some_data
    errors.add(:base, 'All fields cannot be blank!') if volume.nil? && start_page.nil? && start_line.nil? && end_page.nil? && end_line.nil?
  end
  
  def to_s
    s = volume.nil? ? '' : "#{volume}: "
    s << start_page.to_s if !start_page.nil?
    s << ".#{start_line}" if !start_line.nil?
    if (!start_page.nil? || !start_line.nil?) && (!end_page.nil? || !end_line.nil?) && (start_page != end_page || start_line != end_line)
      s << " - "
      s << end_page.to_s if !end_page.nil?
      if !end_line.nil?
        s << '.' if !end_page.nil?
        s << end_line.to_s
      end
    end
    s
  end
end