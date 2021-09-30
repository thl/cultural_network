# == Schema Information
#
# Table name: essays
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  feature_id  :bigint           not null
#  language_id :integer          not null
#  text_id     :integer          not null
#
# Indexes
#
#  index_essays_on_feature_id  (feature_id)
#
# Foreign Keys
#
#  fk_rails_...  (feature_id => features.id)
#
class Essay < ApplicationRecord
  validates_presence_of :feature_id
  validates_presence_of :text_id
  
  belongs_to :feature, touch: true
  belongs_to :language
  
  def text
    ShantiIntegration::Text.find(self.text_id)
  end
end
