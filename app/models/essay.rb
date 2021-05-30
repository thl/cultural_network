class Essay < ApplicationRecord
  validates_presence_of :feature_id
  validates_presence_of :text_id
  
  belongs_to :feature, touch: true
  belongs_to :language
  
  def text
    ShantiIntegration::Text.find(self.text_id)
  end
end
