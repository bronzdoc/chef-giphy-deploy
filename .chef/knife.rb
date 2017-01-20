# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "bronzdoc"
client_key               "#{current_dir}/bronzdoc.pem"
chef_server_url          "https://api.chef.io/organizations/autow"
cookbook_path            ["#{current_dir}/../cookbooks/giphy-deploy/berks-cookbooks"]
