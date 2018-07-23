# puppet-puppetmaster

This is a Puppet module and [Kafo](https://github.com/theforeman/kafo) installer for setting up:

* Puppetserver
* Puppetserver with PuppetDB
* Puppetserver with PuppetDB and [Puppetboard](https://github.com/voxpupuli/puppetboard)
* Puppetserver with [Foreman Smart Proxy](https://github.com/theforeman/smart-proxy)
* Puppetserver with [Foreman Smart Proxy](https://github.com/theforeman/smart-proxy) and [Foreman](https://github.com/theforeman/foreman)

Each of the above is a separate Kafo installer scenario.

# Setup

To run the installer you need to do some setup steps. 

* Install Puppet 5 from Puppetlabs
* Install git, kafo and librarian-puppet
* Run librarian-puppet to fetch dependency modules

For now you can check what Vagrant does in its bootstrapping script, [prepare.sh](vagrant/prepare.sh).

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
