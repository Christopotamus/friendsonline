

# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'FriendsOnline'
set :repo_url, 'https://github.com/Christopotamus/friendsonline.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/rails/friendsonline.club'

# Default value for :scm is :git
#set :scm, :git

set :format, :pretty
set :pty, true
#set :keep_releases, 5

set :stage, :production
set :branch, 'master'

#default_run_options[:pty] = true


# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc "Bundle"
  task :bundle do
    on roles(:web) do
      within release_path do
        execute :bundle, "install"
      end 
    end 
  end
  desc "Migrate Database"
  task :migrate do
    on roles(:web) do
      within release_path do
        execute :rake, 'db:migrate'
      end
    end
  end
  desc "Restarting Unicorn"
  task :restart do 
    on roles(:app) do

      execute 'sudo /etc/init.d/unicorn4 restart'
    end
  end
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'assets:precompile'
      end
    end
  end

end


