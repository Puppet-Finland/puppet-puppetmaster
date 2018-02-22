#
# == Class: puppetmaster::foreman
#
# Install and configures Foreman
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Examples
#
#  include puppetdb::base
#
# === Authors
#
# Petri Lammi <petri.lammi@tietoteema.fi>
#
# === Copyright
#
# Copyright 2018 Petri Lammi
#
class puppetmaster::foreman
{
  # database
  $foreman_db_manage = false,
  $foreman_db_type = hiera(profile::foreman::db_type,'postgresql')
  $foreman_db_host = hiera(profile::foreman::db_host, '127.0.0.1') 
  $foreman_db_database = hiera(profile::foreman::db_database, 'foreman')
  $foreman_db_username = hiera(profile::foreman::db_username, 'foreman')    
  $foreman_db_password = hiera(profile::foreman::db_password, 'changeme')
  $foreman_connection_limit = hiera(profile::foreman::connection_limit, '-1')
  
  $foreman_authentication = hiera(profile::foreman::authentication, true)
  $foreman_servername = hiera(profile::foreman::servername, 'puppet.tietoteema.vm')
  # $serveraliases = hiera(profile::foreman::serveraliases, '')
  $foreman_admin_first_name = hiera(profile::foreman::admin_first_name, 'Joakim')
  $foreman_admin_last_name = hiera(profile::foreman::admin_last_name, 'Hirvi')
  $foreman_admin_email = hiera(profile::foreman::admin_email, 'hostmaster@tietoteema.fi')
  $foreman_organizations_enabled = hiera(profile::foreman::organizations_enabled, false) 
  $foreman_initial_organization = hiera(profile::foreman::initial_organization, 'tietoteema.com')
  $lforeman_ocations_enabled = hiera(profile::foreman::locations_enabled, false) 
  $initial_location = hiera(profile::foreman::initial_location, 'Virtualbox')
  $foreman_admin_username = hiera(profile::foreman::admin_username, 'admin')
  $foreman_admin_password = hiera(profile::foreman::admin_password, 'changeme')
  $foreman_puppetdb_dashboard_address = hiera(profile::foreman::puppetdb_dashboard_address,'http://puppet.tietoteema.vm:8080/pdb/dashboard')
  $foreman_puppetdb_address = hiera(profile::foreman::puppetdb_address,'https://puppet.tietoteema.vm:8081/v2/commands')
  $foreman_foreman_url = hiera(profile::foreman::foreman_url,'https://puppet.tietoteema.vm')
  $foreman_repo = hiera(profile::foreman::repo,'1.15')
  $foreman_version = hiera(profile::foreman::version,'1.15.6')
  $foreman_manage_memcached = hiera(profile::foreman::manage_memcached, true)
  $foreman_memcached_max_memory = hiera(profile::foreman::memcached_max_memory, '8%')
  $foreman_configure_epel_repo = hiera(profile::foreman::configure_epel_repo, false)
  $foreman_configure_scl_repo = hiera(profile::foreman::configure_scl_repo, true)
  $foreman_oauth_consumer_key = hiera(profile::foreman::oauth_consumer_key, 'xEL7pzhskio8AHqWhMWCwskzvWNgvQRB')
  $foreman_oauth_consumer_secret = hiera(profile::foreman::oauth_consumer_secret, '2F5iKu5VzuRzVYRaYFQiNcPghihYn7dP')      
  $foreman_selinux = hiera(profile::foreman::selinux, false)
  $foreman_unattended = hiera(profile::foreman::unattended, true)
  $foreman_foreman_plugin_cockpit = lookup(profile::foreman::plugin_cockpit, Boolean, 'first', true)

  if versioncmp($version, '1.16') <= 0 {
    $dynflow_in_core = false
  }
  else {
    $dynflow_in_core = true
  }
      
  firewall { '443 accept incpming foreman template and UI':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => ['80','443'],
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '8443 accept incoming foreman proxy':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => '8443',
    proto  => 'tcp',
    action => 'accept',
  }                     
  
  firewall { '8140 allow incoming puppet':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '8443 allow outgoing traffic to smart proxies':
    chain       => 'OUTPUT',
    state       => ['NEW'],
    dport       => '8443',
    proto       => 'tcp',
    action      => 'accept',
  }

