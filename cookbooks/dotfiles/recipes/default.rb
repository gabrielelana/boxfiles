home_directory = "/home/#{node["dotfiles"]["user"]}"

# Install gem needed to hash user passwords aka create a user with a password :-)
chef_gem "ruby-shadow" do
  action :install
end

# Create the dotfile user
user node["dotfiles"]["user"] do
  supports :manage_home => true
  gid node["dotfiles"]["group"]
  home home_directory
  shell "/bin/zsh"
  password node["dotfiles"]["password"]
end

group "wheel" do
  action :modify
  members node["dotfiles"]["user"]
  append true
end

# Private configuration files
begin
  directory_resources_so_far = []
  node["dotfiles"]["private"].each do |file_path, file_content|
    file_path = File.join(home_directory, file_path)
    directory_path = File.dirname(file_path)

    unless directory_resources_so_far.include? directory_path
      directory_resources_so_far << directory_path
      directory directory_path do
        owner node["dotfiles"]["user"]
        group node["dotfiles"]["group"]
        mode 00700
        action :create
      end
    end

    file file_path do
      owner node["dotfiles"]["user"]
      group node["dotfiles"]["group"]
      mode 00600
      content file_content
      action :create
    end
  end
end

# Checkout and setup dotfiles
bash "checkout and setup dotfiles" do
  user node["dotfiles"]["user"]
  group node["dotfiles"]["group"]
  environment "HOME" => home_directory, "USER" => node["dotfiles"]["user"]
  code <<-EOF.gsub(/^\s+/, "")
    git clone git@github.com:gabrielelana/dotfiles.git #{home_directory}/.dotfiles
    cd #{home_directory}/.dotfiles && zsh ./bootstrap-or-update.sh
  EOF
  not_if "test -d #{home_directory}/.dotfiles"
end

# TODO: Run ~/.dotfiles/bootstrap-or-update.sh if remote dotfiles repository contains new commits