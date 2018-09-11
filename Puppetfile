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
mod 'saz-timezone', '5.0.2'
mod 'puppetlabs-puppet_authorization', '>= 0.4.0'
mod 'stahnma-epel', '>= 1.3.0'
mod 'ghoneycutt-dnsclient',
    :git => 'https://github.com/ghoneycutt/puppet-module-dnsclient.git',
    :ref => 'ee9c47b44d185db70ffc8f4fdefdcaaf7e923d12'
mod 'saz-locales', '>= 2.5.1'
mod 'puppetlabs-puppetserver_gem',
    :git => 'https://github.com/Puppet-Finland/puppetlabs-puppetserver_gem.git',
    :ref => 'c03720943996eb1269ee914c2dc24686ca37848d'
mod 'puppetlabs-vcsrepo', '2.3.0'
mod 'puppetlabs-firewall', '>= 1.12.0'
mod 'saz-memcached', '3.3.0'
mod 'puppet-selinux', '>=1.5.2'
mod 'puppetlabs-reboot', '>=2.0.0'
mod 'puppet-puppetboard',
    :git => 'https://github.com/voxpupuli/puppet-module-puppetboard.git',
    :ref => '7bff39638e1078d0b520e2222f068938fe8d9ed6'
mod 'puppet-python',
    :git => 'https://github.com/voxpupuli/puppet-python',
    :ref => '2f16648a91b6c7942b34950a88d7d5a6b386c9b6'

# Dependencies that would be fetched automatically, but need to be pinned down 
# to a specific version
mod 'puppetlabs-ruby',
    :git => 'https://github.com/Puppet-Finland/puppetlabs-ruby.git',
    :ref => 'ac7aae51ae3e49b9d9e2c19397fa964d6aaf505a'
mod 'puppet-make', '2.1.0'
mod 'puppetlabs-gcc',
    :git => 'https://github.com/Puppet-Finland/puppetlabs-gcc.git',
    :ref => '9df39a91300be42ff583438996ed26b379131eca'

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
