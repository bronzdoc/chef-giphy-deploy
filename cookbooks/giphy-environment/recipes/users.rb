#
# Cookbook:: giphy-deploy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

username = node[:giphy][:jenkins_user]

directory "/home/jenkins"

user username do
  comment "user used for jenkis depoys"
  shell "/bin/bash"
  home "/home/jenkins"
  action :create
end

directory "/home/jenkins/.ssh"

execute "generate jenkins ssh keys" do
  command "ssh-keygen -t rsa -q -f /home/#{username}/.ssh/id_rsa -P \"\""
end


