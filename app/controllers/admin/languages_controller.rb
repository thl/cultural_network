class Admin::LanguagesController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end