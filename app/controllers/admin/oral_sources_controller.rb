class Admin::OralSourcesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end