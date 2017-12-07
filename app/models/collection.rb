# == Schema Information
#
# Table name: simple_props
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :text
#  notes       :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Collection < SimpleProp
  has_many :affiliations, dependent: :destroy
  has_many :features, through: :affiliations
  has_and_belongs_to_many :users, class_name: 'AuthenticatedSystem::User', join_table: 'collections_users'
  
  def display_string
    return name unless name.blank?
    return code unless code.blank?
    ''
  end
end