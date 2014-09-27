# DEPENDENCIES
# * VirtualBox
# * Chef Development Kit
# * Vagrant
# * Vagrant Plugins
#   * vagrant plugin install vagrant-berkshelf
#   * vagrant plugin install vagrant-omnibus

# TODO: https://github.com/dotless-de/vagrant-vbguest???
# TODO: remove `default: stdin: is not a tty` warning

Vagrant.configure(VAGRANTFILE_API_VERSION = "2") do |config|
  # Name of the registered base box to use
  config.vm.box = "ubuntu-14.10"

  # Url where to find the base box in case is not registered on this host
  config.vm.box_url = "https://dl.dropboxusercontent.com/u/7048158/ubuntu-14.10.box"

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

  config.vm.provider :virtualbox do |vb|
    # Machine name
    vb.name = "dream-ubuntu"

    # Boot with GUI or not
    vb.gui = true

    # VM customization
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--accelerate3d", vb.gui ? "on" : "off"]
    vb.customize ["modifyvm", :id, "--clipboard", vb.gui ? "bidirectional" : "disabled"]
    vb.customize ["modifyvm", :id, "--vram", vb.gui ? "256" : "12"]
    vb.customize ["modifyvm", :id, "--acpi", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-interval', '500']
    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', '800']
  end

  config.vm.provision :chef_solo do |chef|
    chef.custom_config_path = "Vagrantfile.chef"
    chef.json = {
      "dotfiles" => {
        "user" => "coder",
        "group" => "users",
        "password" => "$1$oydT51W0$j6sCuAbZq4zTyXE1dsT5k1",
        "private" => {
          ".netrc" => IO.read(File.expand_path("~/.netrc")),
          ".ssh/config" => IO.read(File.expand_path("~/.ssh/config")),
          ".ssh/id_rsa.gabrielelana" => IO.read(File.expand_path("~/.ssh/id_rsa.gabrielelana")),
          ".ssh/id_rsa.gabrielelana.pub" => IO.read(File.expand_path("~/.ssh/id_rsa.gabrielelana.pub")),
          ".ssh/id_rsa.cleancode" => IO.read(File.expand_path("~/.ssh/id_rsa.cleancode")),
          ".ssh/id_rsa.cleancode.pub" => IO.read(File.expand_path("~/.ssh/id_rsa.cleancode.pub"))
        }
      }
    }
    chef.add_recipe "dream"
    chef.add_recipe "dotfiles"
  end
end
