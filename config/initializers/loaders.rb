ActiveSupport.on_load(:active_record) do
  require 'active_record/kmaps_engine/extension'
  include ActiveRecord::KmapsEngine::Extension
end
ActiveSupport.on_load(:authenticated_system_user) do
  require 'kmaps_engine/extensions/user_model.rb'
  include KmapsEngine::Extension::UserModel
end