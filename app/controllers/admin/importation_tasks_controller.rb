class Admin::ImportationTasksController < AclController
  resource_controller
  
  def collection
    @collection = ImportationTask.search(params[:filter]).page(params[:page])
  end
end
