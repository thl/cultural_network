class NamesController < ApplicationController
  caches_page :index, :show
  
  before_filter :find_feature
  
  def show
    @name = FeatureName.find(params[:id])
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'show.xml.builder')) }
    end
  end
  
  def index
    @names = @feature.names.roots.order('position')
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'index.xml.builder')) }
    end
  end
  
  private
  # This is tied to features
  def find_feature
    @feature = Feature.get_by_fid(params[:feature_id]) # Feature.find(params[:feature_id])
  end
end
