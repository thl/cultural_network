# == Schema Information
#
# Table name: pages
#
#  id                 :bigint           not null, primary key
#  chapter            :integer
#  end_line           :integer
#  end_page           :integer
#  end_verse          :integer
#  start_line         :string
#  start_page         :integer
#  start_verse        :integer
#  tibetan_start_page :string
#  volume             :string
#  created_at         :datetime
#  updated_at         :datetime
#  citation_id        :integer          not null
#

class Page < ActiveRecord::Base
  belongs_to :citation, touch: true
  has_many :imports, :as => 'item', :dependent => :destroy
  
  #validate :presence_of_some_data
  
  def presence_of_some_data
    errors.add(:base, 'All fields cannot be blank!') if volume.nil? && start_page.nil? && start_line.nil? && end_page.nil? && end_line.nil?
  end
  
  def to_s
    s = volume.nil? ? '' : "#{volume}: "
    s << "ch. #{chapter} " if !chapter.nil?
    if !start_verse.nil? 
      if end_verse.nil? || start_verse==end_verse
        s << "verse #{start_verse} "
      else
        s << "verses #{start_verse} - #{end_verse} "
      end
    end
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
    s << " (#{tibetan_start_page})" if !tibetan_start_page.nil?
    s.strip
  end
  
  def feature
    self.citation.feature
  end
end