  if !$foreman_db_manage {
  
    ::postgresql::server::role { $foreman_db_username:
      password_hash => postgresql_password($foreman_db_username, $foreman_db_password),
      connection_limit => $foreman_db_connection_limit,
    }
    
    ::postgresql::server::database_grant { "Grant all to $foreman_db_username":
      privilege => 'ALL',
      db        => $foreman_db_database,
      role      => $foreman_db_username,
    }
  
    ::postgresql::server::db { $foreman_db_database:
      user     => $foreman_db_username,
      password => postgresql_password($foreman_db_username, $foreman_db_password),
    }

  }
    
  if ($foreman_manage_memcached) {
    class { 'memcached':
      max_memory => "$foreman_memcached_max_memory",
    }
  }

  package { 'tfm-rubygem-foreman_azure':
    ensure => present,
    require => Class['::foreman'],
  }

  cron { 'Collect trend data':
    environment => 'PATH=/opt/puppetlabs/bin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin', 
    command     => '/sbin/foreman-rake foreman-rake trends:counter',
    user        => 'root',
    hour        => 0,
    minute      => 0/30,
  }
  
  cron { 'Expire Foreman reports':
    environment => 'PATH=/opt/puppetlabs/bin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin', 
    command     => '/sbin/foreman-rake reports:expire days=30',
    user        => 'root',
    hour        => 2,
    minute      => 0,
    require     => Class['::foreman'],
  }

  cron { 'Expire Foreman not useful=ok reports':
    environment => 'PATH=/opt/puppetlabs/bin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin', 
    command     => '/sbin/foreman-rake reports:expire days=10 status=0',
    user        => 'root',
    hour        => 2,
    minute      => 0,
    require     => Class['::foreman'],
  }
  
  file { '/etc/foreman/plugins/foreman_default_hostgroup.yaml':
    source       => $::fqdn ? {
      /^.*\.vm$/ => "/opt/local/server/files/foreman_default_hostgroup.yaml",
      default    => "/opt/local/server/files/foreman_default_hostgroup.yaml",
    },
  require        => Class['::foreman::plugin::default_hostgroup'],
  }
  
  class { '::foreman':
    foreman_url           => $foreman_foreman_url, 
    db_manage             => $foreman_db_manage,
    db_username           => $foreman_db_username,
    db_password           => $foreman_db_password,
    db_type               => $foreman_db_type,
    db_host               => $foreman_db_host,
    db_database           => $foreman_db_database,
    authentication        => $foreman_authentication,
    admin_username        => $foreman_admin_username,
    admin_password        => $foreman_admin_password,
    servername            => $foreman_servername,
    # $serveraliases      => $serveraliases,
    admin_first_name      => $foreman_admin_first_name,
    admin_last_name       => $foreman_admin_last_name,
    admin_email           => $foreman_admin_email, 
    organizations_enabled => $foreman_organizations_enabled,
    initial_organization  => $foreman_initial_organization,
    repo                  => $foreman_repo,
    version               => $foreman_version,
    configure_epel_repo   => $foreman_configure_epel_repo,
    configure_scl_repo    => $foreman_configure_scl_repo,
    oauth_consumer_key    => $foreman_oauth_consumer_key,
    oauth_consumer_secret => $foreman_oauth_consumer_secret,
    locations_enabled     => $foreman_locations_enabled,
    initial_location      => $foreman_initial_location,
    selinux               => $foreman_selinux,
    unattended            => $foreman_unattended,
    dynflow_in_core       => $foreman_dynflow_in_core,
  }

  include ::foreman::compute::vmware
  include ::foreman::compute::libvirt
  include ::foreman::compute::ec2
  include ::foreman::compute::gce
  include ::foreman::compute::openstack
  include ::foreman::compute::ovirt
  include ::foreman::compute::rackspace
  include ::foreman::plugin::ansible
  include ::foreman::plugin::docker
  include ::foreman::plugin::bootdisk
  include ::foreman::plugin::default_hostgroup
  include ::foreman::plugin::dhcp_browser
  include ::foreman::plugin::digitalocean
  include ::foreman::plugin::discovery
  include ::foreman::plugin::hooks
  include ::foreman::plugin::memcache
  include ::foreman::plugin::remote_execution
  include ::foreman::plugin::tasks
  include ::foreman::plugin::templates


  if $foreman_plugin_cockpit {
    include ::foreman::plugin::cockpit
  }

  class { '::foreman::plugin::puppetdb':
    dashboard_address     => $foreman_puppetdb_dashboard_address,
    address               => $foreman_puppetdb_address,
  }

  class { '::foreman::cli':
    foreman_url           => $foreman_foreman_url,
    username              => 'admin',
    password              => $foreman_admin_password,
    manage_root_config    => true,
  }

  package { 'ansible':
    ensure                => installed,
    require               => Class['::foreman::plugin::ansible'],
  }

}
