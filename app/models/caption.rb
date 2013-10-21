# == Schema Information
#
# Table name: captions
#
#  id          :integer          not null, primary key
#  language_id :integer          not null
#  content     :string(150)      not null
#  author_id   :integer          not null
#  feature_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Caption < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper
  
  attr_accessible :author_id, :content, :feature_id, :language_id
  belongs_to :feature
  belongs_to :language
  belongs_to :author, :class_name => 'AuthenticatedSystem::Person'
  
  validates :language_id, :uniqueness => {:scope => :feature_id}
  validates_length_of :content, :maximum => 140 #, :tokenizer => lambda { |str| HTML::FullSanitizer.new.sanitize(str, :tags=>[]).split(//) }
end
