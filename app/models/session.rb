class Session
  include ActiveModel::Model
  attr_accessor :login, :password, :remember_me, :perspective_id, :view_id, :show_feature_details, :show_advanced_search
end
