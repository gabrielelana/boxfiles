require_relative ".github.rb"

# TODO: setup current timezone
# TODO: dotfiles cookbook should export dotfiles as resource

# DEPENDENCIES:
# Vagrant (make sure you have installed Xcode command line utilities "Preferences > Dowloads")
#   with vagrant-berkshelf plugin (vagrant plugin install vagrant-berkshelf)
# VirtualBox

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# Name of the registered base box to use
  config.vm.box = "archlinux-20131018"

  # Url where to find the base box in case is not registered on this host
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/7048158/archlinux-20131018.box"
  
  # Enable Berkshelf plugin
  config.berkshelf.enabled = true

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network :public_network

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :virtualbox do |vb|
    # Machine name
		vb.name = "dream"
		
		# Boot with GUI or not
    vb.gui = false
		
    # Use VBoxManage to customize the VM
    vb.customize ["modifyvm", :id, "--memory", "2048"]
		vb.customize ["modifyvm", :id, "--cpus", "2"]
		vb.customize ["modifyvm", :id, "--accelerate3d", vb.gui ? "on" : "off"]
		vb.customize ["modifyvm", :id, "--clipboard", vb.gui ? "bidirectional" : "disabled"]
		vb.customize ["modifyvm", :id, "--vram", vb.gui ? "256" : "12"]
		vb.customize ["modifyvm", :id, "--acpi", "on"]
		vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Ensure chef-solo is installed in the current vm
  config.vm.provision :shell,
    :inline => "which chef-solo || gem install chef --no-user-install --no-rdoc --no-ri"

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "dotfiles" => {
        "user" => "vagrant",
        "group" => "users"
      },
      "github" => {
        "username" => GITHUB_USERNAME,
        "password" => GITHUB_PASSWORD
      }
    }
        
    chef.add_recipe "dream"
  end
end


# sudo echo "
## [infinality-bundle-multilib]
## Server = http://ibn.net63.net/infinality-bundle-multilib/$arch
## " >> /etc/pacman.conf
# sudo pacman-key -r 962DDE58
# sudo pacman-key --lsign-key 962DDE58
# sudo pacman -Syyu --noconfirm
# sudo pacman -S --noconfirm cairo-infinality-ultimate fontconfig-infinality-ultimate freetype2-infinality-ultimate xorg-server xorg-server-utils xorg-xinit
# sudo pacman -S --noconfirm gnome-terminal
# sudo pacman -S --noconfirm xterm # don't know if this is mandatory, guess it's because of the default window manager that pretend to start xterm
# sudo pacman -S --noconfirm ttf-bitstream-vera ttf-freefont ttf-droid ttf-inconsolata ttf-ubuntu-font-family
# sudo pacman -S --noconfirm i3-wm
# sudo pacman -S --noconfirm slim slim-themes
# sudo systemctl enable slim.service

## this is no good but it will do the trick
## xrandr --output VBOX0 --mode 1680x1050
