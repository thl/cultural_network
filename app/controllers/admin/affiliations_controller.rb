class Admin::AffiliationsController < AclController
  resource_controller
  
  belongs_to :feature
  before_action :collection
  
  def initialize
    super
    @guest_perms = []
  end
  
  create.wants.html { redirect_to admin_feature_url(parent_object.fid) }
  update.wants.html { redirect_to admin_feature_url(parent_object.fid) }
  destroy.wants.html { redirect_to admin_feature_url(parent_object.fid) }

  new_action.before { get_collections }
  edit.before { get_collections }
  update.before { get_collections }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def affiliation_params
    params.require(:affiliation).permit(:collection_id, :feature_id, :perspective_id, :descendants, :skip_update)
  end
  
  private
  
  def get_collections
    @collections = Collection.order('name')
  end

end
