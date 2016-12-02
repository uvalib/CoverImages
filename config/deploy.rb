# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'coverImages'
set :repo_url, 'https://github.com/uvalib/CoverImages.git'
set :ssh_options, forward_agent: true
set :ssh_options, keys: [ENV['SSH_DEPLOY_KEY_PATH']] if ENV['SSH_DEPLOY_KEY_PATH']

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/usr/local/projects/coverImages'

set :image_folder_symlink, '/lib_content/cover_images'

set :use_sudo, false

set :rails_env, :production
# set :conditionally_migrate, true
set :keep_assets, 5

# Default value for :scm is :git
# set :scm, :git

set :branch, ENV['BRANCH'] if ENV['BRANCH']

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true,
#   log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files,
  'config/database.yml', 'config/secrets.yml', '.env.production',
  'config/puma.rb', 'config/authorized_users.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# rvm setup
set :rvm_type, :system
set :rvm_ruby_version, '2.3.1@coverImages'

#
# before 'deploy', 'rvm1:install:rvm'
# before 'deploy', 'rvm1:install:ruby'

# sidekiq setup
# set :sidekiq_config, 'config/sidekiq.yml'

before 'deploy:symlink:shared', 'deploy:symlink_images'
