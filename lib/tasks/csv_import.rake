# require 'config/environment'
require 'cultural_network/import/essay_import'
require 'cultural_network/import/feature_name_match'
require 'cultural_network/import/feature_importation'
namespace :db do
  namespace :import do
    csv_desc = "Use to import CSV containing features into DB.\n" +
                  "Syntax: rake db:import:csv SOURCE=csv-file-name"
    desc csv_desc
    task :features do
      source = ENV['SOURCE']
      if source.blank?
        puts csv_desc
      else
        CulturalNetwork::FeatureImportation.new.do_feature_import(source)
      end
    end
    
    desc 'Import essays from URLs'
    task :essays do
      source = ENV['SOURCE']
      options = {}
      options[:dry_run] = ENV['DRY_RUN'] || false
      options[:prefix] = ENV['PREFIX'] || ""
      options[:reader_url] = ENV['READER_URL'] || "#{InterfaceUtils::Server.get_url}/global/php/book_reader.php?url="
      options[:public_url] = ENV['PUBLIC_URL'] || "" # Example: /places/monasteries/publications/chosphel-book.php#book=
      options[:full_url] = ENV['FULL_URL'] || nil
      options[:limit] = ENV['LIMIT'] || nil
      options[:view_code] = ENV['VIEW'] || nil
      if source.blank?
        puts "Please specify a source.\n" +
             "Syntax: rake db:import:essays SOURCE=csv-file-name PREFIX=/bellezza/wb/"
      else
        CulturalNetwork::EssayImport.new.import_with_book_reader(source, options)
      end
    end
  end
  
  namespace :feature_name_match do
    csv_desc = "Find feature matches based on names in a CSV and associate them with an ID in the CSV.\n" +
      "The CSV should have columns like \"external_id, name1, name2, name3\", where external_id can be anything," +
      " and there can be any number of name[N]'s.\n"+
      "The output is a CSV file with columns like \"external_id, FID\".\n"+
      "Syntax: rake db:feature_name_match:match SOURCE=csv-file-name OUTPUT=output-csv-file-name"
    desc csv_desc
    task :match do
      source = ENV['SOURCE']
      options = {}
      options[:output] = ENV['OUTPUT']
      options[:limit] = ENV['LIMIT']
      if source.blank?
        puts "Please specify a source.\n"+
          "Syntax: rake db:feature_name_match:match SOURCE=csv-file-name"
      else
        CulturalNetwork::FeatureNameMatch.match(source, options)
      end
    end
  end  
end