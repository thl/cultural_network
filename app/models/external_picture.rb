# == Schema Information
#
# Table name: external_pictures
#
#  id         :bigint           not null, primary key
#  caption    :text
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  place_id   :integer
#

class ExternalPicture < ActiveRecord::Base
  has_many :illustrations, :as => :picture, :dependent => :destroy
  
  validates :url, presence: true
  
  after_save do |record|
    illustrations.each { |illustration| illustration.touch }
  end
  
  def width
    nil
  end
  
  def height
    nil
  end
  
  def shanti_image?
    @array ||= url.split('/')
    i = @array.find_index{|e| e.starts_with? 'cicada'}
    !i.nil?
  end
  
  def shanti_image
    return nil if !self.shanti_image?
    i = @array.find_index{|e| e.starts_with? 'shanti-image'}
    e = @array[i]
    id = e.split('-').last.to_i
    id==0 ? nil : ExternalPicture.from_shanti_image(id)
  end
  
  def self.from_shanti_image(id)
    uri = URI("https://images.mandala.library.virginia.edu/api/imginfo/siid/#{id}")
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    nid_str = json['nid']
    return nil if nid_str.nil?
    nid = nid_str.to_i
    shanti_image = ShantiIntegration::Image.find(nid)
    shanti_image.nil? ? nid : shanti_image
  end
end
