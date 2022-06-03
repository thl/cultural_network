# require 'config/environment'
namespace :kmaps_engine do
  namespace :mms do
    desc "Deploys sources to MMS documents (authenticating through MMS_USER argument) making the appropriate replacements."
    task :deploy_sources do |t|
      require_relative '../kmaps_engine/mms_deployer.rb'
      MmsIntegration::MediaManagementResource.user = ENV['MMS_USER']
      if !MmsIntegration::MediaManagementResource.user.blank?
        puts "Password for #{MmsIntegration::MediaManagementResource.user}:"
        MmsIntegration::MediaManagementResource.password = STDIN.gets.chomp
        KmapsEngine::MediaManagementDeployer.do_source_deployment
      else
        puts 'User and password needed! Use MMS_USER= to set user from command-line.'
      end
    end
    
    desc "Convert mms illustrations to mandala images."
    task convert_mms_illustrations_to_mandala: :environment do |t|
      require_relative '../kmaps_engine/illustration_processing.rb'
      KmapsEngine::IllustrationProcessing.do_convert_mms_to_mandala
    end
    
    desc "Convert external illustrations to mandala images."
    task convert_external_illustrations_to_mandala: :environment do |t|
      require_relative '../kmaps_engine/illustration_processing.rb'
      KmapsEngine::IllustrationProcessing.do_convert_external_to_mandala
    end
  end
end