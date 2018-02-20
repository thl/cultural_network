# == Schema Information
#
# Table name: citations
#
#  id               :integer          not null, primary key
#  info_source_id   :integer
#  citable_type     :string(255)
#  citable_id       :integer
#  notes            :text
#  created_at       :datetime
#  updated_at       :datetime
#  info_source_type :string(255)      not null
#

class Citation < ActiveRecord::Base
  include ActiveModel::Validations
  
  attr_accessor :marked_for_deletion
  
  #
  #
  # Associations
  #
  #
  belongs_to :info_source, polymorphic: true
  belongs_to :citable, polymorphic: true
  has_many :pages, dependent: :destroy
  has_many :web_pages, dependent: :destroy
  has_many :imports, as: 'item', dependent: :destroy
  
  #
  #
  # Validation
  #
  #
  validates :info_source_id, :citable_id, :citable_type, :info_source_type, presence: true
  validates :info_source_id, presence: true
  validate :presence_of_external_info_source
  
  def presence_of_external_info_source
    if self.info_source_type.start_with?('MmsIntegration')
      info_source = self.info_source_type.constantize.find(self.info_source_id)
      errors.add(:base, 'MMS record could not be found!') if info_source.nil?
    elsif self.info_source_type=='ShantiIntegration::Source'
      info_source = self.info_source_type.constantize.find(self.info_source_id)
      errors.add(:base, 'Shanti source record could not be found!') if info_source.nil?
    end
  end
  
  alias :_info_source info_source
  def info_source
    self.info_source_type.start_with?('MmsIntegration') || self.info_source_type=='ShantiIntegration::Source' ? self.info_source_type.constantize.find(self.info_source_id) : _info_source
  end
  
  def to_s
    citable.to_s
  end
  
  def self.search(filter_value)
    self.where(build_like_conditions(%W(citations.notes), filter_value))
  end
end
