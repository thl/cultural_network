class Perspective < ActiveRecord::Base
  include CulturalNetwork::SimplePropCache
  
  attr_accessible :is_public, :name, :code, :description
  
  #
  #
  # Associations
  #
  #
  include CulturalNetwork::IsCitable
  extend CulturalNetwork::HasTimespan
  
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
  
end

# == Schema Info
# Schema version: 20110923232332
#
# Table name: perspectives
#
#  id          :integer         not null, primary key
#  code        :string(255)
#  description :text
#  is_public   :boolean
#  name        :string(255)
#  notes       :text
#  created_at  :timestamp
#  updated_at  :timestamp