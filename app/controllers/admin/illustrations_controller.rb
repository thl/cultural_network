class Admin::IllustrationsController < AclController
  resource_controller
  
  belongs_to :feature
  
  create.before do
    if params[:picture_type]=="MmsIntegration::Picture"
      object.picture_type = 'MmsIntegration::Picture'
    else
      object.picture = ExternalPicture.create(params[:external_picture])
    end
  end
  
  protected
  
  def parent_association
    @parent_object ||= parent_object
    @parent_object.illustrations
  end
end