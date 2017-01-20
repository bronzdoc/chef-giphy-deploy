directory "/home/doc/app_chef_test" do
  user "doc"
end

deploy "giphy app chef deploy" do
  repo "git@github.com:bronzdoc/giphy-app.git"
  user "doc"
  deploy_to "/home/doc/app_chef_test"
  migrate true
  migration_command "mkdir -p logs && npm install"
  action :deploy
end

giphy_entrypoint = "app.js"

execute "run giphy app" do
  command "cd /home/doc/app_chef_test/current/ && node #{giphy_entrypoint}"
end

