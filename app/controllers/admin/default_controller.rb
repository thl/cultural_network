class Admin::DefaultController < ApplicationController
  def initialize
    super
    @guest_perms = []
  end

  def index
    @intro_blurb = Blurb.find_by(code: (current_user.admin? ? 'homepage.admin' : 'homepage.edit'))
  end

  def help
  end
  
end