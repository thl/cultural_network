# == Schema Information
#
# Table name: simple_props
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  description :text
#  name        :string(255)
#  notes       :text
#  type        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  simple_props_code_idx  (code)
#  simple_props_type_idx  (type)
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
