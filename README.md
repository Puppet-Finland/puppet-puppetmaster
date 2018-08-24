# puppet-puppetmaster

This is a Puppet module and [Kafo](https://github.com/theforeman/kafo) installer for setting up:

* Puppetserver
* Puppetserver with PuppetDB
* Puppetserver with PuppetDB and [Puppetboard](https://github.com/voxpupuli/puppetboard)
* Puppetserver with [Foreman Smart Proxy](https://github.com/theforeman/smart-proxy)
* Puppetserver with [Foreman Smart Proxy](https://github.com/theforeman/smart-proxy) and [Foreman](https://github.com/theforeman/foreman)

Each of the above is a separate Kafo installer scenario.

# Setup from git

To run the installer you need to do some setup steps. 

* Install Puppet 5 from Puppetlabs
* Install git and rubygems from system packages (apt / yum)
* Install gems using /opt/puppetlabs/puppet/bin/gem
    * ```$ /opt/puppetlabs/puppet/bin/gem install yard puppet-strings kafo rdoc librarian-puppet```
* Run librarian-puppet to fetch dependency modules

# Setup from packages

Package install creates a directory - /usr/share/puppetmaster-installer

Installing from package does not require git or librarian package installs

# Creating deb/rpm packages

    $ vagrant up packager
    $ vagrant ssh packager
    $ cd puppetmaster-installer/packaging
    $ ./package.sh

# Usage

To run the installer:

    $ sudo -i
    $ bin/puppetmaster-installer -i --skip-puppet-version-check

The "-i" switch to ensures that the environment is root's environment, which is particularly important on Ubuntu and Debian.

# Supported platforms

This module supports CentOS 7, Debian 9 and Ubuntu 16.04.

Puppetserver, PuppetDB and Puppetboard scenarios work across all supported platforms. Currently Foreman scenarios
only work on CentOS 7.

Ubuntu 18.04 can't be easily supported quite yet as Puppetlabs does not provide Puppet 5 packages for it. Additionally Ubuntu's official Vagrant box [does not have](https://github.com/cilium/cilium/issues/1918#issuecomment-344527888) the ifupdown package which Vagrant depends on.

# Development

Kafo installers have a nasty habit of modifying answer files which are versioned 
by Git. To prevent these local answer file modifications from getting committed 
by accident you can use a command like this:

    $ find config -name "*-answers.yaml"|xargs git update-index --assume-unchanged

# LICENSE

This project uses the two-clause BSD license. See [LICENSE](LICENSE) for details.
