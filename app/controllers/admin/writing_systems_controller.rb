class Admin::WritingSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def writing_system_params
    params.require(:writing_system).permit(:name, :code, :description)
  end
end