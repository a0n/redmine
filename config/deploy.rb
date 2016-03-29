# config valid only for current version of Capistrano

require 'capistrano-db-tasks'
 # if you want to remove the local dump file after loading
set :db_local_clean, true

# if you want to remove the dump file from the server after downloading
set :db_remote_clean, true

# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, "public/uploads"
# set :local_assets_dir, "public"

# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
set :locals_rails_env, "production"

# if you are highly paranoid and want to prevent any push operation to the server
set :disallow_pushing, false



set :application, 'redmine'
set :repo_url, 'git@github.com:a0n/redmine.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :full_app_name, "#{fetch(:application)}-#{fetch(:stage)}"
set :deploy_to, "/srv/#{fetch(:full_app_name)}"

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('backup', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :pty, true
set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app

#config to prevent strange reloads
#set :puma_preload_app, false
#set :puma_prune_bundler, true



namespace :deploy do
  before :updated, "deploy:backup_database"
  before :updated, "deploy:import_production_database"
  task :backup_database do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          #execute :rake, 'backup:app'
        end
      end 
    end
  end
  task :import_production_database do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          #execute :rake, 'db:import_production_db_and_assets'
        end
      end 
    end
  end
end



# namespace :bower do
#   desc 'Install bower'
#   task :install do
#     on roles(:web) do
#       within release_path do
#         execute :rake, 'bower:install CI=true'
#       end
#     end
#   end
# end
# before 'deploy:compile_assets', 'bower:install'

before 'deploy:check:linked_files', 'config:push'

after "deploy",        "puma:restart"

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
