class Admin::PerspectivesController < AclController
  resource_controller
  
  def collection
    @collection = Perspective.search(params[:filter]).page(params[:page])
  end
end