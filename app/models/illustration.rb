# == Schema Information
#
# Table name: illustrations
#
#  id           :integer          not null, primary key
#  feature_id   :integer          not null
#  picture_id   :integer          not null
#  picture_type :string(255)      not null
#  is_primary   :boolean          default(TRUE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Illustration < ActiveRecord::Base
  attr_accessible :feature_id, :is_primary, :picture_id, :picture_type, :picture_attributes
  
  belongs_to :feature
  belongs_to :picture, :polymorphic => true
  
  accepts_nested_attributes_for :picture
  
  before_destroy {|record| record.picture.destroy if record.picture.instance_of?(ExternalPicture)}
  
  alias :_picture picture
  def picture
    self.picture_type == 'MmsIntegration::Picture' ? MmsIntegration::Picture.find(picture_id) : _picture
  end
  
  def to_s
    self.picture.instance_of?(MmsIntegration::Picture) ? self.picture.get_url(nil, :format => '') : self.picture.url
  end
end
