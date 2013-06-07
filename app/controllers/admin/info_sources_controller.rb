class Admin::InfoSourcesController < AclController
  resource_controller
  
  def collection
    @collection = InfoSource.search(params[:filter]).page(params[:page]).order('UPPER(code)')
  end
end