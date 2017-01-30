class Admin::NotesController < AclController
  resource_controller
  
  belongs_to :description, :feature_geo_code, :feature_name, :feature_name_relation, :feature_relation, :time_unit
  before_action :collection
  
  def initialize
    super
    @guest_perms = []
  end

  edit.before {@authors = AuthenticatedSystem::Person.order('fullname') }

  create.wants.html { redirect_to polymorphic_url([:admin, object.notable, object]) }
  update.wants.html { redirect_to polymorphic_url([:admin, object.notable, object]) }
  destroy.wants.html { redirect_to polymorphic_url([:admin, object.notable]) }
  
  def add_author
    @authors = AuthenticatedSystem::Person.order('fullname')
    # renders add_author.js.erb
  end
    
  protected
  
  def parent_association
    parent_object.notes # ResourceController needs this for the parent association
  end
  
  def collection
    search_results = Note.search(params[:filter])
    search_results = search_results.where(['notable_id = ? AND notable_type = ?', parent_object.id, parent_object.class.to_s]) if parent?
    @collection = search_results.page(params[:page])
  end
end