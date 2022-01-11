#!/usr/bin/env bash

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source $SCRIPT_DIR/bash-logging.sh

INSTALL_SCRIPT=install-ansible.sh

test_os() {
    if docker run -v $SCRIPT_DIR/$INSTALL_SCRIPT:/$INSTALL_SCRIPT --entrypoint /$INSTALL_SCRIPT $1 &> /dev/null
    then
        success "Successfully installed ansible on $1"
    else
        error "Failed to install ansible on $1"
    fi
}

for os in ubuntu debian fedora centos
do
    echo "Trying to install ansible on $os..."
    test_os $os
done