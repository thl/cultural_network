class Admin::PagesController < AclController
  resource_controller
  
  belongs_to :citation
  
  def initialize
    super
    @guest_perms = []
  end
  
  create.wants.html { redirect_to polymorphic_url([:admin, object.citation.citable, object.citation]) }
  update.wants.html { redirect_to polymorphic_url([:admin, object.citation.citable, object.citation]) }
  destroy.wants.html { redirect_to polymorphic_url([:admin, object.citation.citable, object.citation]) }
  
  protected
  
  def parent_association
    parent_object.pages # ResourceController needs this for the parent association
  end
  
  def collection
    @collection = Page.where(:citation_id => parent_object.id).page(params[:page])
  end
end