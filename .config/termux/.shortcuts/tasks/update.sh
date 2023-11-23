#!/data/data/com.termux/files/usr/bin/zsh
######################################################################
# Author:   RenegadeMaster
# Created:  2021-04-06
# Updated:  2020-04-06
# Description:
#   Script to Update the Environment.
######################################################################

function update_oh_my_zsh() {
    printf '\n--- Updating Oh-My-Zsh ---\n'
    source $HOME/.zshrc
    omz update
}


function autoremove_packages() {
    printf '\n--- Cleaning Up ---\n'
    apt autoremove -y
}


function upgrade_packages() {
    printf '\n--- Upgrading Packages ---\n'
    apt full-upgrade -y
}


function update_packages() {
    printf '\n--- Updating Packages ---\n'
    apt update
}


update_packages
upgrade_packages
autoremove_packages
update_oh_my_zsh

