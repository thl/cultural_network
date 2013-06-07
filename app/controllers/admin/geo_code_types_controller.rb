class Admin::GeoCodeTypesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end