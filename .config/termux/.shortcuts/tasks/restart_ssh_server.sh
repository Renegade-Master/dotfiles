#!/data/data/com.termux/files/usr/bin/bash
######################################################################
# Author:   RenegadeMaster
# Created:     2021-04-06
# Updated:  2020-04-06
# Description:
#   Script to stop and start the local SSH server (SSHD).
######################################################################

function start_ssh_server() {
    sshd
}


function stop_ssh_server() {
    pkill sshd
}


stop_ssh_server
start_ssh_server

