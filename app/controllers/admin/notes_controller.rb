class Admin::NotesController < AclController
  resource_controller
  
  belongs_to :description, :feature_geo_code, :feature_name, :feature_name_relation, :feature_relation, :time_unit
  before_action :collection
  
  def initialize
    super
    @guest_perms = []
  end

  new_action.before do
    object.notable_type = parent_object.class.name
  end
  
  edit.before {@authors = AuthenticatedSystem::Person.order('fullname') }

  create.wants.html { redirect_to polymorphic_url(stacked_parents) }
  update.wants.html { redirect_to polymorphic_url(stacked_parents) }
  destroy.wants.html { redirect_to polymorphic_url(stacked_parents) }
  
  def add_author
    @authors = AuthenticatedSystem::Person.order('fullname')
    # renders add_author.js.erb
  end
    
  protected
  
  def stacked_parents
    array = [:admin]
    if !parent_object.instance_of?(Feature) && parent_object.respond_to?(:feature)
      array << parent_object.feature
    end
    array << parent_object
    array
  end
  
  def parent_association
    parent_object.notes # ResourceController needs this for the parent association
  end
  
  def collection
    search_results = Note.search(params[:filter])
    search_results = search_results.where(['notable_id = ? AND notable_type = ?', parent_object.id, parent_object.class.to_s]) if parent?
    @collection = search_results.page(params[:page])
  end
  
  # Only allow a trusted parameter "white list" through.
  def note_params
    params.require(:note).permit(:custom_note_title, :note_title_id, :content, :is_public, :id, :author_ids, :notable_type, :notable_id)
  end
end