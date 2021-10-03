# == Schema Information
#
# Table name: simple_props
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  name        :string
#  notes       :text
#  type        :string
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
