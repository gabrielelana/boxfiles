home_directory = "/home/#{node["dotfiles"]["user"]}"

# Install gem needed to hash user passwords aka create an user with a password :-)
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

group "sudo" do
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
    if [ ! -d #{home_directory}/.dotfiles ]; then
      git clone git@github.com:gabrielelana/dotfiles.git #{home_directory}/.dotfiles
    fi
    cd #{home_directory}/.dotfiles && ./install-or-update.sh
  EOF
end

# For some reason xmodmap behaves differently in ubuntu
# .dotfiles are not sensible to linux distribution so
# here I override 
file "#{home_directory}/.xmodmap" do
  owner node["dotfiles"]["user"]
  group node["dotfiles"]["group"]
  mode 00600
  content <<-EOF
    keycode 37  = Control_L
    keycode 133 = Control_L
    keycode 134 = Control_R

    keycode 87 = Hyper_L
    keycode 88 = Hyper_R

    keycode 89 = Super_L
    keycode 83 = Super_R

    keycode 84 = nobreakspace
    keycode 85 = nobreakspace

    ! keycode 108 = Alt_R
    keycode 104 = Insert

    clear Control
    clear Mod1
    clear Mod2
    clear Mod3
    clear Mod4
    clear Mod5

    add Control = Control_L Control_R
    add Mod1 = Alt_L Alt_R
    add Mod2 = Hyper_L Hyper_R
    add Mod3 = Super_L Super_R
  EOF
end