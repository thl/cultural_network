# == Schema Information
#
# Table name: perspectives
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  code        :string(255)
#  description :text
#  notes       :text
#  is_public   :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Perspective < ActiveRecord::Base
  include KmapsEngine::SimplePropCache
  
  attr_accessible :is_public, :name, :code, :description
  
  #
  #
  # Associations
  #
  #
  include KmapsEngine::IsCitable
  extend KmapsEngine::HasTimespan
  
  #
  #
  # Validation
  #
  #
  validates_presence_of :name
  validates_format_of :code, :with=>/\w+/
  validates_uniqueness_of :code
      
  def to_s
    name
  end
  
  def self.name_and_id_list
    self.all.collect {|ft| [ft.name, ft.id] }
  end
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(simple_props.name simple_props.code simple_props.description simple_props.notes), filter_value))
  end

  def self.find_all_public
    self.where(:is_public => true).order('name')
  end
  
  def self.update_or_create(attributes)
    r = self.find_by(code: attributes[:code])
    r.nil? ? self.create(attributes) : r.update_attributes(attributes)
  end
end