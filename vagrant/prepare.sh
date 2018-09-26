#!/bin/sh

# Exit on any error
set -e

usage() {
    echo
    echo "Usage: prepare.sh -b basedir [-m]"
    echo
    echo "Options:"
    echo " -b   Base directory for dependency Puppet modules installed by"
    echo "      librarian-puppet."
    echo " -m   Install Puppet modules required by Kafo with librarian-puppet"
    exit 1
}

# Parse the options

# We are run without parameters -> usage
if [ "$1" = "" ]; then
    usage
fi

# Default values
INSTALL_MODULES=false

while getopts "b:mh" options; do
    case $options in
        b ) BASEDIR=$OPTARG;;
        m ) INSTALL_MODULES=true;;
        h ) usage;;
        \? ) usage;;
        * ) usage;;
    esac
done

CWD=`pwd`

detect_osfamily() {
    if [ -f /etc/redhat-release ]; then
        OSFAMILY='redhat'
        RELEASE=$(cat /etc/redhat-release)
	if [ "`echo $RELEASE | grep -E 7\.[0-9]+`" ]; then
            RHEL_VERSION="7"
        else
            echo "Unsupported Redhat/Centos version. Supported versions are 7.x"
            exit 1
        fi
    elif [ "`lsb_release -d | grep -E '(Ubuntu|Debian)'`" ]; then
        OSFAMILY='debian'
        DESCR="$(lsb_release -d | awk '{ print $2}')"
        if [ `echo $DESCR|grep Ubuntu` ]; then
            UBUNTU_VERSION="$(lsb_release -c | awk '{ print $2}')"
        elif [ `echo $DESCR|grep Debian` ]; then
            DEBIAN_VERSION="$(lsb_release -c | awk '{ print $2}')"
        else
            echo "Unsupported Debian family operating system. Supported are Debian and Ubuntu"
            exit 1
        fi
    else
        echo "ERROR: unsupported osfamily. Supported are Debian and RedHat"
        exit 1
    fi
}

setup_puppet() {
    if [ -x /opt/puppetlabs/bin/puppet ]; then
        true
    else
        if [ $RHEL_VERSION ]; then
            RELEASE_URL="https://yum.puppetlabs.com/puppet5/puppet5-release-el-${RHEL_VERSION}.noarch.rpm"
            rpm -hiv "${RELEASE_URL}" || (c=$?; echo "Failed to install ${RELEASE_URL}"; (exit $c))
            yum -y install puppet-agent || (c=$?; echo "Failed to install puppet agent"; (exit $c))
            if systemctl list-unit-files --type=service | grep firewalld; then
                systemctl stop firewalld
                systemctl disable firewalld
                systemctl mask firewalld
            fi
        else
            if [ $UBUNTU_VERSION ]; then
                APT_URL="https://apt.puppetlabs.com/puppet5-release-${UBUNTU_VERSION}.deb"
            fi
            if [ $DEBIAN_VERSION ]; then
                APT_URL="https://apt.puppetlabs.com/puppet5-release-${DEBIAN_VERSION}.deb"
            fi
            # https://serverfault.com/questions/500764/dpkg-reconfigure-unable-to-re-open-stdin-no-file-or-directory
            export DEBIAN_FRONTEND=noninteractive
            FILE="$(mktemp -d)/puppet-release.db"
            wget "${APT_URL}" -qO $FILE || (c=$?; echo "Failed to retrieve ${APT_URL}"; (exit $c))
            dpkg --install $FILE; rm $FILE; apt-get update || (c=$?; echo "Failed to install from ${FILE}"; (exit $c))
            apt-get -y install puppet-agent || (c=$?; echo "Failed to install puppet agent"; (exit $c))
        fi
    fi
}

### Main program

# Install and configure puppet
detect_osfamily
setup_puppet

# Configure with "puppet apply"
PUPPET_APPLY="/opt/puppetlabs/bin/puppet apply --modulepath=$BASEDIR/modules"

# Pass variables from this script to Puppet manifests via environment variables
export FACTER_profile='/etc/profile.d/puppeteers.sh'
export FACTER_basedir="$BASEDIR"

$PUPPET_APPLY $BASEDIR/vagrant/profile.pp

if [ "$INSTALL_MODULES" = "true" ]; then
    $PUPPET_APPLY $BASEDIR/vagrant/git.pp
    $PUPPET_APPLY $BASEDIR/vagrant/librarian.pp
fi

$PUPPET_APPLY $BASEDIR/vagrant/kafo.pp

cd $CWD
