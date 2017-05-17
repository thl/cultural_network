class Admin::FeaturesController < AclController
  include KmapsEngine::ResourceObjectAuthentication
  resource_controller
  
  cache_sweeper :feature_sweeper, :only => [:update, :destroy]
  
  def initialize
    super
    @guest_perms = []
  end

  before_action :collection, only: :locate_for_relation
  
  new_action.before do
    object.fid = Feature.generate_pid
    object.is_public = true
    parent_id = params.require(:parent_id)
    @parent = parent_id.blank? ? nil : Feature.get_by_fid(parent_id) 
    if !@parent.nil?
      @perspectives = @parent.affiliations_by_user(current_user, descendants: true).collect(&:perspective)
      @perspectives = Perspective.order(:name) if @perspectives.include?(nil) || current_user.admin?
      @name = FeatureName.new(language_id: Language.get_by_code('eng').id, writing_system_id: WritingSystem.get_by_code('latin').id, is_primary_for_romanization: true)
      @relation = FeatureRelation.new(parent_node_id: @parent.id)
    end
  end
  
  create.after do |r|
    if !object.id.nil?
      object.names.create(params[:feature_name])
      relation = object.all_parent_relations.create(params[:feature_relation])
      affiliations = object.affiliations
      relation.parent_node.affiliations.where(descendants: true).each { |a| affiliations.create(perspective_id: a.perspective.nil? ? nil : a.perspective.id, collection_id: a.collection.id, descendants: true) }
    else
      object.fid = Feature.generate_pid
      object.is_public = true
      parent_id = params[:feature_relation][:parent_node_id]
      @parent = parent_id.blank? ? nil : Feature.find(parent_id)
      if !@parent.nil?
        @perspectives = @parent.affiliations_by_user(current_user, descendants: true).collect(&:perspective)
        @perspectives = Perspective.order(:name) if @perspectives.include? nil
        @name = FeatureName.new(params[:feature_name])
        @relation = FeatureRelation.new(params[:feature_relation])
      end
    end
  end
  
  update.before { |r| update_primary_description }

  create.wants.html  { redirect_to admin_feature_url(object.fid) }
  update.wants.html  { redirect_to admin_feature_url(object.fid) }
  destroy.wants.html { redirect_to admin_root_url }
  
  def locate_for_relation
    @locating_relation=true
    # Remove the Feature that is currently looking for a relation
    # (shouldn't be possible to relate to itself)
    @collection = @collection.where.not(fid: object.fid)
    render :action=>:index
  end
  
  def set_primary_description
    @feature = Feature.get_by_fid(params[:id])
    #render :action => 'primary_description_set'
  end
  
  def clone
    redirect_to admin_feature_url(Feature.get_by_fid(params[:id]).clone_with_names.fid)
  end
  
  private
  def object
    @object ||= Feature.get_by_fid(params[:id])
  end
  
  def collection
    filter = params[:filter]
    context_id = params[:context_id]
    page = params[:page]
    unless context_id.blank?
      @context_feature, @collection = Feature.contextual_search(context_id, filter)
    else
      @collection = Feature.search(Search.new(filter: filter, context_id: context_id))
    end
    @collection = @collection.joins(:affiliations).where(affiliations: {collection_id: current_user.collections.collect(&:id)}) if !current_user.admin?
    @collection = @collection.page(page)
  end
  
  def update_primary_description
    if !params[:primary].nil? 
      feat = Feature.find(params[:id])
      primary_desc = Description.find(params[:primary])
      feat.descriptions.update_all("is_primary = false")
      feat.descriptions.update_all("is_primary = true","id=#{primary_desc.id}")
    end
  end
end