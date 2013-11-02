home_directory = "/home/#{node['dotfiles']['user']}"

# private configuration files
node["dotfiles"]["private"].each do |file_path, file_content|
  file "#{home_directory}/#{file_path}" do
    owner node["dotfiles"]["user"]
    group node["dotfiles"]["group"]
    mode "0600"
    content file_content
    action :create
  end
end

# checkout and setup dotfiles
bash "checkout and setup dotfiles" do
  user node['dotfiles']['user']
  group node['dotfiles']['group']
  environment "HOME" => home_directory, "USER" => node["dotfiles"]["user"]
  code <<-EOF.gsub(/^\s+/, "")
    git clone git@github.com:gabrielelana/dotfiles.git #{home_directory}/.dotfiles
    cd #{home_directory}/.dotfiles && zsh ./bootstrap-or-update.sh
  EOF
  not_if "test -d #{home_directory}/.dotfiles"
end

# TODO: run ~/.dotfiles/bootstrap-or-update.sh if remote dotfiles repository contains new commits