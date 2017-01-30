class Admin::IllustrationsController < AclController
  include KmapsEngine::ResourceObjectAuthentication
  resource_controller
  
  belongs_to :feature
  
  def initialize
    super
    @guest_perms = []
  end
  
  create.before do
    if params[:picture_type]=="MmsIntegration::Picture"
      object.picture_type = 'MmsIntegration::Picture'
    else
      object.picture = ExternalPicture.create(params[:external_picture])
    end
  end
  
  create.after do
    object.ensure_one_primary
  end
  
  update.after do
    object.ensure_one_primary
  end
  
  destroy.after do
    primary_illustrations = parent_object.illustrations.where(:is_primary => true)
    case primary_illustrations.count
    when 0
      other = parent_object.illustrations.order('updated_at ASC').first
      other.update_attribute(:is_primary, true) if !other.nil?
    when 1
    else
      keep = primary_illustrations.order('updated_at ASC').first
      primary_illustrations.where(['id <> ?', keep.id]).update_all(:is_primary => false) if !keep.nil?
    end
  end
  
  protected
  
  def parent_association
    parent_object.illustrations
  end
end