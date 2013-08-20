# == Schema Information
#
# Table name: external_pictures
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  caption    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ExternalPicture < ActiveRecord::Base
  attr_accessible :caption, :url
  
  has_many :illustrations, :as => :picture
end
