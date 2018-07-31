# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "ura_reputation"
set :repo_url, "git@github.com:SugiKent/rep.git"

set :branch, 'master'
set :deploy_to, '/var/www/ura_reputation'

set :linked_files, %w[config/database.yml public/sitemap.xml public/robots.txt
                        public/apple-touch-icon-120x120-precomposed.png
                        public/apple-touch-icon-120x120.png
                        public/apple-touch-icon-152x152-precomposed.png
                        public/apple-touch-icon-152x152.png
                        public/apple-touch-icon152x152.png
                        public/favicon.ico
                        .env
                      ]
set :linked_files, fetch(:linked_files, []).push('config/settings.yml')
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets bundle public/system public/assets}
set :keep_releases, 5
set :rbenv_path, '/home/ec2-user/.rbenv'
set :rbenv_ruby, '2.5.1'

set :log_level, :debug

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  desc 'db_seed'
  task :db_seed do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed_fu'
        end
      end
    end
  end
end
