class Admin::AltSpellingSystemsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
end