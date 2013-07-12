class FeaturesController < ApplicationController
  caches_page :show, :all, :children, :list
  caches_action :node_tree_expanded, :cache_path => Proc.new {|c| cache_path}
  
  #
  #
  def index
    set_common_variables(session)
    
    @feature = Feature.find(session[:interface][:context_id]) unless session[:interface][:context_id].blank?
    @tab_options = {:entity => @feature}
    @current_tab_id = :home
    
    @active_menu_item = 'search'

    # In the event that a Blurb with this code doesn't exist, fail gracefully
    @intro_blurb = KmapsEngine::ApplicationSettings.homepage_blurb || Blurb.new
        
    respond_to do |format|
      format.html
      format.xml  #{ render :xml => Feature.current_roots(Perspective.get_by_code(default_perspective_code), View.get_by_code('roman.popular')).to_xml }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'index.xml.builder')) }
    end
  end

  #
  #
  #
  def show
    @feature = Feature.get_by_fid(params[:id])
    respond_to do |format|
      format.html do
        if @feature.nil?
          redirect_to features_url
        else
          set_common_variables(session)
          session[:interface][:context_id] = @feature.id unless @feature.nil?
          @tab_options = {:entity => @feature}
          @current_tab_id = :place
        end
      end
      format.xml
      format.csv
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'show.xml.builder')) }
    end
  end

  #
  #
  #
  def iframe
    @feature = Feature.find(params[:id])
    render :action => 'iframe', :layout => 'iframe'
  end
  
  def by_geo_code
    set_common_variables(session)
    geo_code_type_str = params[:geo_code_type]
    geo_code_type = GeoCodeType.get_by_code(geo_code_type_str)
    @feature = nil
    if !geo_code_type.nil?
      geo_code = FeatureGeoCode.where(:geo_code_type_id => geo_code_type.id, :geo_code_value => params[:geo_code]).first
      @feature = geo_code.feature if !geo_code.nil?
    end
    respond_to do |format|
      format.html { render :action => 'show' }
      format.xml  { render :action => 'show' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'show.xml.builder')), :callback => params[:callback] }
    end
  end
    
  #
  #
  #
  def by_fid
    feature_array = params[:fids].split(/\D+/)
    feature_array.shift if feature_array.size>0 && feature_array.first.blank?
    @features =  feature_array.collect{|feature_id| Feature.get_by_fid(feature_id.to_i)}.find_all{|f| f && f.is_public==1}
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    respond_to do |format|
      format.html { render :action => 'staff_show' }
      format.xml  { render :action => 'index' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'index.xml.builder')), :callback => params[:callback] }
    end
  end

  #
  #
  #
  def by_old_pid
    @features = params[:old_pids].split(/\D+/).find_all{|p| p && !p.blank?}.collect{|p| Feature.find_by_old_pid("f#{p}")}.find_all{|f| f}
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    respond_to do |format|
      format.html { render :action => 'staff_show' }
      format.xml  { render :action => 'index' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'index.xml.builder')), :callback => params[:callback] }
    end
  end
  
  def by_name
    params[:filter] = params[:query]
    conditions = {:is_public => 1}
    search_options = {
      :scope => params[:scope] || 'name',
      :match => params[:match]
    }
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code('roman.popular')
    joins = []
    if !params[:feature_type].blank?
      joins << "LEFT JOIN cumulative_category_feature_associations ccfa ON ccfa.feature_id = features.id"
      conditions['ccfa.category_id'] = params[:feature_type].split(',')
      conditions['features.is_public'] = 1
      conditions.delete(:is_public)
    end
    if !params[:characteristic_id].blank?
      joins << "LEFT JOIN category_features cf ON cf.feature_id = features.id"
      conditions['cf.category_id'] = params[:characteristic_id].split(',')
      conditions['cf.type'] = nil
      conditions['features.is_public'] = 1
      conditions.delete(:is_public)
    end
    @features = perform_global_search(search_options).where(conditions).paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 15)
    @features = @features.joins(joins.join(' ')).select('features.*, DISTINCT feature.id') unless joins.empty?
    respond_to do |format|
      format.html { render :action => 'paginated_show' }
      format.xml  { render :action => 'paginated_show' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'paginated_show.xml.builder')), :callback => params[:callback] }
    end
  end

  def fids_by_name
    params[:filter] = params[:query]
    conditions = { :is_public => 1 }
    search_options = {
      :scope => params[:scope] || 'name',
      :match => params[:match]
    }
    joins = []
    if !params[:feature_type].blank?
      joins << 'LEFT JOIN cumulative_category_feature_associations ccfa ON ccfa.feature_id = features.id'
      conditions['ccfa.category_id'] = params[:feature_type].split(',')
      conditions['features.is_public'] = 1
      conditions.delete(:is_public)
    end
    if !params[:characteristic_id].blank?
      joins << 'LEFT JOIN category_features cf ON cf.feature_id = features.id'
      conditions['cf.category_id'] = params[:characteristic_id].split(',')
      conditions['cf.type'] = nil
      conditions['features.is_public'] = 1
      conditions.delete(:is_public)
    end
    @features = perform_global_search(search_options).where(conditions).includes(:include => :shapes)
    @features = @features.joins(joins.join(' ')).select('features.*, DISTINCT feature.id') unless joins.empty?
    respond_to do |format|
      format.json { render :json => { :features => @features.reject{|f| f.shapes.empty?}[0...100].collect(&:fid) }, :callback => params[:callback] }
    end
  end
  
  def characteristics_list
    render :json => CategoryFeature.get_json_data
  end
  
  def search
    conditions = {:is_public => 1}
    search_options = { :scope => params[:scope], :match => params[:match] }
    @features = nil
    @params = params
    # The search params that should be observed when creating the session store of search params
    valid_search_keys = [:filter, :scope, :match, :search_scope, :has_descriptions, :page ]
    fid = params[:fid]
    #search_scope = params[:search_scope].blank? ? 'global' : params[:search_scope]
    #if !search_scope.blank?
    #  case search_scope
    #  when 'fid'
    #    feature = Feature.find(:first, :conditions => {:is_public => 1, :fid => params[:filter].gsub(/[^\d]/, '').to_i})
    #    if !feature.id.nil?
    #      render :url => {:action => 'expand_and_show',  :id => '59' }, :layout => false
    #    else
    #    end
    #  when 'contextual'
    #    if params[:context_id].blank?
    #      perform_global_search(options, search_options)
    #    else
    #      perform_contextual_search(options, search_options)
    #    end
    #  when 'name'
    #    @features = Feature.name_search(params[:filter])
    #  else
      if !fid.blank?
        @features = Feature.where(:is_public => 1, :fid => fid.gsub(/[^\d]/, '').to_i).page(1)
      else
        joins = []
        if !params[:has_descriptions].blank? && params[:has_descriptions] == '1'
          search_options[:has_descriptions] = true
        end
        @features = perform_global_search(search_options).where(conditions).paginate(:page => params[:page] || 1, :per_page => 10)
        @features = @features.joins(joins.join(' ')).select('features.*, DISTINCT feature.id') unless joins.empty?
      end
    #end
    # When using the session store features, we need to provide will_paginate with info about how to render
    # the pagination, so we'll store it in session[:search], along with the feature ids 
    session[:search] = { :params => @params.reject{|key, val| !valid_search_keys.include?(key.to_sym)},
      :page => @params[:page] ||= 1, :per_page => @features.per_page, :total_entries => @features.total_entries,
      :total_pages => @features.total_pages, :feature_ids => @features.collect(&:id) }
    # Set the current menu_item to 'results', so that the Results will stay open when the user browses
    # to a new page
    session[:interface] = {} if session[:interface].nil?
    session[:interface][:menu_item] = 'results'
    respond_to do |format|
      format.js # search.js.erb
      format.html { render :partial => 'search_results', :locals => {:features => @features} }
    end
  end
  
  def children
    feature = Feature.get_by_fid(params[:id])
    @features = feature.children
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code('roman.popular')
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'children.xml.builder')) }
    end
  end
  
  def list
    params_id = params[:id]
    if params_id.nil?
      @features = Feature.all
    else
      feature = Feature.get_by_fid(params_id)
      @features = feature.descendants
    end
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code('roman.popular')
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'list.xml.builder')) }
    end
  end
  
  def all
    params_id = params[:id]
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code('roman.popular')
    if params_id.nil?
      @features = Feature.current_roots(Perspective.get_by_code(default_perspective_code), @view)
    else
      @feature = Feature.get_by_fid(params_id)
    end
    respond_to do |format|
      format.xml { render 'all_collection' if params_id.nil? }
      format.json { render :json => Hash.from_xml(render_to_string(:action => params_id.nil? ? 'all_collection.xml.builder' : 'all.xml.builder')) }
    end
  end
  
  def descendants
    @feature = Feature.find(params[:id])
    descendants = @feature.nil? ? [] : @feature.descendants.includes(:cached_feature_names => :feature_name).where('cached_feature_names.view_id' => current_view.id).order('feature_names.name')
    descendants = descendants.paginate(:page => params[:page] || 1, :per_page => 10)
    render :partial => 'descendants', :locals => { :descendants => descendants }
  end
  
  def related
    @feature = Feature.get_by_fid(params[:id])
    if @feature.nil?
      redirect_to features_url
    else
      set_common_variables(session)
      session[:interface][:context_id] = @feature.id unless @feature.nil?
      @tab_options = {:entity => @feature}
      @current_tab_id = :related
    end
  end
    
  # The following three methods are used with the Node Tree
  def expanded
    @node = Feature.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @node }
      format.js   { @ancestors = (@node.current_ancestors(current_perspective).collect(&:id) + [@node.id.to_s]).join(',') } # response would be handled by expanded.js.erb
    end
  end

  def contracted
    @node = Feature.find(params[:id])
    redirect_to(feature_url(@node)) if !request.xhr?
    # response would be handled by contracted.js.erb
  end
  
  def node_tree_expanded
    set_common_variables(session) if params[:view_id] || params[:perspective_id]
    node = Feature.find(params[:id])
    # @ancestors_for_current = node.closest_ancestors_by_perspective(current_perspective).collect{|a| a.id}
    @ancestors_for_current = node.current_ancestors(current_perspective).collect(&:id)
    @ancestors_for_current << node.id
    top_level_nodes = Feature.current_roots(current_perspective, current_view)
    render :partial => 'node_tree', :locals => { :children => top_level_nodes }, :layout => false
  end
  
  def topics
    @feature = Feature.get_by_fid(params[:id])
    if @feature.nil?
      redirect_to features_url
    else
      set_common_variables(session)
      session[:interface][:context_id] = @feature.id unless @feature.nil?
      @tab_options = {:entity => @feature}
      @current_tab_id = :topics
    end
  end
    
  def set_session_variables
    defaults = {
      :menu_item => "search",
      :advanced_search => "0"
    }
    valid_keys = defaults.keys
    
    session[:interface] = {} if session[:interface].nil?
    params.each do |key, value|
      session[:interface][key.to_sym] = value if valid_keys.include?(key.to_sym)
    end
    render :text => ""
  end
  
  protected
  
  def search_scope_defined?
    !params[:search_scope].blank?
  end
  
  def contextual_search_selected?
    ('contextual' == params[:search_scope])
  end
  
  def global_search_selected?
    ('global' == params[:search_scope])
  end
  
  def fid_search_selected?
    ('fid' == params[:search_scope])
  end
  
  def perform_contextual_search(options, search_options={})
    @context_feature, @features = Feature.contextual_search(
      params[:context_id],
      params[:filter],
      options,
      search_options
      )
  end
  
  def perform_global_search(search_options={})
    Feature.search(params[:filter], search_options)
  end
  
  def api_render(features, options={})
    collection = {}
    collection[:features] = features.collect{|f| api_format_feature(f)}
    collection[:page] = params[:page] || 1
    collection[:total_pages] = features.total_pages
    respond_to do |format|
      format.xml { render :xml => collection.to_xml }
      format.json { render :json => collection.to_json, :callback => params[:callback] }
    end
  end
  
  def api_format_feature(feature)
    f = {}
    f[:id] = feature.id
    f[:name] = feature.name
    f[:descriptions] = feature.descriptions.collect{|d| {
      :id => d.id,
      :is_primary => d.is_primary,
      :title => d.title,
      :content => d.content,
    }}
    f[:has_shapes] = feature.shapes.empty? ? 0 : 1
    #f[:parents] = feature.parents.collect{|p| api_format_feature(p) }
    f
  end
  
  private
  
  def cache_path
    set_common_variables(session) if params[:view_id] || params[:perspective_id]
    "tree/#{current_perspective.id}/#{current_view.id}/node_id_#{params[:id]}"
  end
end