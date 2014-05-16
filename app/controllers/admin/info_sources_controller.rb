class Admin::InfoSourcesController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  def collection
    @collection = InfoSource.search(params[:filter]).page(params[:page]).order('UPPER(code)')
  end
end