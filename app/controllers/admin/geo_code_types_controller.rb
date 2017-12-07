class Admin::GeoCodeTypesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def geo_code_type_params
    params.require(:geo_code_type).permit(:name, :code, :description)
  end
end