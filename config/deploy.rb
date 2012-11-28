require 'capistrano_colors'

set :repository,  "git@github.com:miller-center/imls-solr.git"
set :branch, fetch(:branch, "master")
set :deploy_to, "/opt/solr"
set :use_sudo, true
set :keep_releases, 3
set :scm, :git
set :user, :solr

default_run_options[:pty]   = true
default_run_options[:shell] = "/bin/bash -l"

ssh_options[:forward_agent] = true

#set :deploy_via, :remote_cache

set :domain, "128.143.8.227"

role :app, domain

after 'deploy:symlink', 'deploy:data_symlink'

namespace :deploy do
  desc "Restart IMLS Solr"
  task :restart do
    run "#{try_sudo} /etc/init.d/solr restart"
  end
  
  desc "Start IMLS Solr"
  task :start do
    run "#{try_sudo} /etc/init.d/solr start"
  end
  
  desc "Stop IMLS Solr"
  task :stop do
    run "#{try_sudo} /etc/init.d/solr stop"
  end

  desc "Override finalize_update as it's just tooo railsy..."
  task :finalize_update do ; end

  desc "Create a symlink for the shared data directory"
  task :data_symlink do
    run "ln -nfs #{shared_path}/system/data #{release_path}/solr/data"
  end
end
