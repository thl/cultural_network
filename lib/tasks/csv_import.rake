# require 'config/environment'
require 'kmaps_engine/import/essay_import'
require 'kmaps_engine/import/feature_name_match'

namespace :db do
  namespace :import do
    desc 'Import essays from URLs'
    task :essays do
      source = ENV['SOURCE']
      options = {}
      options[:dry_run] = ENV['DRY_RUN'] || false
      options[:prefix] = ENV['PREFIX'] || ""
      options[:reader_url] = ENV['READER_URL'] || "#{InterfaceUtils::Server.get_thl_url}/global/php/book_reader.php?url="
      options[:public_url] = ENV['PUBLIC_URL'] || "" # Example: /places/monasteries/publications/chosphel-book.php#book=
      options[:full_url] = ENV['FULL_URL'] || nil
      options[:limit] = ENV['LIMIT'] || nil
      options[:view_code] = ENV['VIEW'] || nil
      if source.blank?
        puts "Please specify a source.\n" +
             "Syntax: rake db:import:essays SOURCE=csv-file-name PREFIX=/bellezza/wb/"
      else
        KmapsEngine::EssayImport.new.import_with_book_reader(source, options)
      end
    end
  end
  
  namespace :feature_name_match do
    csv_desc = "Find feature matches based on names in a CSV and associate them with an ID in the CSV.\n" +
      "The CSV should have columns like \"external_id, name1, name2\", where external_id can be anything," +
      "The output is two CSV files with columns like \"external_id, FID\".\n"+
      "The out files are located in tmp matched_name_results.csv and unmatched_name_results.csv.\n"+
      "Syntax: rake db:feature_name_match:match SOURCE=csv-file-name"
    desc csv_desc
    task match: :environment do
      source = ENV['SOURCE']
      options = {}
      options[:limit] = ENV['LIMIT']
      if source.blank?
        puts "Please specify a source.\n"+
          "Syntax: rake db:feature_name_match:match SOURCE=csv-file-name"
      else
        KmapsEngine::FeatureNameMatch.match(source, options)
      end
    end
  end  
end
