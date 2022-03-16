#!/usr/bin/env bash

################
#### Checks ####
################

if [ $(uname -m) != "x86_64" ]
then
	echo "This script currently only supports x86_64"
	exit 1
fi

if [ -z $(which apt-get) ]
then
	echo "This script currently only supports Debian based distributions"
	exit 1
fi

if [ $(id -u) != 0 ]
then
	echo "This script must be run with root privileges"
	exit 1
fi

export USER=$(logname)
export HOME=/home/$USER

#########################
#### Common Packages ####
#########################
echo "Installing Linux packages..."

apt-get update -qq

apt-get install -yqq \
	git \
	vim \
	build-essential \
    linux-tools-generic \
    nethogs \
	xclip \
	zsh \
	curl \
	gnome-tweaks \
	net-tools \
	dos2unix \
	ubuntu-restricted-extras \
	chrome-gnome-shell \
	fonts-hack \
	python3-pip \
	lsb-release \
	gnupg2 \
	libpython3-dev \
	guake \
	libinput-tools \
	ruby \
	libnotify-bin \
	notify-osd \
	ca-certificates \
	dirmngr \
	gnupg \
	apt-transport-https \
	software-properties-common \
	libvirt-dev \
	peek \
    kazam \
    iperf \
    tcpdump \
    pavucontrol

sudo gem install fusuma

# Pipewire
# https://askubuntu.com/questions/1339765/replacing-pulseaudio-with-pipewire-in-ubuntu-20-04
sudo add-apt-repository ppa:pipewire-debian/pipewire-upstream
sudo apt update
sudo apt install pipewire libspa-0.2-bluetooth pipewire-audio-client-libraries
systemctl --user daemon-reload
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user mask pulseaudio
systemctl --user --now enable pipewire-media-session.service
systemctl --user restart pipewire

################
#### Python ####
################

apt-get install -y python3-pip &&
    python3 -m pip install --upgrade pip

#################
####### R #######
#################

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu `lsb_release -cs`-cran40/"
apt-get install -y r-base

#################
#### Node.js ####
#################

NVM_VERSION='v0.38.0'

if ! [ -d $HOME/.nvm ]
then
echo "Installing Node.js Version Manager ($NVM_VERSION)..."

# nvm
# https://github.com/nvm-sh/nvm#install--update-script
wget https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh -O $HOME/nvm-install.sh

sudo -Hiu $USER bash $HOME/nvm-install.sh

sudo -Hiu $USER nvm install node

sudo -Hiu $USER nvm use node

else
echo "Node.js Version Manager already installed"

fi

##############
#### Rust ####
##############

if [ -z $(sudo -Hiu $USER which rustc) ]
then
echo "Installing Rust with rustup..."

# rustup
# https://www.rust-lang.org/tools/install
# https://github.com/rust-lang/rustup/issues/297#issuecomment-444818896
sudo -Hiu $USER curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

else
echo "Rust already installed"

fi

################
#### Docker ####
################

# https://docs.docker.com/engine/install/ubuntu/


if [ -z $(sudo -Hiu $USER which docker) ]
then
echo "Installing Docker..."

apt-get install -yqq \
	apt-transport-https \
	ca-certificates \
	gnupg-agent \
	software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

apt-get update -qq

apt-get install -yqq \
	docker-ce \
	docker-ce-cli \
	containerd.io

# Make it so docker does not need sudo
# https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user

groupadd docker

usermod -aG docker $USER

else
echo "Docker already installed"

fi

if [ -z $(sudo -Hiu $USER which docker-compose) ]
then
echo "Installing Docker Compose..."
	curl -L "https://github.com/docker/compose/releases/download/1.27.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
else
	echo "docker-compose already installed"
fi
####################
#### Kubernetes ####
####################

# kubectl
# https://kubernetes.io/docs/tasks/tools/install-kubectl/

if [ -z $(sudo -Hiu $USER which kubectl) ]
then
echo "Installing kubectl..."

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x ./kubectl

mv ./kubectl /usr/local/bin/kubectl

else
echo "kubectl already installed"

fi

####################
##### Vagrant ######
####################
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && sudo apt-get install vagrant
vagrant plugin install vagrant-libvirt

##############
#### Java ####
##############

if [ -z $(sudo -Hiu $USER which javac) ]
then
echo "Installing OpenJDK..."

apt-get install -yqq default-jdk

else
echo "Java Development Kit already installed"

fi

#############
#### C++ ####
#############

if [ -z $(sudo -Hiu $USER which clang) ]
then
echo "Installing tools for C++ development..."

apt-get install -yqq \
	clang \
	clang-format \
	clang-tidy \
	cmake \
	valgrind

else
echo "C++ tools already installed"

fi

############################
#### Visual Studio Code ####
############################

if [ -z $(sudo -Hiu $USER which code) ]
then
echo "Installing Visual Studio Code..."

wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -

add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

apt-get -qq update

apt-get install -yqq code

else
echo "Visual Studio Code already installed"

fi

############################
###### Customization #######
############################

sudo apt-add-repository ppa:papirus/papirus && sudo apt install papirus-icon-theme


############################
########## Vim #############
############################

# Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall
