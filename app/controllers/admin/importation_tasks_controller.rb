class Admin::ImportationTasksController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  def collection
    @collection = ImportationTask.search(params[:filter]).page(params[:page])
  end
end
