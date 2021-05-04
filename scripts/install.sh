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
SETUP_HOME="$(dirname $( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd ))"

#########################
######## Dotfiles #######
#########################

ln -s $SETUP_HOME/dotfiles/* $HOME/

echo "export SETUP_HOME=$SETUP_HOME" > $HOME/.setup

#########################
#### Common Packages ####
#########################
echo "Installing Linux packages..."

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
	ruby

sudo gem install fusuma

################
#### Python ####
################

if ! [ -d $HOME/anaconda3 ]
then
echo "Installing Anaconda Python (2020.07)..."

apt-get install -yqq \
	libgl1-mesa-glx \ # https://docs.anaconda.com/anaconda/install/linux/
	libegl1-mesa \
	libxrandr2 \
	libxrandr2 \
	libxss1 \
	libxcursor1 \
	libxcomposite1 \
	libasound2 \
	libxi6 \
	libxtst6

wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O $HOME/anaconda.sh

# Haven't figured out a way to do this silently AND add entries to .bashrc
sudo -Hiu $USER bash $HOME/anaconda.sh

fi

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

############
#### Go ####
############

if ! [ -d /usr/local/go ]
then
GO_VERSION=1.16.3

echo "Installing the Go compiler ($GO_VERSION)..."

# https://golang.org/doc/install
wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -O $HOME/go$GO_VERSION.linux-amd64.tar.gz

tar -C /usr/local -xzf $HOME/go$GO_VERSION.linux-amd64.tar.gz

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

###########################
######### Nvidia ##########
###########################

if [-z "$(apt-cache search cuda | grep cuda)"]
then

echo "Installing Nvidia tools..."

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&=Ubuntu&target_version=20.04&target_type=deb_local
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

else

	echo "CUDA already installed"

fi

############################
########## ROS1 ############
############################
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install -yqq ros-noetic-desktop-full

############################
########## ROS2 ############
############################
# https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Binary.html
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt-get update
sudo apt-get install -yqq ros-foxy-desktop
python3 -m pip install -U argcomplete

############################
###### Customization #######
############################

sudo apt-add-repository ppa:papirus/papirus && sudo apt install papirus-icon-theme
