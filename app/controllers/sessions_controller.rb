# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # GET /session/edit
  def edit
    @session = Session.new(
      :perspective_id => self.current_perspective.id,
      :view_id => self.current_view.id,
      :show_feature_details => self.current_show_feature_details,
      :show_advanced_search => self.current_show_advanced_search)
    @perspectives = Perspective.find_all_public
    @views = View.order('name')
  end
    
  # PUT /session
  def update
    session = Session.new(params[:session])
    self.current_perspective_id = session.perspective_id
    self.current_view_id = session.view_id
    self.current_show_advanced_search = session.show_advanced_search
    self.current_show_feature_details = session.show_feature_details
    redirect_to request.env["HTTP_REFERER"].blank? ? root_path : :back
  end
  
  def change_language
    case params[:id]
    when 'bo'
      session[:language] = 'bo'
      self.current_view_id = View.get_by_code('pri.tib.sec.chi').id
    when 'dz'
      session[:language] = 'dz'
      self.current_view_id = View.get_by_code('pri.tib.sec.roman').id
    when 'zh'
      session[:language] = 'zh'
      self.current_view_id = View.get_by_code('simp.chi').id
    when 'en'
      session[:language] = 'en'
      self.current_view_id = View.get_by_code('roman.popular').id
    end
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end
  end
end