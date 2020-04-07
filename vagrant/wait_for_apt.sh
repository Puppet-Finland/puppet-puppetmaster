#!/bin/sh
#
# Wait until apt and dpkg have finished. A subset of
#
# <https://github.com/Puppet-Finland/scripts/blob/master/bootstrap/linux/install-puppet.sh>

# Exit on any error
set -e


# The apt-daily and apt-daily-upgrade services have a nasty habit of
# launching immediately on boot. This prevents the installer from updating
# the package caches itself, which causes some packages to be missing and
# subsequently causing puppetmaster-installer to fail. So, wait for those
# two services to run before attempting to run the installer. There are
# ways to use systemd-run to accomplish this rather nicely:
#
# https://unix.stackexchange.com/questions/315502/how-to-disable-apt-daily-service-on-ubuntu-cloud-vm-image
#
# However, that approach fails on Ubuntu 16.04 (and earlier) as well as
# Debian 9, so it is not practical. This approach uses a simple polling
# method and built-in tools.
APT_READY=no
while [ "$APT_READY" = "no" ]; do
    # This checks three things to prevent package installation failures, in this order:
    #
    # 1) Is "apt-get update" running?
    # 2) Is "apt-get install" running?
    # 3) Is "dpkg" running?
    #
    # The "apt-get install" commands locks dpkg as well, but the last check ensures that dpkg running outside of apt does not cause havoc.
    #
    fuser -s /var/lib/apt/lists/lock || fuser -s /var/cache/apt/archives/lock || fuser -s /var/lib/dpkg/lock || APT_READY=yes
    sleep 1
done
