class Admin::FeatureNameTypesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end