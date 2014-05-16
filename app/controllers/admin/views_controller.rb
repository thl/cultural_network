class Admin::ViewsController < AclController
  resource_controller

  include KmapsEngine::SimplePropsControllerHelper
  
  def initialize
    super
    @guest_perms = ['admin/views/index']
  end

  index.wants.xml { render :xml => @collection }
  index.wants.json { render :json => @collection }
end