require 'shellwords'
namespace :db do
  desc "Restore mysql backup"
  task restore: :environment do |t, args|
    @db = Rails.configuration.database_configuration[Rails.env]
    @db_params = "-u #{@db['username']} #{@db['database']}"
    @db_params = "-p#{@db['password']} #{@db_params}" unless @db['password'].blank?

    file = ENV["FILE"]
    command = "gunzip < #{Shellwords.escape(file)} | mysql #{@db_params}"

    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    system(command)
  end
end
