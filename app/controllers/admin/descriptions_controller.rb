class Admin::DescriptionsController < AclController
  include KmapsEngine::ResourceObjectAuthentication
  resource_controller
  
  cache_sweeper :description_sweeper, :only => [:update, :destroy]
  belongs_to :feature
  before_action :collection

  def initialize
    super
    @guest_perms = []
  end
  
  new_action.before do
    used_languages = parent_object.captions.collect(&:language_id)
    english = Language.get_by_code('eng')
    query = Language.order('name')
    @languages = used_languages.empty? ? query : query.where(['id NOT IN (?)', used_languages])
    object.language = english if !used_languages.include? english.id
  end
  
  edit.before do
    @languages = Language.order('name')
    @authors = AuthenticatedSystem::Person.order('fullname')
  end
  
  create.before do
    @languages = Language.order('name')
    defaults_primary
  end
  
  update.before do
    @languages = Language.order('name')
  end
  
  # renders add_author.js.erb
  def add_author
    @authors = AuthenticatedSystem::Person.order('fullname')
  end

  #def contract
  #  d = Description.find(params[:id])
  #  render :partial => 'contracted', :locals => {:feature => parent_object, :d => d}
  #end
  
  #def expand
  #  @d = Description.find(params[:id])
  #  @description =  Description.find(params[:id])
  #  render_descriptions
  #end
    
  private
  
  #def render_descriptions
  #  #find a way to save selected expanded description
  #  render :update do |page|
	#    yield(page) if block_given?
	#    page.replace_html 'descriptions_div', :partial => 'admin/descriptions/index', :locals => { :feature => parent_object, :description => @d}
	#  end
	#end
	    
  protected
  
  #
  # Override ResourceController collection method
  #
  def collection
    # needed for the list view
    @parent_object = parent_object if parent?
    
    feature_id=nil
    if params[:feature_id]
      feature_id = params[:feature_id]
    elsif params[:id]
      feature_id = object.feature_id
    end
    search_results = Description.search(params[:filter])
    search_results = search_results.where(['feature_id = ?', feature_id]) if feature_id
    @collection = search_results.page(params[:page])
  end
  
  def defaults_primary
    object.is_primary = 'true' if parent_object.descriptions.empty?
    object.is_primary = 'false' if object.is_primary.nil?
  end
end