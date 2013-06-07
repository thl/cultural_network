class Admin::BlurbsController < AclController
  resource_controller
  
  def collection
    @collection = Blurb.search(params[:filter]).page(params[:page])
  end
    
end
