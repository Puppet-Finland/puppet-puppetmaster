#!/usr/bin/env ruby
#^syntax detection

forge 'https://forgeapi.puppetlabs.com'

mod 'puppetfinland-packetfilter'

mod 'puppetfinland-kafo',
    :git => 'https://github.com/Puppet-Finland/puppet-kafo.git',
    :tag => '1.0.2'

mod 'puppetlabs-stdlib'

# Modules used in profiles
mod 'puppetlabs-ntp', '>= 7.1.1'
mod 'chrekh-hosts', '>= 2.3.0'
mod 'saz-timezone', '>= 4.1.1'
mod 'puppetlabs-puppet_authorization', '>= 0.4.0'
mod 'stahnma-epel', '>= 1.3.0'
mod 'ghoneycutt-dnsclient', '>= 3.5.2'
mod 'saz-locales', '>= 2.5.0'
mod 'puppetlabs-puppetserver_gem', '>= 1.0.0'
mod 'puppetlabs-vcsrepo', '1.5.0'
mod 'puppetlabs-firewall', '>= 1.12.0'
mod 'saz-memcached', '>= 3.1.0'
mod 'puppet-selinux', '>=1.5.2'
mod 'puppetlabs-reboot', '>=2.0.0'
mod 'puppet-puppetboard', '>=4.0.0'
mod 'stankevich-python',
    :git => 'https://github.com/Puppet-Finland/puppet-python.git',
    :ref => 'dedbc1cfa115314ec8ccb9a04629a4a6781f71d7'

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
