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

class PhoneticSystem < SimpleProp
  
  def display_string
    return name unless name.blank?
    return code unless code.blank?
    ''
  end
  
  def is_pinyin?
    code == 'pinyin.transcrip'
  end
  
  def is_ind_transcrip?
    code == 'ind.transcrip'
  end
  
  def is_thl_simple_transcrip?
    code == 'thl_simple_transcrip'
  end  
end
