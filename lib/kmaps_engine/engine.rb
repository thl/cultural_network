module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :loader do |config|
      require 'kmaps_engine/array_ext'
      require 'kmaps_engine/import/importation.rb'
      
      Array.send :include, KmapsEngine::ArrayExtension
      Sprockets::Context.send :include, Rails.application.routes.url_helpers
    end

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end

  end
end
