class Admin::CollectionsController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
  
  edit.before do |r|
    @users = AuthenticatedSystem::User.includes(:person).order(['people.fullname', :login])
  end
  
  private
  
  def collection
    @collection = Collection.search(params[:filter]).page(params[:page]).order('UPPER(name)')
  end
end