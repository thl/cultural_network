class Admin::PerspectivesController < AclController
  resource_controller
  
  caches_page :index, if: Proc.new { |c| c.request.format.xml? || c.request.format.json? }
  cache_sweeper :perspective_sweeper, only: [:update, :destroy]
  
  def initialize
    super
    @guest_perms = ['admin/perspectives/index']
  end
  
  def collection
    @collection = Perspective.search(params[:filter]).page(params[:page])
  end
  
  index.wants.xml { render xml: JSON.parse(@collection.to_json).to_xml(root: :perspectives) }
  index.wants.json { render json: @collection }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def perspective_params
    params.require(:perspective).permit(:is_public, :name, :code, :description)
  end
end