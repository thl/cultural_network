class Admin::AssociationNotesController < AclController
  include KmapsEngine::ResourceObjectAuthentication
  resource_controller
  
  belongs_to :feature
  before_action :collection
  before_action :validate_association_type, :only => [:new]

  edit.before {@authors = AuthenticatedSystem::Person.order('fullname') }
  new_action.before do
    object.association_type = params[:association_type]
    object.notable_type = parent_object.class.name
  end

  create.wants.html { redirect_to polymorphic_url([:admin, object.notable, object]) }
  update.wants.html { redirect_to polymorphic_url([:admin, object.notable, object]) }
  destroy.wants.html { redirect_to polymorphic_url([:admin, object.notable]) }
  
  def initialize
    super
    @guest_perms = []
  end
  
  # renders add_author.js.erb
  def add_author
    @authors = AuthenticatedSystem::Person.order('fullname')
  end
  
  protected
  
  def parent_association
    parent_object.association_notes # ResourceController needs this for the parent association
  end
  
  def collection
    search_results = AssociationNote.search(params[:filter])
    search_results = search_results.where(['notable_id = ? AND notable_type = ?', parent_object.id, parent_object.class.to_s]) if parent?
    @collection = search_results.page(params[:page])
  end
  
  def validate_association_type
    render :text => "Sorry, an association type hasn't been specified." and return if (
      (object.nil? && params[:association_type].blank?) ||
      (!object.nil? && object.association_type.blank?))
  end
end