#
# This helper forces the admin/simple_props views to be used for any < SimpleProp class controller
#
module KmapsEngine
  module SimplePropsControllerHelper
    extend ActiveSupport::Concern
    
    included do
      helper 'Admin'
    end
    
    def render(*args)
      tpl = params[:action]
      # tpl = args.first[:action]
      # If there is no current HTTP authentication, bypass this template rendering...
      tpl ? super("admin/simple_props/#{tpl}") : super(*args)
    end

    def collection
      @collection = model_name.classify.constantize.search(params[:filter]).page(params[:page]).order('UPPER(name)')
    end
  end
end