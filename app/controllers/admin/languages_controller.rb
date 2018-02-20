class Admin::LanguagesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def language_params
    params.require(:language).permit(:name, :code, :description)
  end
end