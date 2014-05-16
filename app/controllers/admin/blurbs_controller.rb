class Admin::BlurbsController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  def collection
    @collection = Blurb.search(params[:filter]).page(params[:page])
  end
    
end
