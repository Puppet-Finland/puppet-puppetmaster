class puppetmaster::foreman
(
  $foreman_db_manage,
  $foreman_db_type,
  $foreman_db_host,
  $foreman_db_database,
  $foreman_db_username,
  $foreman_db_password,
  $foreman_connection_limit,
  $foreman_authentication,
  $foreman_servername,
  $foreman_serveraliases,
  $foreman_admin_first_name,
  $foreman_admin_last_name,
  $foreman_admin_email,
  $foreman_organizations_enabled,
  $foreman_initial_organization,
  $foreman_locations_enabled,
  $foreman_initial_location,
  $foreman_admin_username,
  $foreman_admin_password,
  $foreman_puppetdb_dashboard_address,
  $foreman_puppetdb_address,
  $foreman_foreman_url,
  $foreman_repo,
  $foreman_version,
  $foreman_manage_memcached,
  $foreman_memcached_max_memory,
  $foreman_configure_epel_repo,
  $foreman_configure_scl_repo,
  $foreman_oauth_consumer_key,
  $foreman_oauth_consumer_secret,
  $foreman_selinux,
  $foreman_unattended,
  $foreman_foreman_plugin_cockpit,
)
{
  # See https://github.com/theforeman/puppet-foreman#foreman-version-compatibility-notes
  if versioncmp($foreman_version, '1.16') <= 0 {
    $dynflow_in_core = false
  }
  else {
    $dynflow_in_core = true
  }
  
  firewall { '443 accept incoming foreman template and UI':
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

  if ! $foreman_db_manage {
  
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

  #  # Is this still needed?
  #  package { 'tfm-rubygem-foreman_azure':
    #    ensure => present,
    #    require => Class['::foreman'],
    #  }
  
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
  
  $default_hostgroup_template = @(END)
  ---
  :default_hostgroup:
    :facts_map:
      "default_linux_group":
        "kernel": "Linux"
      "default_windows_group":
        "kernel": "windows"
      "default_mac_group":
        "kernel": "Darwin"
      "default_other_group":
        "kernel": ".*"
  END
              
  file { '/etc/foreman/plugins/foreman_default_hostgroup.yaml':
    ensure  => file, 
    content => inline_epp($default_hostgroup_template),
    require => Class['::foreman::plugin::default_hostgroup'],
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
    serveraliases         => $foreman_serveraliases,
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
    dynflow_in_core       => $dynflow_in_core,
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
