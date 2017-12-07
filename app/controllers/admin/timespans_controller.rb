class Admin::TimespansController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  def collection
    @collection = Timespan.search(params[:filter]).page(params[:page])
  end
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def timespan_params
    params.require(:timespan).permit(:is_current)
  end
end