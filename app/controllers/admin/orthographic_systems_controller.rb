class Admin::OrthographicSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end