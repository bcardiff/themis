require 'shellwords'
namespace :db do
  desc 'Restore mysql backup'
  task restore: :environment do |_t, _args|
    @db = Rails.configuration.database_configuration[Rails.env]
    @db_params = "-u #{@db['username']} #{@db['database']}"
    @db_params = "-p#{@db['password']} #{@db_params}" unless @db['password'].blank?

    file = ENV.fetch('FILE', nil)
    command = "mysql #{@db_params} < #{Shellwords.escape(file)}"

    Rake::Task['db:drop'].execute
    Rake::Task['db:create'].execute
    system(command)
  end

  desc 'backup mysql backup'
  task backup: :environment do |_t, _args|
    @db = Rails.configuration.database_configuration[Rails.env]
    @db_params = "-u #{@db['username']} #{@db['database']}"
    @db_params = "-p#{@db['password']} #{@db_params}" unless @db['password'].blank?

    file = ENV.fetch('FILE', nil)
    command = "mysqldump #{@db_params} | gzip > #{Shellwords.escape(file)}"
    system(command)
  end
end
