#!/bin/bash

source /opt/bin/color.sh

function e() {
    printf "${Red}${G_XMark}"
    printf "\t$*\n"
    printf "${Color_Off}"
}

function i() {
    printf "${Color_Off}"
    printf "$*\n"
    printf "${Color_Off}"
}

#
# output ok message to indicate more readable
#
function ok() {
    printf "${Green}${G_OKMark}"
    printf "\t$*\n"
    printf "${Color_Off}"
}
