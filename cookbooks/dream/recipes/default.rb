# Install infinality-bundle
# TODO: extract in something more idiomatic for chef?
# BEGIN
bash "add_infinality_bundle_to_pacman" do
  user "root"
  code <<-EOF
    echo "\n[infinality-bundle]\nServer = http://ibn.net63.net/infinality-bundle/\\\$arch" >> /etc/pacman.conf
    sudo pacman-key -r 962DDE58
    sudo pacman-key --lsign-key 962DDE58
    sudo pacman -Syy
  EOF
  not_if "grep -q 'infinality-bundle' /etc/pacman.conf"
end

%w{cairo freetype2 fontconfig}.each do |name|
  package name do
    action :remove
    options "--nodeps --nodeps"
  end
  package "#{name}-infinality-ultimate" do
    action :install
  end
end
# END


# Packages to remove
%w{vim}.each do |name|
  package name do
    action :remove
    options "--nodeps --nodeps"
  end
end


# Packages to install
%w{
  xorg-server xorg-server-utils xorg-xinit xterm
  ttf-bitstream-vera ttf-freefont ttf-droid ttf-inconsolata ttf-ubuntu-font-family
  gnome-terminal i3-wm slim slim-themes autocutsel xorg-xsetroot dunst unzip
  chromium firefox gnome-themes-standard gvim zsh ack mongodb fontforge
  erlang erlang-doc rebar
}.each do |name|
  package name do
    action :install
  end
end

# Packages to install from AUR
include_recipe 'pacman'
%w{jq dmenu-xft-height}.each do |name|
  pacman_aur name do action [:build, :install] end
end

# Services to start
service "slim.service" do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end

service "mongodb" do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end


# Set timezone
bash "set timezone" do
  code "timedatectl set-timezone Europe/Rome"
end


# Set hosts
hostsfile_entry "10.0.2.2" do
  hostname  "host"
  aliases   ["starbuck","mac"]
  action    :create_if_missing
end

hostsfile_entry "176.9.111.82" do
  hostname  "cleancode.it"
  action    :create_if_missing
end


# Install dotfiles
include_recipe "dotfiles"

# TODO: maybe the next things should be put in the dotfiles cookbook?
# TODO: having an nvm cookbook would be nice...

# Install nvm, nodeJS and npm global packages
bash "install nvm, nodeJS and npm global packages" do
  node_js_version = "0.10.24"
  home_directory = "/home/#{node["dotfiles"]["user"]}"
  user node["dotfiles"]["user"]
  group node["dotfiles"]["group"]
  environment "HOME" => home_directory, "USER" => node["dotfiles"]["user"]
  code <<-EOF
    git clone https://github.com/creationix/nvm.git #{home_directory}/.nvm
    source #{home_directory}/.nvm/nvm.sh
    nvm install #{node_js_version}
    nvm alias default #{node_js_version}
    npm install --global bower grunt-cli yeoman mocha gh underscore-cli karma phantomjs
  EOF
  not_if "[ -d #{home_directory}/.nvm ] && source #{home_directory}/.nvm/nvm.sh && nvm ls | grep #{node_js_version} > /dev/null"
end

# Install rvm, ruby versions and gems
node.set["rvm"]["install_pkgs"] = []
node.set["rvm"]["user_installs"] = [
  { "user" => node["dotfiles"]["user"],
    "home" => "/home/#{node["dotfiles"]["user"]}",
    "default_ruby" => "ruby-2.1.0",
    "rubies" => ["ruby-2.1.0", "ruby-2.0.0", "ruby-1.9.3"],
    "rvmrc" => {
      "rvm_project_rvmrc" => 1,
      "rvm_gemset_create_on_use_flag" => 1,
      "rvm_pretty_print_flag" => 1
    },
    "global_gems" => [
      {"name" => "travis-lint"},
      {"name" => "bundler"},
      {"name" => "rake"},
      {"name" => "htty"}
    ]
  }
]
include_recipe "rvm::user"
