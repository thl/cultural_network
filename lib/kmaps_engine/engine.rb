module KmapsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['kmaps_engine/admin.js', 'kmaps_engine/public.js',
        'kmaps_engine/top.js', 'kmaps_engine/iframe.js', 'kmaps_engine/jquery.ajax.sortable.js',
        'kmaps_engine/admin.css', 'kmaps_engine/public.css', 'kmaps_engine/xml-books.css'])
    end
    
    initializer :sweepers do |config|
      sweeper_folder = File.join(File.dirname(__FILE__), '..', '..', 'app', 'sweepers')
      require File.join(sweeper_folder, 'cached_category_count_sweeper')
      require File.join(sweeper_folder, 'feature_sweeper')
      require File.join(sweeper_folder, 'description_sweeper')
      Rails.application.config.active_record.observers = :cached_category_count_sweeper
    end
    
    initializer :loader do |config|
      require 'kmaps_engine/tree_cache'
    end
  end
end