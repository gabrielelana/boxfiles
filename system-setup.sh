#!/bin/bash

echo "Setup system..."

echo "Update package repositories..."
apt-get update

echo "Install basic packages..."
apt-get install -y \
  build-essential autoconf git zsh silversearcher-ag \
  unzip xorg unclutter autocutsel dunst i3 suckless-tools \
  x11-utils gnome-terminal libglib2.0-bin slim firefox \
  gnome-themes-standard gnome-themes-extra gnome-themes-ubuntu \
  libreadline-dev dbus-x11 jq entr iitalian aspell-it libxft-dev \
  gnutls-bin

echo "Install Erlang dependencies..."
apt-get install -y \
  libwxgtk3.0-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev \
  libssl-dev libncurses5-dev unixodbc-dev xsltproc libxml2-dev fop

echo "Install Emacs..."
 add-apt-repository -y ppa:kelleyk/emacs
 apt-get install -y emacs26

echo "Install Chrome..."
if [ ! -f /etc/apt/sources.list.d/google.list ]; then
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list
  apt-get update
  apt-get install -y google-chrome-stable
fi

echo "Install Utilities..."
RELEASE="stable"
# shellcheck
wget --quiet "https://storage.googleapis.com/shellcheck/shellcheck-${RELEASE}.linux.x86_64.tar.xz"
tar --xz -xvf shellcheck-"${RELEASE}".linux.x86_64.tar.xz
cp shellcheck-"${RELEASE}"/shellcheck ~/bin/shellcheck
rm -rf shellcheck-"${RELEASE}"
rm -f shellcheck-"${RELEASE}".linux.x86_64.tar.xz

echo "System configuration..."
timedatectl set-timezone Europe/Rome
update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "Create user coder..."
if ! id -u coder >/dev/null 2>&1; then
  useradd --gid users --groups sudo --shell /bin/zsh --password RN6rj58jeFlVU coder
  echo "Create home layout..."
  mkdir -p /home/coder/{etc,code,opt,tmp}
  echo "SSH configuration..."
  mkdir -p /home/coder/.ssh
  if [ ! -f /vagrant/id_rsa.gabrielelana ]; then
    echo "Missing ssh key files" 1>&2
    exit 1
  fi
  cp /vagrant/id_rsa.gabrielelana /home/coder/.ssh
  cp /vagrant/id_rsa.gabrielelana.pub /home/coder/.ssh
  chmod 0400 /home/coder/.ssh/id_rsa.gabrielelana
  cat <<EOF | sed -e 's/^\s\{4\}//' > /home/coder/.ssh/config
    Host *
    ServerAliveInterval 60
    ConnectTimeout 1

    Host github.com
      User git
      IdentityFile ~/.ssh/id_rsa.gabrielelana
      StrictHostKeyChecking no
      HostName github.com
EOF
  echo "Finishing home directory..."
  chown -R coder:users /home/coder
else
  echo "User coder already exists... nothing to be done..."
fi
