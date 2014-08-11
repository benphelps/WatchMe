set :application, 'watchme'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, 'git@gitbin.com:phelps/watchme-io.git'

set :linked_dirs, %w{bin log tmp vendor/bundle public/system public/uploads}

set :default_env, {
  'AWS_ACCESS_KEY_ID' => 'AKIAISLFYNZLIOEZROFA',
  'AWS_SECRET_ACCESS_KEY' => '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',
  'FOG_DIRECTORY' => 'watchmeio',
  'FOG_PROVIDER' => 'AWS'
}

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 2 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
  after :finishing, "deploy:restart"
end