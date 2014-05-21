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
    end
    
    initializer :loader do |config|
      require 'kmaps_engine/tree_cache'
    end
  end
end