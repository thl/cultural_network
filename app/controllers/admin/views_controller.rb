class Admin::ViewsController < AclController
  resource_controller

  include KmapsEngine::SimplePropsControllerHelper
  
  def initialize
    super
    @guest_perms = ['admin/views/index']
  end

  index.wants.xml { render :xml => @collection }
  index.wants.json { render :json => @collection }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def view_params
    params.require(:view).permit(:name, :code, :description)
  end
end