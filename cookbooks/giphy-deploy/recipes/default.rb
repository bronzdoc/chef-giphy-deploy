#
# Cookbook:: giphy-deploy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "nodejs::npm"

npm_install_path    = node[:giphy][:npm_install_path]
npm_prefix_path     = node[:giphy][:npm_prefix_path]
entrypoint          = node[:giphy][:entrypoint]
deployment_path     = node[:giphy][:deployment_path]
current_deploy_path = node[:giphy][:current_deploy_path]
deployer            = node[:giphy][:deploy_user]

deploy "giphy app chef deploy" do
  repo "git@github.com:bronzdoc/giphy-app.git"
  user deployer
  deploy_to deployment_path
  migrate true
  migration_command "mkdir -p logs"
  action :deploy
end

directory "#{npm_prefix_path}" do
  user deployer
  group deployer
end

execute "npm config set prefix #{npm_prefix_path}"

nodejs_npm "npm install" do
  path current_deploy_path
  json true
  action :install
end

execute "stop giphy app" do
  command "#{npm_prefix_path}/bin/pm2 stop all"
  ignore_failure true
end

execute "run giphy app" do
  command "cd #{current_deploy_path} && #{npm_prefix_path}/bin/pm2 start #{entrypoint}"
end
