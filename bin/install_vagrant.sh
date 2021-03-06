#!/bin/bash

OS=$(uname -s)
VAGRANT_VERSION="1.6.3"

if [[ "${OS}" == *Linux* ]]
then
    if [ -z "$( which virtualbox )" ]
    then
        if [ ! -f /etc/apt/sources.list.d/debfx-virtualbox-*.list ]; then
            sudo add-apt-repository ppa:debfx/virtualbox
            sudo apt-get update
        fi

        sudo apt-get --yes install virtualbox-ose virtualbox-guest-additions
    fi
elif [[ "${OS}" == *Darwin* ]]
then
    if [[ -z "$( which VirtualBox )" ]]
    then
        curl -SLo VirtualBox.dmg http://download.virtualbox.org/virtualbox/4.3.8/VirtualBox-4.3.8-92456-OSX.dmg 2>&1
        hdiutil attach VirtualBox.dmg
        sudo /Volumes/VirtualBox/VirtualBox_Uninstall.tool
        sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /
        hdiutil detach /Volumes/VirtualBox
        rm VirtualBox.dmg
    fi
fi

echo -e "Virtualbox is present"

function install_vagrant {
   if [[ "${OS}" == *Linux* ]]
    then
        wget https://dl.bintray.com/mitchellh/vagrant/vagrant_${VAGRANT_VERSION}_x86_64.deb -O vagrant.deb 2>&1
        sudo dpkg -i vagrant.deb
        rm vagrant.deb
    elif [[ "${OS}" == *Darwin* ]]
    then
        curl -SLo Vagrant.dmg https://dl.bintray.com/mitchellh/vagrant/vagrant_${VAGRANT_VERSION}.dmg 2>&1
        hdiutil attach Vagrant.dmg
        sudo /Volumes/Vagrant/uninstall.tool
        sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /
        hdiutil detach /Volumes/Vagrant
        rm Vagrant.dmg
    fi
}

if [ -z "$( which vagrant )" ]
then
    install_vagrant
else
    CURRENT_VERSION=$(vagrant -v)
    if [ "${CURRENT_VERSION}" == "Vagrant ${VAGRANT_VERSION}" ]
    then
        echo ${CURRENT_VERSION}
    else
        echo -e "Vagrant exists but we'll update it ...\n"
        install_vagrant
    fi
fi

DEFAULT_BOX_NAME="precise_base"
if [ -z "$( vagrant box list | grep ${DEFAULT_BOX_NAME} )" ]; then
    read -p "You don't have the base Ubuntu Precise (64 bit) box, do you want to add it? [y/N] " -e answer

    if [ "${answer}" = "y" ]; then
        # http://www.vagrantbox.es/
        vagrant box add ${DEFAULT_BOX_NAME} http://files.vagrantup.com/precise64.box 2>&1
    fi
fi