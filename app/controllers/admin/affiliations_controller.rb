class Admin::AffiliationsController < AclController
  resource_controller
  
  belongs_to :feature
  before_action :collection
  
  def initialize
    super
    @guest_perms = []
  end
  
  create.wants.html { redirect_to admin_feature_url(object.feature) }
  update.wants.html { redirect_to admin_feature_url(object.feature) }
  destroy.wants.html { redirect_to admin_feature_url(object.feature) }

  new_action.before { get_collections }
  edit.before { get_collections }
  update.before { get_collections }
  
  private
  
  def get_collections
    @collections = Collection.order('name')
    @perspectives = Perspective.order('name')
  end
end