class Admin::CollectionsController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  edit.before do |r|
    @users = AuthenticatedSystem::User.includes(:person).order(['people.fullname', :login])
  end
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def collection_params
    params.require(:collection).permit(:name, :code, :description, user_ids: [])
  end
  
  private
  
  def collection
    @collection = Collection.search(params[:filter]).page(params[:page]).order('UPPER(name)')
  end
end