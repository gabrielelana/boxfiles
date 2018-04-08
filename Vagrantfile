# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "generic/ubuntu1710"

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
    v.name = "dream-003"

    # Boot with GUI
    v.gui = true
    
    # VMWare Customization
    v.vmx["numvcpus"] = "4"
    v.vmx["memsize"] = "4096"
    v.vmx["displayName"] = "dream-003"
    v.vmx["guestOS"] = "ubuntu-64"
    v.vmx["ethernet0.pcislotnumber"] = "32"
    v.vmx["gui.fitGuestUsingNativeDisplayResolution"] = "TRUE"
    v.vmx["gui.lastPoweredViewMode"] = "fullscreen"
    v.vmx["gui.viewModeAtPowerOn"] = "fullscreen"
    v.vmx["svga.graphicsMemoryKB"] = "2097152"
    v.vmx["mks.enable3d"] = "TRUE"
    v.vmx["tools.syncTime"] = "TRUE"
  end
   
  HEREDOC = "<<"
      
  config.vm.provision "shell", inline: <<-SHELL.gsub(/^ +/, '')
    echo "Update package repositories..."
    sudo apt-get update
    
    echo "Install basic packages..."
    sudo apt-get install -y \
      build-essential autoconf git zsh silversearcher-ag emacs25 \
      vim-gtk unzip xorg unclutter autocutsel dunst i3 suckless-tools \
      x11-utils gnome-terminal libglib2.0-bin slim firefox gnome-themes-* \
      libreadline-dev dbus-x11 jq
    
    echo "Install erlang dependencies..."
    sudo apt-get install -y \
      libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev \
      libssl-dev libncurses5-dev unixodbc-dev xsltproc libxml2-dev fop
      
    echo "Install emacs dependencies..."
    sudo apt-get install -y \
      texinfo libgtk-3-dev libxpm-dev libgif-dev libgnutls-dev
    
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
    if ! id -u coder 2>&1 >/dev/null; then
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
    
    # TODO: for some reason here coder is not a valid user...
    echo -n "Trying to become coder..."
    sudo -iu coder /bin/bash 2>&1 >/dev/null
    if ! [ "`whoami`" = "coder" ]; then sleep 2; echo -n "."; sudo -iu coder /bin/bash 2>&1 >/dev/null; fi
    if ! [ "`whoami`" = "coder" ]; then sleep 2; echo -n "."; sudo -iu coder /bin/bash 2>&1 >/dev/null; fi
    if ! [ "`whoami`" = "coder" ]; then sleep 2; echo -n "."; sudo -iu coder /bin/bash 2>&1 >/dev/null; fi
    if ! [ "`whoami`" = "coder" ]; then sleep 2; echo -n "."; sudo -iu coder /bin/bash 2>&1 >/dev/null; fi
    if ! [ "`whoami`" = "coder" ]; then echo " Unable to become coder, giving up ;-("; exit 1; fi
      
    echo "Install dotfiles..."
    [ ! -d .dotfiles ] && git clone git@github.com:gabrielelana/dotfiles.git .dotfiles
    cd .dotfiles
    zsh install-or-update.sh
    sudo zsh configure-slim-theme.sh
    
    echo "Install asdf and related plugins..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.3.0
      
    $HOME/.asdf/bin/asdf plugin-add mongodb https://github.com/sylph01/asdf-mongodb.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add ocaml https://github.com/vic/asdf-ocaml.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git 2>&1 >/dev/null
    $HOME/.asdf/bin/asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>&1 >/dev/null
    bash $HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring 2>&1 >/dev/null
    
    echo "Install things with asdf..."
    function asdf_install() {
      echo -n "Installing $1 version $2... "
      $HOME/.asdf/bin/asdf install $1 $2 >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        $HOME/.asdf/bin/asdf global $1 $2
        echo "done"
      else
        echo "failed ;-("
      fi
    }
    asdf_install mongodb 3.5.1
    asdf_install erlang 20.3
    asdf_install elixir 1.6.4
    asdf_install nodejs 8.11.1
    asdf_install postgres 9.6.8

    echo "Install rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
    
    echo "Install haskell..."
    curl -sSL https://get.haskellstack.org/ | sh
    
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
# TODO...