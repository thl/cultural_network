require 'kmaps_engine/family_tree_utils'
namespace :util do
  
  desc 'Synchronizes all of the ancestor data for features. rake util:reset_feature_ancestor_ids [FROM=fid] [TO=fid] [DAYLIGHT=daylight] [LOG_LEVEL=0..5]'
  task reset_feature_ancestor_ids: :environment do
    KmapsEngine::FamilyTreeUtils.new("log/reindexing_#{Rails.env}.log", ENV['LOG_LEVEL']).reset_feature_ancestor_ids(from: ENV['FROM'], to: ENV['TO'], daylight: ENV['DAYLIGHT'])
  end
end
