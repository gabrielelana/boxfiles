# DEPENDENCIES
# * VirtualBox
# * Chef Development Kit
# * Vagrant
# * Vagrant Plugins
#   * vagrant plugin install vagrant-berkshelf
#   * vagrant plugin install vagrant-omnibus
#   * vagrant plugin install vagrant-vmware-fusion
#   * vagrant plugin license vagrant-vmware-fusion license.lic

# TODO: https://github.com/dotless-de/vagrant-vbguest???
# TODO: remove `default: stdin: is not a tty` warning

# Upgrade to latest ustable ubuntu release
# ...
# $ sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get dist-upgrade
# $ sudo apt-get install update-manager-core
# $ sudo do-release-upgrade

# Create Vagrant Ubuntu base box
# http://aruizca.com/steps-to-create-a-vagrant-base-box-with-ubuntu-14-04-desktop-gui-and-virtualbox
# List installed packages by size
# dpkg-query -W --showformat='${Installed-Size;10}\t${Package}\n' | sort -k1,1n
# Purge
# sudo apt-get remove --purge $(dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d')
# sudo apt-get remove --purge libreoffice* thunderbird* totem*  && sudo apt-get clean && sudo apt-get autoremove

# To fix the compilation problem of hgfs module in kernel 3.20, install an older kernel
# $ sudo cat <<EOF >> /etc/apt/sources.list
#   deb http://it.archive.ubuntu.com/ubuntu/ trusty main
#   deb-src http://it.archive.ubuntu.com/ubuntu/ trusty main
#   deb http://it.archive.ubuntu.com/ubuntu/ trusty universe
#   deb-src http://it.archive.ubuntu.com/ubuntu/ trusty universe
#   deb http://it.archive.ubuntu.com/ubuntu/ trusty-updates main
#   deb-src http://it.archive.ubuntu.com/ubuntu/ trusty-updates main
#   deb http://it.archive.ubuntu.com/ubuntu/ trusty-updates universe
#   deb-src http://it.archive.ubuntu.com/ubuntu/ trusty-updates universe
#   EOF
# $ sudo apt-get update
# $ sudo apt-get install linux-image-3.13.0-36-generic linux-headers-3.13.0-36 linux-headers-3.13.0-36-generic linux-image-extra-3.13.0-36-generic
# $ sudo apt-get remove --purge linux-image-3.16.0-20-generic linux-headers-3.16.0-20*
# Then re-install VMware Tools
# $ sudo ./vmware-install.pl -d

# Package VMware vm (https://github.com/rvalente/dotfiles/blob/2e940988b9567df77a9bc8b3e0ba7b33cdef4ac8/bin/makebox)
# $ cd <VM_DIRECTORY>
# $ vmware-vdiskmanager -d "Virtual Disk.vmdk"
# $ vmware-vdiskmanager -k "Virtual Disk.vmdk"
# $ rm -rf *.log
# $ cat <<EOF > metadata.json
#   {
#     "provider":"vmware_fusion"
#   }
#   EOF
# $ tar cvzf dream-ubuntu.box ./*
# $ vagrant box add --clean --provider vmware_fusion --name ubuntu-14.10 dream-ubuntu.box

# Customize VMware VM parameters on the fly
# http://thornelabs.net/2013/09/28/customizing-vagrant-vmware-fusion-virtual-machines-with-vmx-parameters.html


Vagrant.configure(VAGRANTFILE_API_VERSION = "2") do |config|
  # Name of the registered base box to use
  config.vm.box = "ubuntu-14.10"

  # Url where to find the base box in case is not registered on this host
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/7048158/vmware-ubuntu-14.10.box"

  # Enable Berkshelf plugin
  config.berkshelf.enabled = true
  
  # Ensure chef is installed in the current vm
  config.omnibus.chef_version = :latest  

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 3000, host: 3000
  # config.vm.network :forwarded_port, guest: 9000, host: 9000
  # config.vm.network :forwarded_port, guest: 35729, host: 35729

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "10.0.2.42"

  # Share host Desktop with Dream machine
  config.vm.synced_folder "~/Desktop", "/mnt/host"

  config.vm.provider :vmware_fusion do |v|
    # Machine name
    v.name "try-dream-ubuntu"
    
    # Boot with GUI or not
    v.gui = true
    
    # VM customization
    v.vmx["numvcpus"] = "2"
    v.vmx['memsize'] = "4096"
    v.vmx["displayName"] = "try-dream-ubuntu"
    v.vmx["vcpu.hotadd"] = "TRUE"
    v.vmx["mem.hotadd"] = "TRUE"
    v.vmx["vhv.enable"] = "TRUE"
    v.vmx["vpmc.enable"] = "TRUE"
    v.vmx["mks.enable3d"] = "TRUE"
    v.vmx["tools.syncTime"] = "TRUE"
    v.vmx["cleanShutdown"] = "TRUE"
    v.vmx["softPowerOff"] = "TRUE"
    v.vmx["svga.graphicsMemoryKB"] = "1048576"
    v.vmx["gui.fitGuestUsingNativeDisplayResolution"] = "TRUE"
  end

#  config.vm.provider :virtualbox do |vb|
#    # Machine name
#    vb.name = "dream-ubuntu"
#
#    # Boot with GUI or not
#    vb.gui = true
#
#    # VM customization
#    vb.customize ["modifyvm", :id, "--memory", "2048"]
#    vb.customize ["modifyvm", :id, "--cpus", "4"]
#    vb.customize ["modifyvm", :id, "--accelerate3d", vb.gui ? "on" : "off"]
#    vb.customize ["modifyvm", :id, "--clipboard", vb.gui ? "bidirectional" : "disabled"]
#    vb.customize ["modifyvm", :id, "--vram", vb.gui ? "256" : "12"]
#    vb.customize ["modifyvm", :id, "--acpi", "on"]
#    vb.customize ["modifyvm", :id, "--ioapic", "on"]
#    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-interval', '500']
#    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', '800']
#  end

#  config.vm.provision :chef_solo do |chef|
#    chef.custom_config_path = "Vagrantfile.chef"
#    chef.json = {
#      "dotfiles" => {
#        "user" => "coder",
#        "group" => "users",
#        "password" => "$1$oydT51W0$j6sCuAbZq4zTyXE1dsT5k1",
#        "private" => {
#          ".netrc" => IO.read(File.expand_path("~/.netrc")),
#          ".ssh/config" => IO.read(File.expand_path("~/.ssh/config")),
#          ".ssh/id_rsa.gabrielelana" => IO.read(File.expand_path("~/.ssh/id_rsa.gabrielelana")),
#          ".ssh/id_rsa.gabrielelana.pub" => IO.read(File.expand_path("~/.ssh/id_rsa.gabrielelana.pub")),
#          ".ssh/id_rsa.cleancode" => IO.read(File.expand_path("~/.ssh/id_rsa.cleancode")),
#          ".ssh/id_rsa.cleancode.pub" => IO.read(File.expand_path("~/.ssh/id_rsa.cleancode.pub"))
#        }
#      }
#    }
#    chef.add_recipe "dream"
#    chef.add_recipe "dotfiles"
#  end
end
