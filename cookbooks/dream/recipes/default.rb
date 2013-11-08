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
  gnome-terminal i3-wm slim slim-themes autocutsel xorg-xsetroot
  gvim zsh ack 
}.each do |name|
  package name do
    action :install
  end
end

# Services to start
service "slim.service" do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end

# Install dotfiles
include_recipe "dotfiles"

# Install nvm, nodeJS and npm global packages
bash "install nvm, nodeJS and npm global packages" do
  node_js_version = "0.10.21"
  home_directory = "/home/#{node["dotfiles"]["user"]}"
  user node["dotfiles"]["user"]
  group node["dotfiles"]["group"]
  environment "HOME" => home_directory, "USER" => node["dotfiles"]["user"]
  code <<-EOF
    git clone https://github.com/creationix/nvm.git #{home_directory}/.nvm
    source #{home_directory}/.nvm/nvm.sh
    nvm install #{node_js_version}
    nvm alias default #{node_js_version}
    # TODO: install needed global packages
  EOF
  not_if "[ -d #{home_directory}/.nvm ] && source #{home_directory}/.nvm/nvm.sh && nvm ls | grep #{node_js_version} > /dev/null"
end

# TODO: Install rvm, ruby versions and gems
