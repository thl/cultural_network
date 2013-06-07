class Admin::WritingSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end