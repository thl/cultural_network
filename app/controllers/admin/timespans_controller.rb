class Admin::TimespansController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  def collection
    @collection = Timespan.search(params[:filter]).page(params[:page])
  end
end