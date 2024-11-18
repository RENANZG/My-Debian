#!/bin/bash
# Debian based systems

init()
{
  echo "-"
  echo "| $1: INIT =========="
  echo "-"
}

mkdir -p ./installation
cd installation

local=$(pwd)

sudo apt-get install gconf2 -y
sudo dpkg-reconfigure gconf2
sudo apt-get update -y
 
# Mint tricia, tessa or tina    -> bionic
# Mint 20 ulyana                -> bionic
# Outher                        -> lsb_release -cs
version=$(lsb_release -cs)

# For Linux Mint 19
if [ $version = "tricia" ] || [ $version = "tina" ] || [ $version = "tessa" ]; then
  version="bionic"
fi

# For Linux Mint 20
if [ $version = "ulyana" ]; then
  version="focal"
fi

###############
# Dependecies #
###############
init DEPENDECIES

sudo apt-get install  \
  build-essential \
  libgl1-mesa-glx \
  libegl1-mesa  \
  libxrandr2  \
  libxrandr2  \
  libxss1  \
  libxcursor1  \
  libxcomposite1  \
  libasound2  \
  libxi6  \
  libxtst6  \
  xz-utils \
  libqt5webkit5  \
  libqt5multimedia5  \
  libqt5xml5  \
  libqt5script5 \
  libqt5scripttools5 \
  gcc-multilib \
  lib32z1 \
  lib32stdc++6 \
  file \
  ffmpeg \
  g++ -y

# Docker
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common -y

sudo wget http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.8_amd64.deb \
  -O libicu52.deb

sudo wget http://ftp.debian.org/debian/pool/main/libp/libpng/libpng12-0_1.2.50-2+deb8u3_amd64.deb \
  -O libpng12.deb

sudo dpkg -i libicu52.deb
sudo dpkg -i libpng12.deb

mkdir -p ~/Pictures/icons
mkdir -p ~/apps
mkdir -p ~/android/sdk

sudo apt-get update -y

################
# Repositories #
################
init REPOSITORIES

# Java
sudo add-apt-repository ppa:openjdk-r/ppa

# Ulauncher
sudo add-apt-repository ppa:agornostal/ulauncher

# yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# sudo add-apt-repository \
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $version \
#   stable"
echo -e "\ndeb [arch=amd64] https://download.docker.com/linux/ubuntu $version stable" | \
  sudo tee -a /etc/apt/sources.list

# Add insomnia to sources 
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" \
  | sudo tee -a /etc/apt/sources.list.d/insomnia.list

wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc \
  | sudo apt-key add -

# Plank Dock
sudo add-apt-repository ppa:docky-core/stable

# OBS studio
sudo add-apt-repository ppa:obsproject/obs-studio

# VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update -y

#################
# installations #
#################
init INSTALLATIONS

sudo apt-get install openjdk-8-jre openjdk-8-jdk git unzip -y

# NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts

# Yarn
sudo apt-get install --no-install-recommends yarn -y

# MongoDb Compass
sudo wget https://downloads.mongodb.com/compass/mongodb-compass_1.21.2_amd64.deb -O compass.deb
sudo dpkg -i compass.deb

# VS code
sudo apt-get install code -y

# Postbird
sudo wget https://github.com/Paxa/postbird/releases/download/0.8.4/Postbird_0.8.4_amd64.deb -O postbird.deb
sudo dpkg -i postbird.deb

sudo flatpak install flathub com.discordapp.Discord \
  com.slack.Slack \
  us.zoom.Zoom \
  com.spotify.Client \
  org.videolan.VLC \
  org.kde.krita \
  org.inkscape.Inkscape -y
 
# Arduino
sudo wget https://downloads.arduino.cc/arduino-1.8.13-linux64.tar.xz -O arduino.tar.xz
tar xf arduino.tar.xz
sudo rm arduino.tar.xz

sudo mv arduino* /opt
sudo bash /opt/arduino*/install.sh
sudo chown -R $USER /opt/arduino*

# Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo groupadd docker
sudo usermod -aG docker $USER

# Docker Compose
sudo wget -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -O /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Watchman
brew install watchman

#Github CLI
brew install github/gh/gh

# Flipper
sudo wget https://github.com/facebook/flipper/releases//download/v0.50.0/Flipper-linux.zip -O flipper.zip

mkdir -p ~/apps/flipper
mv flipper.zip ~/apps/flipper/

cd ~/apps/flipper

unzip -a flipper.zip

rm -rf flipper.zip

cd $local

# Obins Kit (for my keyboard)
sudo wget http://releases.obins.net/occ/linux/deb/ObinsKit_1.1.4_x64.deb -O obinskit.deb
sudo dpkg -i obinskit.deb

# OBS Studio, Virtual Box, Insomnia, Ulauncher and Plank  
sudo apt-get install obs-studio -y

sudo apt-get install virtualbox -y

sudo apt-get install insomnia -y

sudo apt-get install ulauncher -y

sudo apt-get install plank -y

# Hyper Terminal
sudo wget https://github.com/zeit/hyper/releases/download/3.0.2/hyper_3.0.2_amd64.deb -O hyper.deb
sudo dpkg -i hyper.deb

# Finishing
sudo apt-get --fix-broken install -y
sudo apt-get autoremove -y

sudo chown -R $USER $HOME/*

# Icon Theme
git clone https://github.com/vinceliuice/Tela-icon-theme.git
cd Tela-icon-theme

./install.sh purple

cd ../..

# oh my zsh - terminal
sudo apt-get install zsh -y
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh

# this is not going to be run
bash ./zsh_config.sh

echo "================================="
echo "| I recommend reboot the system |"
echo "================================="
