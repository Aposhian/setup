#!/usr/bin/env bash

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

RED="\e[31m"
BLUE="\e[34m"
GREEN="\e[32m"
YELLOW="\e[33m"
ENDCOLOR="\e[0m"

success() {
    echo -e "$GREEN$1$ENDCOLOR"
}
error() {
    echo -e "$RED$1$ENDCOLOR" >&2
}
warn() {
    echo -e "$YELLOW$1$ENDCOLOR" >&2
}
info() {
    echo -e "$BLUE$1$ENDCOLOR"
}

if [ $(id -u) != 0 ]
then
    echo "This script must be run with root privileges"
    exit 1
fi

# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html
if [ -e /usr/bin/apt-get ]
then
    info "apt-get detected"
    apt-get update && apt-get install -yq lsb-release
    if lsb_release -a | grep -i ubuntu
    then
        info "Ubuntu detected"
        apt-get install -y software-properties-common ||
            apt-get install -y python-software-properties
        add-apt-repository --yes ppa:ansible/ansible
        apt-get update
        apt-get install -yq ansible
    else
        info "Debian detected"
        declare -A debian_to_ubuntu=( ["8"]="trusty" ["9"]="xenial" ["10"]="bionic" ["11"]="focal")
        DEBIAN_RELEASE="$(lsb_release -a | grep -i release | awk '{ print $2 }')"
        UBUNTU_CODENAME=${debian_to_ubuntu[$DEBIAN_RELEASE]}
        echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $UBUNTU_CODENAME main" > /etc/apt/sources.list.d/ansible.list
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
        apt-get update
        apt-get install -yq ansible
    fi
elif [ -e /usr/bin/dnf ]
then
    info "dnf detected"
    dnf -y install ansible
elif [ -e /usr/bin/yum ]
then
    info "yum detected"
    if [ -e /etc/redhat-release ]
    then
        info "Red Hat Enterprise Linux detected"
    elif [ -e /etc/centos-release ]
    then
        info "CentOS detected"
        yum install -y epel-release
    fi
    yum -y install ansible
fi

if ansible-playbook --version &> /dev/null
then
    success "ansible installed"
else
    error "ansible failed to install"
    exit 1
fi
