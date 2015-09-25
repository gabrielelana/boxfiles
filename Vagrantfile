# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/vivid64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

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
    vb.name = "dream-ubuntu"

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
    # TODO: if not done in the last 30 days, do
    # apt-get -y upgrade && apt-get -y autoremove
    
    echo "Install basic packages..."
    sudo apt-get install -y build-essential git zsh ack-grep vim-gtk emacs unzip fop xsltproc
    sudo apt-get install -y xorg unclutter dunst i3 suckless-tools x11-utils virtualbox-guest-*
    sudo apt-get install -y gnome-terminal dconf-cli slim chromium-browser firefox gnome-themes-extras
    sudo apt-get install -y postgresql libpq-dev
    
    # TODO: configure postgresql
    
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
        # cp ~/.ssh/id_rsa.gabrielelana .
        # cp ~/.ssh/id_rsa.gabrielelana.pub .
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
    
    echo "Install dotfiles..."
    sudo -iu coder #{HEREDOC}EOC
      [ ! -d .dotfiles ] && git clone git@github.com:gabrielelana/dotfiles.git .dotfiles
      cd .dotfiles
      if git pull | grep -v up-to-date > /dev/null; then
        zsh install-or-update.sh
        sudo zsh configure-slim-theme.sh
      fi
    EOC
    
    echo "Install MongoDB..."
    if [ ! -f /etc/apt/sources.list.d/mongodb-org-3.0.list ]; then
      sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
      echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
      sudo apt-get update
      
      cat #{HEREDOC}EOF > /etc/init.d/disable-transparent-hugepages
         #!/bin/sh
         ### BEGIN INIT INFO
         # Provides:          disable-transparent-hugepages
         # Required-Start:    $local_fs
         # Required-Stop:
         # X-Start-Before:    mongod mongodb-mms-automation-agent
         # Default-Start:     2 3 4 5
         # Default-Stop:      0 1 6
         # Short-Description: Disable Linux transparent huge pages
         # Description:       Disable Linux transparent huge pages, to improve
         #                    database performance.
         ### END INIT INFO
      
         case \\$1 in
           start)
             if [ -d /sys/kernel/mm/transparent_hugepage ]; then
               thp_path=/sys/kernel/mm/transparent_hugepage
             elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
               thp_path=/sys/kernel/mm/redhat_transparent_hugepage
             else
               return 0
             fi
      
             echo 'never' > \\${thp_path}/enabled
             echo 'never' > \\${thp_path}/defrag
      
             unset thp_path
           ;;
         esac
       EOF
       sudo chmod 755 /etc/init.d/disable-transparent-hugepages
       sudo /etc/init.d/disable-transparent-hugepages start
    fi
    sudo apt-get install -y mongodb-org
    sudo -iu coder #{HEREDOC}EOC
      if [ ! -f ~/.mongorc ]; then
        curl -sL https://raw.github.com/gabrielelana/mongodb-shell-extensions/master/released/mongorc.js > ~/.mongorc.js
      fi
    EOC
    
    echo "Install Erlang..."
    if [ ! -f /etc/apt/sources.list.d/erlang-solutions.list ]; then
      sudo curl -sL http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -o /tmp/erlang-solutions_1.0_all.deb
      sudo dpkg -i /tmp/erlang-solutions_1.0_all.deb
      sudo rm -f /tmp/erlang-solutions_1.0_all.deb
      sudo apt-get update
    fi
    sudo apt-get install -y esl-erlang
        
    echo "Install Elixir..."
    sudo -iu coder #{HEREDOC}EOC
      source ~/.zshrc
      if [ ! -d ~/.kiex ]; then
        curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s
        # Ugly patch to fix a bug in Erlang release discovery
        sed -i 's/\\.\\.\\/\\.\\.\\/releases/..\\/releases/' ~/.kiex/bin/kiex
        source ~/.kiex/scripts/kiex
      fi
      for ev in 1.0.5 1.1.0-rc.0; do
        if ! kiex list | grep \\$ev > /dev/null; then
          echo "Installing Elixir \\$ev..."
          kiex install \\$ev
        fi
      done
      kiex use 1.1.0-rc.0 --default
    EOC
    
    echo "Install NodeJS..."
    sudo -iu coder #{HEREDOC}EOC
      source ~/.zshrc
      if [ ! -d ~/.nvm ]; then
        echo "Installing NVM..."
        git clone git@github.com:creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags` && cd ~
        source ~/.nvm/nvm.sh
      fi
      echo "Installing NodeJS stable..."
      nvm install v0.12.6
      nvm install stable
      nvm alias default stable
    EOC
     
    echo "Install Ruby"
    sudo -iu coder #{HEREDOC}EOC
      source ~/.zshrc
      if [ ! -d ~/.rvm ]; then
        curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles
        source ~/.rvm/scripts/rvm
      fi
      rvm install ruby-2.2.0
    EOC
        
    if ! sudo service slim status | grep active; then
      sudo service slim start
    fi
  SHELL
end
