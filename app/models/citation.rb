# == Schema Information
#
# Table name: citations
#
#  id             :integer          not null, primary key
#  info_source_id :integer
#  citable_type   :string(255)
#  citable_id     :integer
#  notes          :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Citation < ActiveRecord::Base
  attr_accessible :info_source_id, :notes, :citable_id, :citable_type
  
  attr_accessor :marked_for_deletion
  
  #
  #
  # Associations
  #
  #
  belongs_to :info_source, :polymorphic => true
  belongs_to :citable, :polymorphic=>true
  has_many :pages, :dependent => :destroy
  has_many :web_pages, :dependent => :destroy
  has_many :imports, :as => 'item', :dependent => :destroy
  
  #
  #
  # Validation
  #
  #
  
  alias :_info_source info_source
  def info_source
    self.info_source_type.start_with?('MmsIntegration') ? self.info_source_type.constantize.find(self.info_source_id) : _info_source
  end
  
  def to_s
    citable.to_s
  end
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(citations.notes), filter_value))
  end
end