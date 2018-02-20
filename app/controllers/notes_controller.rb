class NotesController < ResourceController::Base
  belongs_to :description, :feature_geo_code, :feature_name, :feature_name_relation, :feature_relation, :time_unit
  
  def index
    unless parent_object.nil?
      @notes = parent_object.public_notes
      render :partial => '/notes/list'
    end
  end
end
