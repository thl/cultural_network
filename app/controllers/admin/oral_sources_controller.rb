class Admin::OralSourcesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def oral_source_params
    params.require(:oral_source).permit(:name, :code, :description)
  end
end