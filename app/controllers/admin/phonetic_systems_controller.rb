class Admin::PhoneticSystemsController < AclController
  resource_controller
  
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def phonetic_system_params
    params.require(:phonetic_system).permit(:name, :code, :description)
  end
end