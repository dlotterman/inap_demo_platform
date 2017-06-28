#!/bin/bash

set -e

/usr/bin/apt-get update

/usr/bin/apt-get -y upgrade

/usr/bin/apt-get -y install ansible git vim apt-file libcurl4-gnutls-dev libgnutls28-dev

/usr/bin/easy_install pip

/usr/local/bin/pip install python-openstackclient

/usr/local/bin/pip install shade

/usr/local/bin/pip install pycurl

mkdir ~/ansible

cd ~/ansible

/usr/bin/git clone git://github.com/internap/openstack-ansible-workloads
