module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['kmaps_engine/admin.js', 'kmaps_engine/treescroll.js',
        'kmaps_engine/top.js', 'kmaps_engine/iframe.js', 'kmaps_engine/jquery.ajax.sortable.js',
        'kmaps_engine/admin.css', 'kmaps_engine/public.css', 'kmaps_engine/xml-books.css',
        'kmaps_engine/scholar.css', 'kmaps_engine/popular.css'])
    end
    
    initializer :sweepers do |config|
      sweeper_folder = File.join('..', '..', 'app', 'sweepers')
      require_relative File.join(sweeper_folder, 'feature_sweeper')
      require_relative File.join(sweeper_folder, 'description_sweeper')
      require_relative File.join(sweeper_folder, 'caption_sweeper')
      require_relative File.join(sweeper_folder, 'summary_sweeper')
      require_relative File.join(sweeper_folder, 'feature_geo_code_sweeper')
    end
    
    initializer :loader do |config|
      require 'active_record/kmaps_engine/extension'
      require 'kmaps_engine/array_ext'
      require 'kmaps_engine/extensions/public_controller_dependencies'
      require 'kmaps_engine/import/importation.rb'
      require 'kmaps_engine/extensions/user_model.rb'
      require 'kmaps_engine/resource_object_authentication.rb'
      
      ActiveRecord::Base.send :include, ActiveRecord::KmapsEngine::Extension
      Array.send :include, KmapsEngine::ArrayExtension
      AuthenticatedSystem::SessionsController.send :include, KmapsEngine::Extensions::PublicControllerDependencies
      AuthenticatedSystem::User.send :include, KmapsEngine::Extension::UserModel
      
    end
  end
end