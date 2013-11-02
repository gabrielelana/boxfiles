home_directory = "/home/#{node['dotfiles']['user']}"

# create .netrc file so that can checkout private repositories
file "#{home_directory}/.netrc" do
  owner node['dotfiles']['user']
  group node['dotfiles']['group']
  mode "0600"
  content <<-EOF.gsub(/^\s+/, "")
  machine github.com login #{node["github"]["username"]} password #{node["github"]["password"]}
  EOF
  action :create
end

# checkout and setup dotfiles
bash "checkout and setup dotfiles" do
  user node['dotfiles']['user']
  group node['dotfiles']['group']
  code <<-EOF
  git clone https://gabrielelana:#{node["github"]["password"]}@github.com/gabrielelana/dotfiles.git #{home_directory}/.dotfiles
  cd #{home_directory}/.dotfiles && zsh ./bootstrap-or-update.sh
  EOF
  not_if "test -d #{home_directory}/.dotfiles"
end

# TODO: run ~/.dotfiles/bootstrap-or-update.sh if remote dotfiles repository contains new commits