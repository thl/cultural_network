require 'cultural_network/engine'
require 'active_record/acts/cultural_network/extension'
require 'active_record/cultural_network/extension'
require 'cultural_network/feature_extension_for_name_positioning'
require 'cultural_network/simple_prop_cache'
require 'cultural_network/array_ext'
require 'cultural_network/contextual_tree_builder'
require 'cultural_network/feature_pid_generator'
require 'cultural_network/has_timespan'
require 'cultural_network/is_citable'
require 'cultural_network/is_notable'
require 'cultural_network/session_manager'
require 'cultural_network/simple_props_controller_helper'

ActiveRecord::Base.send :include, ActiveRecord::Acts::CulturalNetwork::Extension
ActiveRecord::Base.send :include, ActiveRecord::CulturalNetwork::Extension
Array.send :include, CulturalNetwork::ArrayExtension

I18n.load_path += Dir[File.join(File.dirname(__FILE__), '..', 'config', 'locales', '**', '*.yml')]

module CulturalNetwork
end