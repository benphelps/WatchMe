set :application, 'watchme'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, 'git@gitbin.com:phelps/watchme-io.git'

set :linked_dirs, %w{bin log tmp vendor/bundle public/system certs}

namespace :deploy do
  task :restart, roles: :app, except: { no_release: true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
