# == Schema Information
#
# Table name: summaries
#
#  id          :bigint           not null, primary key
#  content     :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  author_id   :integer          not null
#  feature_id  :integer          not null
#  language_id :integer          not null
#

class Summary < ActiveRecord::Base
  belongs_to :feature, touch: true
  belongs_to :language
  belongs_to :author, :class_name => 'AuthenticatedSystem::Person'
  has_many :imports, :as => 'item', :dependent => :destroy
  
  validates :language_id, :uniqueness => {:scope => :feature_id}
  validates :plain_content, length: 1..750
  
  include KmapsEngine::IsCitable

  def plain_content
    content.strip_tags
  end
end
