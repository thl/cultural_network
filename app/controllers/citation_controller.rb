class CitationController < ResourceController::Base
  belongs_to :description, :feature_geo_code, :feature_name, :feature_name_relation, :feature_relation
  
  def index
    unless parent_object.nil?
      @citations = parent_object.citations
      @parent_object = parent_object
      render :partial => '/citations/list'
    end
  end
end
