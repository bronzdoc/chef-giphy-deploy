#
# Cookbook:: giphy-deploy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

npm_install_path    = node[:giphy][:npm_install_path]
npm_prefix_path     = node[:giphy][:npm_prefix_path]
entrypoint          = node[:giphy][:entrypoint]
deployment_path     = node[:giphy][:deployment_path]
current_deploy_path = node[:giphy][:current_deploy_path]
deployer            = node[:giphy][:deploy_user]
deployer_home       = node[:giphy][:deploy_user_home]

apt_update "all platforms" do
  action :update
end

apt_package "lsb-release"

apt_package "openssh-client"

apt_package "openssh-server"

apt_package "git"

directory deployer_home

user deployer do
  shell "/bin/bash"
  home "/home/#{deployer}"
  action :create
end

directory "/home/jenkins/.ssh"

include_recipe "nodejs::npm"

deploy "giphy app chef deploy" do
  user deployer
  group deployer
  repo "git@github.com:bronzdoc/giphy-app.git"
  deploy_to deployment_path
  action :deploy
end

directory "#{current_deploy_path}/logs" do
  user deployer
  group deployer
end

directory "#{npm_prefix_path}" do
  user deployer
  group deployer
end

execute "npm config set prefix #{npm_prefix_path}" do
  user deployer
  group deployer
end

nodejs_npm "npm install" do
  user deployer
  group deployer
  path current_deploy_path
  json true
  action :install
end

nodejs_npm "pm2"

execute "stop giphy app" do
  user deployer
  group deployer
  command "#{npm_prefix_path}/bin/pm2 stop all"
  ignore_failure true
end

execute "run giphy app" do
  user deployer
  group deployer
  command "cd #{current_deploy_path} && #{npm_prefix_path}/bin/pm2 start #{entrypoint}"
end
