set :branch, 'master'
set :deploy_to, '/home/deploy/watchme'
set :keep_releases, 5

server 'wm-web1', user: 'deploy', roles: %w{web app db}
