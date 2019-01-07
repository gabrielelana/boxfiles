# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "bento/ubuntu-18.04"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network "forwarded_port", guest: 8080, host: 8081
  # config.vm.network "forwarded_port", guest: 3000, host: 8083
  # config.vm.network "forwarded_port", guest: 4000, host: 8084
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "~/Desktop", "/mnt/host-desktop"
  config.vm.synced_folder ".", "/vagrant", owner: "vagrant"

  config.vm.hostname = "apollo"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.  
  
  # $ vagrant plugin install vagrant-vmware-desktop
  # $ vagrant plugin license vagrant-vmware-desktop license.lic
  # You need also to install the Vagrant VMware Utility (https://www.vagrantup.com/vmware/downloads.html)
  config.vm.provider :vmware_desktop do |v|
    # Machine name
    v.name = "dream-004"

    # Boot with GUI
    v.gui = true
    
    # VMWare Customization
    v.vmx["numvcpus"] = "4"
    v.vmx["memsize"] = "4096"
    v.vmx["displayName"] = "dream-004"
    v.vmx["guestOS"] = "ubuntu-64"
    # v.vmx["ethernet0.pcislotnumber"] = "32"
    v.vmx["gui.fitGuestUsingNativeDisplayResolution"] = "TRUE"
    v.vmx["gui.lastPoweredViewMode"] = "fullscreen"
    v.vmx["gui.viewModeAtPowerOn"] = "fullscreen"
    v.vmx["svga.graphicsMemoryKB"] = "2097152"
    v.vmx["mks.enable3d"] = "TRUE"
    v.vmx["tools.syncTime"] = "TRUE"
  end
  
  config.vm.provision :shell, path: "./system-setup.sh"
  config.vm.provision :shell, inline: <<-SHELL.gsub(/^ +/, '')
    sudo chmod +x /vagrant/coder-setup.sh
    sudo -iu coder /bin/zsh -c "/vagrant/coder-setup.sh"
  SHELL
end

# After the first provisioning
# TODO...