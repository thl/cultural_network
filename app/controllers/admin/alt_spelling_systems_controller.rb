class Admin::AltSpellingSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def alt_spelling_system_params
    params.require(:alt_spelling_system).permit(:name, :code, :description)
  end
end