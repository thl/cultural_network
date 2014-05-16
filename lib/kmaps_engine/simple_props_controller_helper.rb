#
# This helper forces the admin/simple_props views to be used for any < SimpleProp class controller
#
module KmapsEngine
  module SimplePropsControllerHelper
    extend ActiveSupport::Concern
    
    included do
      helper 'Admin'
    end
    
    def initialize
      super
      @guest_perms = []
    end
    
    def render(*args)
      tpl = params[:action]
      format = params[:format]
      # tpl = args.first[:action]
      # If there is no current HTTP authentication, bypass this template rendering...
      tpl && (format.nil? || format == 'html') ? super("admin/simple_props/#{tpl}") : super(*args)
    end

    def collection
      @collection = model_name.classify.constantize.search(params[:filter]).page(params[:page]).order('UPPER(name)')
    end
  end
end