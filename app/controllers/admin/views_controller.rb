class Admin::ViewsController < AclController
  resource_controller
  include KmapsEngine::SimplePropsControllerHelper
  
  caches_page :index, :if => Proc.new { |c| c.request.format.xml? || c.request.format.json? }
  cache_sweeper :view_sweeper, :only => [:update, :destroy]
  
  def initialize
    super
    @guest_perms = ['admin/views/index']
  end

  index.wants.xml { render xml: JSON.parse(@collection.to_json).to_xml(root: :views) }
  index.wants.json { render :json => @collection }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def view_params
    params.require(:view).permit(:name, :code, :description)
  end
end