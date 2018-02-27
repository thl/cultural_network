# == Schema Information
#
# Table name: external_pictures
#
#  id         :integer          not null, primary key
#  url        :string(255)      not null
#  caption    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  place_id   :integer
#

class ExternalPicture < ActiveRecord::Base
  has_many :illustrations, :as => :picture, :dependent => :destroy
  
  def width
    nil
  end
  
  def height
    nil
  end
end
