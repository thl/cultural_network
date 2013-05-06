module CulturalNetwork
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['cultural_network/admin.js', 'cultural_network/public.js',
        'cultural_network/top.js', 'cultural_network/iframe.js', 'cultural_network/jquery.ajax.sortable.js',
        'cultural_network/admin.css', 'cultural_network/public.css', 'cultural_network/xml-books.css'])
    end
    
    initializer :sweepers do |config|
      sweeper_folder = File.join(File.dirname(__FILE__), '..', '..', 'app', 'sweepers')
      require File.join(sweeper_folder, 'cached_category_count_sweeper')
      require File.join(sweeper_folder, 'feature_sweeper')
      require File.join(sweeper_folder, 'description_sweeper')
      Rails.application.config.active_record.observers = :cached_category_count_sweeper
    end
    
    initializer :loader do |config|
      require 'cultural_network/tree_cache'
    end
  end
end