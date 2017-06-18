#!/bin/bash

# author: Sebastiaan Van Hoecke

runAsRoot () {

    if [[ $UID != 0 ]]; then
        echo "run as root"
        exit 0
    fi

}

packages () {

    # desktop
    pacman -S --noconfirm i3lock dmenu compton conky lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings feh imagemagick 
    # xorg
    pacman -S --noconfirm xf86-input-libinput
    # terminal
    pacman -S --noconfirm vim zsh tmux termite
    # programming
    pacman -S --noconfirm docker npm python ansible vagrant php git nodejs ruby shellcheck js jdk8-openjdk autoconf automake pkg-config m4 make
    # python adds
    pacman -S --noconfirm python-keyring python-requests python-pip
    # apps
    pacman -S --noconfirm tlp gtk3 evince geary w3m mpv htop youtube-dl mlocate scrot shotwell transmission-gtk ack wget curl lm_sensors gparted pcmanfm screenfetch hardinfo lsb-release galculator dconf-editor dconf dmidecode filezilla tree rofi ranger highlight atool mediainfo
    # network
    pacman -S --noconfirm networkmanager network-manager-applet nmap wireshark-gtk firewalld iftop
    # AUR managers
    pacman -S --noconfirm yaourt
    # gstreamer
    pacman -S --noconfirm gstreamer gst-plugins-base gst-plugins-bad gst-plugins-good gst-plugins-ugly
    # compression
    pacman -S --noconfirm zip unzip unrar unace 
    # other
    pacman -S --noconfirm dkms exfat-utils synaptics mtools libisoburn bind-tools sysstat ntp udisks2 udiskie
    # fonts, themes & icons
    pacman -S --noconfirm shadow arc-icon-theme arc-solid-gtk-theme

    pacman -S --noconfirm watchdog

}

git () {

    git config --global user.name "sevaho"
    git config --global user.email "sebastiaan.vanhoecke@hotmail.be"

}

aurPackages () {

    packer -S i3blocks packer vivaldi font-manager foxitreader i3-gaps

}

systemdSettings () {

    systemctl enable lightdm
    systemctl enable firewalld
    systemctl enable docker
    systemctl enable NetworkManager
    systemctl enable ntpd
    systemctl enable watchdog
    systemctl enable tlp.service
    systemctl enable tlp-sleep.service

}

main () {

    runAsRoot
    pacman -Syu
    packages
    aurPackages
    git
    systemdSettings
  
}

main "${@}"

