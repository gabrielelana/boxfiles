# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/ubuntu-17.04"

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

  config.vm.hostname = "apollo"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  config.vm.provider :virtualbox do |vb|
    # Machine name
    vb.name = "dream-002"

    # Boot with GUI or not
    vb.gui = true

    # Use VBoxManage to customize the VM
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    vb.customize ["modifyvm", :id, "--accelerate3d", vb.gui ? "on" : "off"]
    vb.customize ["modifyvm", :id, "--clipboard", vb.gui ? "bidirectional" : "disabled"]
    vb.customize ["modifyvm", :id, "--vram", vb.gui ? "256" : "12"]
    vb.customize ["modifyvm", :id, "--acpi", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ['guestproperty', 'set', :id,
                  '/VirtualBox/GuestAdd/VBoxService/--timesync-interval', '500']
    vb.customize ['guestproperty', 'set', :id,
                  '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', '800']
  end
   
  HEREDOC = "<<"
    
  config.vm.provision "shell", inline: <<-SHELL.gsub(/^ +/, '')
    echo "Update package repositories..."
    sudo apt-get update
    
    echo "Install basic packages..."
    sudo apt-get install -y \
      build-essential git zsh ack-grep silversearcher-ag emacs25 \
      vim-gtk unzip xorg unclutter autocutsel dunst i3 suckless-tools \
      x11-utils gnome-terminal libglib2.0-bin slim firefox gnome-themes-* \
      libreadline-dev dbus-x11 jq
    
    echo "Install Chrome"
    if [ ! -f /etc/apt/sources.list.d/google.list ]; then
      wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
      echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
      sudo apt-get update
      sudo apt-get install -y google-chrome-stable
    fi
    
    echo "System configuration..."
    sudo timedatectl set-timezone Europe/Rome
    sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    
    echo "Create user coder..."
    if ! id -u coder 2>&1 > /dev/null; then
      sudo useradd --gid users --groups sudo --shell /bin/zsh --password RN6rj58jeFlVU coder
      sudo mkdir -p /home/coder/{etc,code,opt,tmp}
      sudo mkdir -p /home/coder/.ssh
      if [ ! -f /vagrant/id_rsa.gabrielelana ]; then
        echo "Missing ssh key files" 1>&2
        exit 1
      fi
      sudo cp /vagrant/id_rsa.gabrielelana /home/coder/.ssh
      sudo cp /vagrant/id_rsa.gabrielelana.pub /home/coder/.ssh
      cat #{HEREDOC}EOF > /home/coder/.ssh/config
        Host *
        ServerAliveInterval 60
        ConnectTimeout 1
      
        Host github.com
        User git
        IdentityFile ~/.ssh/id_rsa.gabrielelana
        StrictHostKeyChecking no
        HostName github.com
      EOF
      sudo chown -R coder:users /home/coder
    fi
    
    sudo -iu coder
    echo "Install dotfiles..."
    [ ! -d .dotfiles ] && git clone git@github.com:gabrielelana/dotfiles.git .dotfiles
    cd .dotfiles
    zsh install-or-update.sh
    sudo zsh configure-slim-theme.sh
    
    echo "Install asdf and related plugins..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
      
    $HOME/.asdf/bin/asdf plugin-add mongodb https://github.com/sylph01/asdf-mongodb.git
    $HOME/.asdf/bin/asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git
    $HOME/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    $HOME/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    $HOME/.asdf/bin/asdf plugin-add haskell https://github.com/vic/asdf-haskell.git
    $HOME/.asdf/bin/asdf plugin-add ocaml https://github.com/vic/asdf-ocaml.git
    $HOME/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
    $HOME/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    $HOME/.asdf/bin/asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
    bash $HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring
    
    echo "Install things with asdf..."
    asdf install mongodb 3.5.1 && asdf global mongodb 3.5.1
    asdf install erlang 19.3 && asdf global erlang 19.3
    asdf install elixir 1.4.5-otp-19 && asdf global elixir 1.4.5-otp-19
    asdf install nodejs 6.11.1 && asdf global nodejs 6.11.1
    asdf install postgres 9.6.3 && asdf global postgres 9.6.3
    
    echo "Install rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    
    # TODO: install Heroku command line + credentials
    # TODO: install Travis command line + credentials
    # TODO: install AWS command line + credentials
        
    echo "Start Slim..."
    if sudo service slim status | grep inactive; then
      sudo service slim start
    fi
  SHELL
end

# After the first provisioning

# 1 - Enable HiDPI Display in VirtualBox
# "Display > Use Unscaled HiDPI Output" in VirtualBox machine's preferences

# 2 - Install VirtualBox additions (need to reinstall when X server is running)
# $ vagrant ssh
# $ cd tmp
# $ mkdir drive && sudo mount -o loop,ro VBoxGuestAdditions_5.1.26.iso drive
# $ cd drive && sudo ./VBoxLinuxAdditions.run

# 3 - Configure colors of gnome-terminal