#!/bin/bash

# This installs most packages I want to have on an Ubuntu system (x86)

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
PROFILE=$HOME/.bashrc

#########################
#### Common Packages ####
#########################
echo "Installing common Linux packages..."

apt-get update -qq

apt-get install -yqq \
	git \
	vim \
	build-essential \
	xclip \
	zsh \
	curl \
	gnome-tweaks \
	net-tools \
	dos2unix

################
#### Python ####
################

if ! [ -d $HOME/anaconda3 ]
then
echo "Installing Anaconda Python (2020.07)..."

# For using GUI packages
# https://docs.anaconda.com/anaconda/install/linux/
apt-get install -yqq \
	libgl1-mesa-glx \
	libegl1-mesa \
	libxrandr2 \
	libxrandr2 \
	libxss1 \
	libxcursor1 \
	libxcomposite1 \
	libasound2 \
	libxi6 \
	libxtst6

wget https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh -O $HOME/anaconda.sh

# Haven't figured out a way to do this silently AND add entries to .bashrc
sudo -Hiu $USER bash $HOME/anaconda.sh

fi

#################
#### Node.js ####
#################

if ! [ -d $HOME/.nvm ]
then
echo "Installing Node.js Version Manager (0.35.3)..."

# nvm 0.35.3
# https://github.com/nvm-sh/nvm#install--update-script
wget https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh -O $HOME/nvm-install.sh

sudo -Hiu $USER bash $HOME/nvm-install.sh

sudo -Hiu $USER nvm install node

sudo -Hiu $USER nvm use node

if [ -z $(grep 'npm-completion' $PROFILE) ]
then
npm completion >> $PROFILE
fi

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

############
#### Go ####
############

if ! [ -d /usr/local/go ]
then
GO_VERSION=1.15

echo "Installing the Go compiler ($GO_VERSION)..."

# https://golang.org/doc/install
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -O $HOME/go$GO_VERSION.linux-amd64.tar.gz

tar -C /usr/local -xzf $HOME/go1.15.linux-amd64.tar.gz

echo "export PATH=\$PATH:/usr/local/go/bin" >> $PROFILE

else
echo "Go already installed"

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
	curl \
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
	cmake

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

