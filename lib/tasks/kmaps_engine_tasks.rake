namespace :kmaps_engine do
  namespace :db do
    namespace :schema do
      desc "Load schema for kmaps engine tables"
      task :load do
        ENV['SCHEMA'] = File.join(KmapsEngine::Engine.paths['db'].existent.first, 'schema.rb')
        Rake::Task['db:schema:load'].invoke
      end
    end
    desc "Load seeds for kmaps engine tables"
    task seed: :environment do
      KmapsEngine::Engine.load_seed
    end
  end
end