# == Schema Information
#
# Table name: summaries
#
#  id          :integer          not null, primary key
#  language_id :integer          not null
#  content     :text             not null
#  author_id   :integer          not null
#  feature_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Summary < ActiveRecord::Base
  belongs_to :feature
  belongs_to :language
  belongs_to :author, :class_name => 'AuthenticatedSystem::Person'
  has_many :imports, :as => 'item', :dependent => :destroy
  
  validates :language_id, :uniqueness => {:scope => :feature_id}
  validates_length_of :content, :within => 1..750, :tokenizer => lambda { |str| str.strip_tags.split(//) }
  
  include KmapsEngine::IsCitable
end
