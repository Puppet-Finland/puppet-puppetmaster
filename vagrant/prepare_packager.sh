#!/bin/sh
#
# prepare_packager.sh
#
# Ensure that FPM and its dependencies are present
#
apt-get update
apt-get -y install ruby-dev build-essential rpm
gem install r10k fpm
