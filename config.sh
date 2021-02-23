#!/bin/sh

# Map F9 to dead_greek
echo "xmodmap -e 'keycode 75 = dead_greek dead_greek dead_greek dead_greek'" >> ~/.bashrc

sudo apt-add-repository ppa:papirus/papirus && sudo apt install papirus-icon-theme
