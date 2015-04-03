class Admin::FeaturesController < AclController
  resource_controller
  
  cache_sweeper :feature_sweeper, :only => [:update, :destroy]
  
  def initialize
    super
    @guest_perms = []
  end
  
  new_action.before { @object.fid = Feature.generate_pid }
  create.before do |r|
    @object.is_blank = false
  end
  update.before do |r|
    update_primary_description;
  end
  
  before_action :collection, :only=>:locate_for_relation
  
  def locate_for_relation
    @locating_relation=true
    # Remove the Feature that is currently looking for a relation
    # (shouldn't be possible to relate to itself)
    @collection = @collection.where.not(fid: object.fid)
    render :action=>:index
  end
  
  def set_primary_description
    @feature = Feature.find(params[:id])
    #render :action => 'primary_description_set'
  end
  
  def clone
    redirect_to admin_feature_url(Feature.find(params[:id]).clone_with_names)
  end
  
  private
  
  def collection
    filter = params[:filter]
    context_id = params[:context_id]
    page = params[:page]
    unless context_id.blank?
      @context_feature, @collection = Feature.contextual_search(context_id, filter).page(page)
    else
      @collection = Feature.search(Search.new(filter: filter, context_id: context_id)).page(page)
    end
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