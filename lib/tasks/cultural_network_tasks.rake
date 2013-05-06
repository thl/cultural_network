namespace :cultural_network do
  namespace :db do
    namespace :schema do
      desc "Load schema for cultural network tables"
      task :load do
        ENV['SCHEMA'] = File.join(CulturalNetwork::Engine.paths['db'].existent.first, 'schema.rb')
        Rake::Task['db:schema:load'].invoke
      end
    end
    desc "Load seeds for cultural network tables"
    task :seed do
      CulturalNetwork::Engine.load_seed
    end
  end
end