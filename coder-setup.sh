#!/bin/zsh

echo "Setup coder..."
whoami 

echo "Install dotfiles..."
[ ! -d .dotfiles ] && git clone git@github.com:gabrielelana/dotfiles.git .dotfiles
cd .dotfiles
zsh install-or-update.sh
sudo zsh configure-slim-theme.sh

echo "Install asdf and related plugins..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.6.2
  
$HOME/.asdf/bin/asdf plugin-add mongodb https://github.com/sylph01/asdf-mongodb.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add postgres https://github.com/smashedtoatoms/asdf-postgres.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add ocaml https://github.com/vic/asdf-ocaml.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add php https://github.com/odarriba/asdf-php.git 2>&1 >/dev/null
$HOME/.asdf/bin/asdf plugin-add java https://github.com/skotchpine/asdf-java.git 2>&1 >/dev/null
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
asdf_install mongodb 4.1.6
asdf_install erlang 21.2.2
asdf_install elixir 1.7.4-otp-21
asdf_install nodejs 11.6.0
asdf_install postgres 11.1

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