class FeaturesController < ApplicationController
  caches_page :show, :if => Proc.new { |c| c.request.format.xml? || c.request.format.json? || c.request.format.csv? }
  #caches_page :related
  caches_action :all,                :cache_path => Proc.new { |c| cache_key_by_params(c, :view_code => true) }
  caches_action :children,           :cache_path => Proc.new { |c| cache_key_by_params(c, :perspective_code => true, :view_code => true) }
  caches_action :list,               :cache_path => Proc.new { |c| cache_key_by_params(c, :view_code => true) }
  caches_action :nested,             :cache_path => Proc.new { |c| cache_key_by_params(c, :perspective_code => true, :view_code => true) }
  caches_action :fancy_nested,       :cache_path => Proc.new { |c| cache_key_by_params(c, :perspective_code => true, :view_code => true) }
  #
  #
  def index
    @feature = Feature.find(session[:interface][:context_id]) unless session[:interface].blank? || session[:interface][:context_id].blank?
    @tab_options = {:entity => @feature}
    @current_tab_id = :home
    
    # In the event that a Blurb with this code doesn't exist, fail gracefully
    @intro_blurb = KmapsEngine::ApplicationSettings.homepage_blurb || Blurb.new
        
    respond_to do |format|
      format.html
      format.js
      format.xml  #{ render :xml => Feature.current_roots(Perspective.get_by_code(default_perspective_code), View.get_by_code(default_view_code)).to_xml }
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
          session[:interface][:context_id] = @feature.id unless @feature.nil?
          @tab_options = {:entity => @feature}
          @current_tab_id = :place
        end
      end
      format.xml
      format.csv do
        @features_with_parents = @feature.descendants_with_parent
      end
      format.js
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
    geo_code_type_str = params[:geo_code_type]
    geo_code_type = GeoCodeType.get_by_code(geo_code_type_str)
    @feature = nil
    if !geo_code_type.nil?
      geo_code = FeatureGeoCode.find_by(geo_code_type_id: geo_code_type.id, geo_code_value: params[:geo_code])
      @feature = geo_code.feature if !geo_code.nil?
    end
    respond_to do |format|
      format.html { render :action => 'show' }
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
    @features = params[:old_pids].split(/\D+/).find_all{|p| p && !p.blank?}.collect{|p| Feature.find_by(old_pid: "f#{p}")}.find_all{|f| f}
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    respond_to do |format|
      format.html { render :action => 'staff_show' }
      format.xml  { render :action => 'index' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'index.xml.builder')), :callback => params[:callback] }
    end
  end
  
  def by_name
    search = Search.new(filter: params[:query], scope: params[:scope] || 'name', match: params[:match])
    conditions = {:is_public => 1}
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
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
    @features = perform_global_search(search).where(conditions).paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 15)
    @features = @features.joins(joins.join(' ')).select('features.*, DISTINCT feature.id') unless joins.empty?
    respond_to do |format|
      format.html { render :action => 'paginated_show' }
      format.xml  { render :action => 'paginated_show' }
      format.json do
        render :json => Hash.from_xml(render_to_string(:action => 'paginated_show.xml.builder')), :callback => params[:callback]
      end
    end
  end

  # params accepted: name, summary, caption, descriptions, view_code, callback
  def by_fields
    match = params[:query]
    if match.blank?
      @features = Feature.where('FALSE').paginate(:page => 1, :per_page => 1)
    else
      accepted_fields = {:name =>        {:model => :names       , :field => 'feature_names.name'},
                         :summary =>     {:model => :summaries   , :field => 'summaries.content'},
                         :caption =>     {:model => :captions    , :field => 'captions.content'},
                         :description => {:model => :descriptions, :field => 'descriptions.content'}}
      params[:name] ||= '1'
      params[:id] ||= '0'
      accepted_fields.each_key{|param| params[param] ||= '0' }
      conditions_array = []
      params_array = []
      joins = []
      if params[:id] == '1' && match.to_i.to_s == match
        conditions_array << ['features.fid = ?']
        params_array << [match.to_i]
      end
      @features = Feature.where(:is_public => 1).paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 15)
      accepted_fields.each_pair do |param, param_hash|
        if params[param]=='1'
          joins << param_hash[:model]
          conditions_array << "#{param_hash[:field]} ILIKE ?"
        end
      end
      if !conditions_array.empty?
        @features = @features.select('features.*, DISTINCT feature.id').includes(joins).references(joins) if !joins.empty?
        @features = @features.where([conditions_array.join(' OR ')] + params_array + Array.new(joins.size, "%#{match}%"))
      end
    end
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    
    respond_to do |format|
      format.html { render :action => 'paginated_show' }
      format.xml  { render :action => 'paginated_show' }
      format.json do
        h = Hash.from_xml(render_to_string(:action => 'paginated_show.xml.builder'))
        h[:page] = params[:page] || 1
        h[:total_pages] = @features.total_pages
        render :json => h, :callback => params[:callback]
      end
    end
  end
    
  def children
    feature = Feature.get_by_fid(params[:id])
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    perspective = params[:perspective_code].nil? ? nil : Perspective.get_by_code(params[:perspective_code])
    if perspective.nil?
      @features = feature.children.sort_by{|f| [f.position, f.prioritized_name(@view).name] }
    else
      @features = feature.current_children(perspective, @view).sort_by{|f| [f.position, f.prioritized_name(@view).name]}
    end
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'children.xml.builder')) }
    end
  end
  
  def list
    params_id = params[:id]
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    if params_id.nil?
      @features = Feature.where(:is_public => 1).sort_by do |f|
        n = f.prioritized_name(@view)
        [f.position, n.nil? ? f.pid : n.name]
      end
    else
      feature = Feature.get_by_fid(params_id)
      @features = feature.descendants.sort_by do |f|
        n = f.prioritized_name(@view)
        [f.position, n.nil? ? f.pid : n.name]
      end
    end
    respond_to do |format|
      format.xml
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'list.xml.builder')) }
    end
  end
  
  def all
    params_id = params[:id]
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
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
  
  def nested
    params_id = params[:id]
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    @perspective = params[:perspective_code].nil? ? nil : Perspective.get_by_code(params[:perspective_code])
    @perspective ||= Perspective.get_by_code(default_perspective_code)
    if params_id.nil?
      @features = Feature.current_roots(@perspective, @view).sort_by{ |f| [f.position, f.prioritized_name(@view).name] }
    else
      @feature = Feature.get_by_fid(params_id)
    end
    respond_to do |format|
      format.xml { render 'nested_collection' if params_id.nil? }
      format.json { render :json => Hash.from_xml(render_to_string(:action => params_id.nil? ? 'nested_collection.xml.builder' : 'nested.xml.builder')) }
    end
  end
  
  def fancy_nested
    params_id = params[:id]
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    @perspective = params[:perspective_code].nil? ? nil : Perspective.get_by_code(params[:perspective_code])
    @perspective ||= Perspective.get_by_code(default_perspective_code)
    if params_id.nil?
      @features = Feature.current_roots(@perspective, @view).sort_by{ |f| [f.position, f.prioritized_name(@view).name] }
    else
      @feature = Feature.get_by_fid(params_id)
    end
    respond_to do |format|
      format.xml { render 'fancy_nested_collection' if params_id.nil? }
      format.json do
        hash = Hash.from_xml(render_to_string(:action => params_id.nil? ? 'fancy_nested_collection.xml.builder' : 'fancy_nested.xml.builder'))
        render :json => hash['features']
      end
    end
  end

  def fancy_children
    @feature = Feature.get_by_fid(params[:id])
    @view = params[:view_code].nil? ? nil : View.get_by_code(params[:view_code])
    @view ||= View.get_by_code(default_view_code)
    respond_to do |format|
      format.json
    end
  end
  
  def descendants
    feature = Feature.get_by_fid(params[:id])
    @features_with_parents = feature.descendants_with_parent
    view_codes_str = params[:view_code]
    view_codes = view_codes_str.blank? ? [] : view_codes_str.split(',')
    if view_codes.empty?
      @view = current_view
    elsif view_codes.size == 1
      @view = View.get_by_code(view_codes.first)
    else
      @view = view_codes.collect{ |v| View.get_by_code(v) }
    end
    respond_to do |format|
      format.txt
    end
  end
  
  def related
    @feature = Feature.get_by_fid(params[:id])
    if @feature.nil?
      redirect_to features_url
    else
      session[:interface][:context_id] = @feature.id unless @feature.nil?
      @tab_options = {:entity => @feature}
      @current_tab_id = :related
    end
    respond_to do |format|
      format.html
      format.xml
      format.js
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'related.xml.builder')) }
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
    view = current_view
    node = Feature.find(params[:id])
    # @ancestors_for_current = node.closest_ancestors_by_perspective(current_perspective).collect{|a| a.id}
    @ancestors_for_current = node.current_ancestors(current_perspective).collect(&:id)
    @ancestors_for_current << node.id
    top_level_nodes = Feature.current_roots(current_perspective, view).sort_by{ |f| [f.position, f.prioritized_name(view).name] }
    render :partial => 'node_tree', :locals => { :children => top_level_nodes }, :layout => false
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
  
  def perform_global_search(search)
    Feature.search(search)
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
  
  private
  
  def cache_key_by_params(c, options)
    p = []
    if options[:perspective_code]
      perspective_code = params[:perspective_code]
      perspective_code = default_perspective_code if perspective_code.blank? || Perspective.get_by_code(perspective_code).nil?
      p << "perspective_code=#{perspective_code}"
    end
    if options[:view_code]
      view_code = params[:view_code]
      view_code = default_view_code if view_code.blank? || View.get_by_code(view_code).nil?
      p << "view_code=#{view_code}"
    end
    "#{c.request.path}?#{p.join('&')}"
  end
end
