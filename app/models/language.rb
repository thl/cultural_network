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

class Language < SimpleProp  
  #
  #
  # Associations
  #
  #
  has_many :captions
  has_many :descriptions
  has_many :feature_names
  has_many :summaries
  
  #
  # Validation
  #
  #
  
  ## Language codes should all come from ISO 639-2 available at http://www.loc.gov/standards/iso639-2/php/code_list.php
  validates_format_of :code, :with => /\A[a-z]{3}\z/
  validates_uniqueness_of :code
  
  def is_chinese?
    code == 'zho'
  end
  
  def is_english?
    code == 'eng'
  end
  
  def is_nepali?
    code == 'nep'
  end
  
  def is_tibetan?
    code == 'bod'
  end
  
  def is_western?
    Language.is_western_id? self.id
  end
  
  def self.current
    self.find_by(['code LIKE ?', "#{I18n.locale}%"])
  end

  def self.available_as_locales
    self.where("code ILIKE ANY ( array[?] )", I18n.available_locales.map {|loc| "#{loc}%"}).order('name')
  end

  def self.mandala_text_mappings
    @@mandala_text_lang ||= {
      "subjects-570"   => self.find_by(['code LIKE ?', "eng"]).id,
      "subjects-676"   => self.find_by(['code LIKE ?', "dzo"]).id,
      "subjects-9237"  => self.find_by(['code LIKE ?', "zho"]).id,
      "subjects-638"   => self.find_by(['code LIKE ?', "bod"]).id,
      "subjects-4233"  => self.find_by(['code LIKE ?', "bod"]).id
    }
  end

  def lacks_transcription_system?
    Language.lacks_transcription_system_id? self.id
  end
      
  def self.is_western_id?(language_id)
    @@western_ids ||= [:eng, :ger, :spa, :pol, :lat, :ita].collect{|code| self.get_by_code(code) }
    @@western_ids.include? language_id
  end
  
  def self.lacks_transcription_system_id?(language_id)
    @@lacks_transcription_system_ids ||= [:urd, :ara, :mya, :jpn, :kor, :pli, :pra, :san, :sin, :tha].collect{|code| self.get_by_code(code)}
    @@lacks_transcription_system_ids.include? language_id
  end
end
