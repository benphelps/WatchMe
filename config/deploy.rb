set :application, 'watchme'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, 'git@gitbin.com:phelps/watchme-io.git'

set :linked_dirs, %w{bin log tmp vendor/bundle public/system public/uploads}

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 2 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
  after :finishing, "deploy:restart"
end