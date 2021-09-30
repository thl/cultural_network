# == Schema Information
#
# Table name: web_pages
#
#  id          :integer          not null, primary key
#  path        :string(255)      not null
#  title       :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  citation_id :integer          not null
#

class WebPage < ActiveRecord::Base
  belongs_to :citation, touch: true
  has_many :imports, :as => 'item', :dependent => :destroy
  
  def web_url
    source = self.citation.info_source
    return '' if source.nil? || !self.citation.info_source_type.start_with?('MmsIntegration')
    source.web_url
  end
  
  def full_path
    domain = self.web_url
    domain = domain[0...domain.size-1] if domain.end_with?('/') && path.start_with?('/')
    "#{domain}#{path}"
  end
  
  def to_s
    "#{self.title} (#{self.full_path})"
  end
  
  def feature
    self.citation.feature
  end
end
