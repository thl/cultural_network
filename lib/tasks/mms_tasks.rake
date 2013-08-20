# require 'config/environment'
namespace :kmaps_engine do
  namespace :mms do
    desc "Deploys sources to MMS documents (authenticating through MMS_USER argument) making the appropriate replacements."
    task :deploy_sources do |t|
      require File.join(File.dirname(__FILE__), "../kmaps_engine/mms_deployer.rb")
      MmsIntegration::MediaManagementResource.user = ENV['MMS_USER']
      if !MmsIntegration::MediaManagementResource.user.blank?
        puts "Password for #{MmsIntegration::MediaManagementResource.user}:"
        MmsIntegration::MediaManagementResource.password = STDIN.gets.chomp
        KmapsEngine::MediaManagementDeployer.do_source_deployment
      else
        puts 'User and password needed! Use MMS_USER= to set user from command-line.'
      end
    end
    
    desc 'Imports thumbnails from MMS'
    task :illustrations => :environment do |t|
      require File.join(File.dirname(__FILE__), '../kmaps_engine/import/image_import.rb')
      ImageImport.do_image_import
    end
  end
end