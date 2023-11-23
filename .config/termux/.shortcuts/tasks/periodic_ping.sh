#!/data/data/com.termux/files/usr/bin/bash
######################################################################
# Author:   RenegadeMaster
# Created:  2021-05-01
# Updated:  2021-05-01
# Description:
#   Periodically pings CloudFlare server [1.1.1.1] to keep connection
#   alive.
######################################################################

function start-ping() {
    while true; do
        ping -c 1 $target
        sleep $waitTime
    done
}


function set-variables() {
    target="1.1.1.1"
    waitTime=120
}


## Main
set-variables
start-ping

