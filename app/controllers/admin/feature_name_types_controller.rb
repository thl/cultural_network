class Admin::FeatureNameTypesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def feature_name_type_params
    params.require(:feature_name_type).permit(:name, :code, :description)
  end
end