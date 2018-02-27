class AssociationNotesController < ResourceController::Base
  belongs_to :feature
  
  def index
    unless parent_object.nil? && params[:association_type].blank?
      @notes = parent_object.association_notes_for(params[:association_type])
      render :partial => 'association_notes/list'
    end
  end
  
  def show
    unless parent_object.nil? && params[:association_type].blank?
      @note = AssociationNote.find(params[:id])
      render :partial => 'association_notes/show'
    end
  end
  
  private
  
end
