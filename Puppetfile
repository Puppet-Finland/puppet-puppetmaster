#!/usr/bin/env ruby
#^syntax detection

forge 'https://forgeapi.puppetlabs.com'

mod 'puppetfinland-kafo',
    :git => 'https://github.com/Puppet-Finland/puppet-kafo.git',
    :tag => '1.0.2'

mod 'puppetlabs-stdlib'

# This is a workaround. At the momen  this is a forked version, with only change being including the puppet-inifile v. 2.2.0 in metadata.json, to prevent clashes.
mod 'puppet-hiera',
    :git => 'https://github.com/kibahop/puppet-hiera.git',
    :branch => 'master'

# Modules used in profiles
mod 'puppet-r10k', '>= 6.3.2'
mod 'puppetlabs-ntp', '>= 7.1.1'
mod 'chrekh-hosts', '>= 2.3.1'
mod 'saz-timezone', '>= 4.1.1'
mod 'puppetlabs-puppet_authorization', '>= 0.4.0'
mod 'stahnma-epel', '>= 1.3.0'
mod 'ghoneycutt-dnsclient', '>= 3.5.2'
mod 'saz-locales', '>= 2.5.0'
mod 'puppetlabs-puppetserver_gem', '>= 1.0.0'
mod 'puppetlabs-vcsrepo', '>= 2.3.0'
mod 'puppetlabs-firewall', '>= 1.12.0'
mod 'saz-memcached', '>= 3.1.0'

# Foreman deps
mod 'puppetlabs/mysql',         '>= 4.0.0'
mod 'puppetlabs/postgresql',    '>= 4.8.0'
mod 'puppetlabs/puppetdb'
mod 'theforeman/dhcp',          :git => 'https://github.com/theforeman/puppet-dhcp'
mod 'theforeman/dns',           :git => 'https://github.com/theforeman/puppet-dns'
mod 'theforeman/git',           :git => 'https://github.com/theforeman/puppet-git'
mod 'theforeman/tftp',          :git => 'https://github.com/theforeman/puppet-tftp'

# Foreman top-level modules
mod 'theforeman/foreman',       :git => 'https://github.com/theforeman/puppet-foreman'
mod 'theforeman/foreman_proxy', :git => 'https://github.com/theforeman/puppet-foreman_proxy'
mod 'theforeman/puppet',        :git => 'https://github.com/theforeman/puppet-puppet'
