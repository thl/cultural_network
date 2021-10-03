# == Schema Information
#
# Table name: notes
#
#  id                :bigint           not null, primary key
#  association_type  :string
#  content           :text             not null
#  custom_note_title :string
#  is_public         :boolean          default(TRUE)
#  notable_type      :string           not null
#  created_at        :datetime
#  updated_at        :datetime
#  notable_id        :integer          not null
#  note_title_id     :integer
#

class AssociationNote < Note
  belongs_to :feature, foreign_key: 'notable_id', touch: true
  
  # AssociationNote uses single-table inheritance from Note, so we need to make sure that no Notes are
  # returned by .find. 
  def self.default_scope
    where('association_type IS NOT NULL')
  end
  
  def self.find_by_object_and_association(object, association)
    self.where(:notable_type => object.class.name, :association_type => association)
  end
  
  def association_type_name
    association_type.blank? ? '' : model_display_name(association_type.tableize.singularize).humanize
  end
end
