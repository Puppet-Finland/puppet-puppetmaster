#!/bin/bash

# Exit on any error including pipes
set -e
set -o pipefail

# Preparations required prior to "puppet apply".

usage() {
    echo
    echo "Usage: prepare.sh -n module_name -f -b basedir"
    echo
    echo "Options:"
    echo " -n   Name of the module that includes this script. Used to copy"
    echo "      the module code to the modulepath."
    echo " -b   Base directory for dependency Puppet modules installed by"
    echo "      librarian-puppet."
    exit 1
}

# Parse the options

# We are run without parameters -> usage
if [ "$1" == "" ]; then
    usage
fi

while getopts "n:f:o:b:h" options; do
    case $options in
        n ) THIS_MODULE=$OPTARG;;
        f ) OSFAMILY=$OPTARG;;
        o ) OS=$OPTARG;;
        b ) BASEDIR=$OPTARG;;
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
	if [[ $RELEASE =~ 7\.[0-9]+ ]]; then
	    RHEL_VERSION="7"
        else
	    echo "Unsupported Redhat/Centos version. Supported versions are 7.x"
	    exit 1	    
	fi
    elif [[ $(lsb_release -d | awk '{ print $2}') =~ ^(Ubuntu|Debian)$ ]]; then
	OSFAMILY='debian'
	DESCR="$(lsb_release -d | awk '{ print $2}')"
	if [ $DESCR =~ Ubuntu ]; then
            UBUNTU_VERSION="$(lsb_release -c | awk '{ print $2}')"
	elif [ $DESCR =~ Debian ]; then
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
	    RELEASE_URL="https://yum.puppetlabs.com/puppet5/puppet-release-el-${RHEL_VERSION}.noarch.rpm"
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

run_puppet_1() {

PROF_FILE='/etc/profile.d/puppeteers.sh'
FILE=$(mktemp)
cat<<EOF>$FILE
file { "$PROF_FILE":
  ensure  => present,
  content => 'export PATH=/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:$PATH',
}

package { 'librarian-puppet':
  ensure   => latest,
  provider => 'puppet_gem',
}

file { "$BASEDIR":
  ensure => directory,
}

file { "${BASEDIR}/modules":
  ensure  => directory,
  require => File["$BASEDIR"],
}

file { 'Puppetfile absent':
  path   => "${BASEDIR}/Puppetfile",
  ensure => absent,
}

package { 'git':
  ensure => 'latest',
}

file { "${THIS_MODULE} absent":
  path    => "${BASEDIR}/modules/${THIS_MODULE}",
  ensure  => absent,
  require => File["${BASEDIR}/modules"],
}
EOF
cat $FILE | /opt/puppetlabs/bin/puppet apply 
rm $FILE
}

run_puppet_2() {
FILE=$(mktemp)
cat<<EOF>$FILE
file { 'Puppetfile link':
  path    => "${BASEDIR}/Puppetfile",
  ensure  => link,
  target  => '/vagrant/vagrant/Puppetfile',
}

file { "${THIS_MODULE} present":
  path    => "${BASEDIR}/modules/${THIS_MODULE}",
  ensure  => link,
  target  => "/vagrant/modules/${THIS_MODULE}",
}
exec { 'Run librarian-puppet':
  cwd     => "$BASEDIR",
  command => 'librarian-puppet install',
  path    => '/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/usr/bin'
}
EOF
cat $FILE | /opt/puppetlabs/bin/puppet apply 
rm $FILE
}

# Main program
detect_osfamily
setup_puppet
# We run these separately due to duplicate path management
run_puppet_1
run_puppet_2

cd $CWD
