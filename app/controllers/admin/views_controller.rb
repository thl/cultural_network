class Admin::ViewsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end