#
# Cookbook:: giphy-deploy
# Recipe:: nodejs
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package "nodejs"

directory "/home/jenkins/.node" do
  action :create
  owner "jenkins"
end


