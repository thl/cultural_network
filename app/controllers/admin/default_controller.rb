class Admin::DefaultController < ApplicationController
  def initialize
    super
    @guest_perms = []
  end

  def index
  end

  def help
  end
  
end