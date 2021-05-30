# == Schema Information
#
# Table name: notes
#
#  id                :integer          not null, primary key
#  notable_type      :string(255)
#  notable_id        :integer
#  note_title_id     :integer
#  custom_note_title :string(255)
#  content           :text
#  created_at        :datetime
#  updated_at        :datetime
#  association_type  :string(255)
#  is_public         :boolean          default(TRUE)
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