class Admin::OrthographicSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def orthographic_system_params
    params.require(:orthographic_system).permit(:name, :code, :description)
  end
end