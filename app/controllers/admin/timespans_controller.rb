class Admin::TimespansController < AclController
  resource_controller
  
  def collection
    @collection = Timespan.search(params[:filter]).page(params[:page])
  end
end