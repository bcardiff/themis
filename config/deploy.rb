# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'themis'
set :repo_url, 'git@github.com:bcardiff/themis.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/home/swingcit/themis'
# set :tmp_dir, '/home/swingcit/tmp'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/settings.yml', 'config/newrelic.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
set :default_env, {
  path: "$HOME/ruby/gems/bin:/usr/local/ruby20/bin:$PATH",
  gem_path: "$HOME/ruby/gems:/usr/local/ruby20/lib64/ruby/gems/:$GEM_PATH",
  bundle_path: "$HOME/ruby/gems",
  bundle_disable_shared_gems: "1",
  rails_env: "production"
}

# Default value for keep_releases is 5
# set :keep_releases, 5

set :user, "swingcit"
set :use_sudo, false
set :deploy_via, :copy

namespace :deploy do

  after :finishing, :create_htaccess do
    on roles(:web) do
      htaccess = "#{current_path}/public/.htaccess"
      execute "echo 'RewriteEngine On' > #{htaccess};echo 'PassengerEnabled On' >> #{htaccess}; echo 'PassengerLoadShellEnvVars On' >> #{htaccess}; echo 'PassengerAppRoot #{current_path}' >> #{htaccess}; echo 'PassengerRuby /usr/local/ruby20/bin/ruby' >> #{htaccess}; echo 'RackEnv production' >> #{htaccess}; echo '.htaccess created'"

      execute "touch #{current_path}/tmp/restart.txt"
    end
  end


  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

