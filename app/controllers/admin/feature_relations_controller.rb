class Admin::FeatureRelationsController < AclController
  include KmapsEngine::ResourceObjectAuthentication
  resource_controller
  
  belongs_to :feature
  
  def initialize
    super
    @guest_perms = []
  end
  
  new_action.before do |c|
    c.send :setup_for_new_relation
    get_perspectives
  end
  
  edit.before do
    get_perspectives
  end
  
  #create.before :process_feature_relation_type_id_mark
  update.before do
    process_feature_relation_type_id_mark
    get_perspectives
  end
  
  destroy.wants.html { redirect_to admin_feature_url(parent_object.fid) }
  
  #
  # The create.before wasn't being called (couldn't figure out why not; update.before works
  # fine), so create is done manually for now. This should be fixed.  
  #
  def create
    process_feature_relation_type_id_mark
    @object = FeatureRelation.new(params[:feature_relation])

    respond_to do |format|
      if @object.save
        flash[:notice] = 'Feature Relation was successfully created.'
        format.html { redirect_to(polymorphic_url [:admin, parent_object, object]) }
        format.xml  { render :xml => @object, :status => :created, :location => @object }
      else
        get_perspectives
        format.html { render :action => "new" }
        format.xml  { render :xml => @object.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  new_action.wants.html { redirect_if_unauthorized }
  
  protected
  
  # Only allow a trusted parameter "white list" through.
  def feature_relation_params
    params.require(:feature).permit(:perspective_id, :parent_node_id, :child_node_id, :feature_relation_type_id, :ancestor_ids, :skip_update)
  end
  
  private
  
  def collection
    feature_id = params[:feature_id]
    search_results = FeatureRelation.search(params[:filter])
    search_results = search_results.where(['parent_node_id = ? OR child_node_id = ?', feature_id, feature_id]) if feature_id
    @collection = search_results.page(params[:page])
  end
  
  #
  # Need to override the ResourceController::Helpers.parent_association method
  # to get the correct name of the parent association
  # Reminder: This is a subclass of ResourceController::Base
  #
  def parent_association
    if params[:id].nil?
      return parent_object.all_parent_relations 
    end
    # Gotta find it seperately, will get a recursive stack error elsewise
    o = FeatureRelation.find(params[:id])
    parent_object.id == o.parent_node.id ? parent_object.all_child_relations : parent_object.all_parent_relations
  end
  
  def setup_for_new_relation
    object.child_node = parent_object # ResourceController can't seem to set this up?
    object.parent_node = Feature.find(params[:target_id])
  end
  
  def process_feature_relation_type_id_mark
    if params[:feature_relation][:feature_relation_type_id] =~ /^_/
      swap_temp = params[:feature_relation][:child_node_id]
      params[:feature_relation][:child_node_id] = params[:feature_relation][:parent_node_id]
      params[:feature_relation][:parent_node_id] = swap_temp
    end
    params[:feature_relation][:feature_relation_type_id] = params[:feature_relation][:feature_relation_type_id].gsub(/^_/, '')
  end
  
  def get_perspectives
    @perspectives = parent_object.affiliations_by_user(current_user, descendants: true).collect(&:perspective)
    @perspectives = Perspective.order(:name) if current_user.admin? || @perspectives.include?(nil)
  end
end
