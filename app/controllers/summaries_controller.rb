class SummariesController < ApplicationController
  caches_page :show, :index
  
  before_action :find_feature
  
  def show
    @summary = Summary.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml  => @summary }
      format.json { render :json => @summary } #Hash.from_xml(render_to_string(:action => 'show.xml.builder')) }
    end
  end

  def index
    @summaries = @feature.summaries
    respond_to do |format|
      format.xml  { render :xml  => @summaries }
      format.json { render :json => @summaries } #Hash.from_xml(render_to_string(:action => 'index.xml.builder')) }
    end
  end
  
  private
  # This is tied to features
  def find_feature
    @feature = Feature.get_by_fid(params[:feature_id]) # Feature.find(params[:feature_id])
  end
end
