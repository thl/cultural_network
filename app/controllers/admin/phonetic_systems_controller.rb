class Admin::PhoneticSystemsController < AclController
  resource_controller
  
  include KmapsEngine::SimplePropsControllerHelper
end