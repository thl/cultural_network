# == Schema Information
#
# Table name: passages
#
#  id           :bigint           not null, primary key
#  content      :text             not null
#  context_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  context_id   :integer          not null
#

class Passage < ApplicationRecord
  include KmapsEngine::IsCitable

  belongs_to :context, polymorphic: true, touch: true

  validates_presence_of :content
  
  def feature
    self.context.feature
  end
end
