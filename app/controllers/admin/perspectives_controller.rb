class Admin::PerspectivesController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = ['admin/perspectives/index']
  end
  
  def collection
    @collection = Perspective.search(params[:filter]).page(params[:page])
  end
  
  index.wants.xml { render :xml => @collection }
  index.wants.json { render :json => @collection }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def perspective_params
    params.require(:perspective).permit(:is_public, :name, :code, :description)
  end
end