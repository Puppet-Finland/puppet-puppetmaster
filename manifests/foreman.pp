# 
# Class to setup Foreman 
#
# == Parameters:
#
# $foreman_db_password:: XXX
#
# $foreman_admin_firstname:: XXX
#
# $foreman_admin_lastname:: XXX
# 
# $foreman_admin_email:: XXX
#
# $foreman_admin_password:: XXX
#
# $puppetdb_database_password:: XXX
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki' or 'Etc/UTC'.
#
# == Advanced parameters:
#
# $foreman_plugin_cockpit:: XXX
#
# $foreman_compute_vmware:: XXX
#
# $foreman_compute_libvirt:: XXX
#
# $foreman_compute_ec2:: XXX
#
# $foreman_compute_gce:: XXX
#
# $foreman_compute_openstack:: XXX
#
# $foreman_compute_ovirt:: XXX
#
# $foreman_compute_rackspace:: XXX
#
# $foreman_plugin_azure:: Install support for Microsoft Azure
#
# $foreman_plugin_ansible:: XXX
#
# $foreman_plugin_docker:: XXX
#
# $foreman_plugin_bootdisk:: XXX
# 
# $foreman_plugin_default_hostgroup:: XXX
#
# $foreman_plugin_dhcp_browser:: XXX
#
# $foreman_plugin_digitalocean:: XXX
#
# $foreman_plugin_discovery:: XXX
#
# $foreman_plugin_hooks:: XXX
#
# $foreman_plugin_memcache:: XXX
#
# $foreman_plugin_remote_execution:: XXX
#
# $foreman_plugin_tasks:: XXX
#
# $foreman_plugin_templates:: XXX
class puppetmaster::foreman
(
String $foreman_db_password,
  String $foreman_admin_firstname,
  String $foreman_admin_lastname,
  String $foreman_admin_email,
  String $foreman_admin_password,
  String $timezone,
  String $puppetdb_database_password,
  Boolean $foreman_plugin_cockpit,
  Boolean $foreman_compute_vmware,
  Boolean $foreman_compute_libvirt,
  Boolean $foreman_compute_ec2,
  Boolean $foreman_compute_gce,
  Boolean $foreman_compute_openstack,
  Boolean $foreman_compute_ovirt,
  Boolean $foreman_compute_rackspace,
  Boolean $foreman_plugin_azure,
  Boolean $foreman_plugin_ansible,
  Boolean $foreman_plugin_docker,
  Boolean $foreman_plugin_bootdisk,
  Boolean $foreman_plugin_default_hostgroup,
  Boolean $foreman_plugin_dhcp_browser,
  Boolean $foreman_plugin_digitalocean,
  Boolean $foreman_plugin_discovery,
  Boolean $foreman_plugin_hooks,
  Boolean $foreman_plugin_memcache,
  Boolean $foreman_plugin_remote_execution,
  Boolean $foreman_plugin_tasks,
  Boolean $foreman_plugin_templates,
)
{

  $foreman_version                    = '1.16.0'
  $foreman_repo                       = '1.16'
  $foreman_manage_memcached           = true
  $foreman_memcached_max_memory       = '8%'
  $foreman_url                        = "https://${facts['fqdn']}"
  $primary_names                      = unique([ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ])
  $foreman_serveraliases              = $primary_names
  $foreman_puppetdb_dashboard_address = "http://${facts['fqdn']}:8080/pdb/dashboard"
  $foreman_puppetdb_address           = "https://${facts['fqdn']}:8081/v2/commands"
  $puppetdb_server                    = $facts['fqdn']
  
  
  unless ("${facts['osfamily']}" == 'RedHat' and "${facts['os']['release']['major']}" == '7') {
    fail("${facts['os']['name']} ${facts['os']['release']['full']} not supported yet")
  }
  
  # See https://github.com/theforeman/puppet-foreman#foreman-version-compatibility-notes
  if versioncmp($foreman_version, '1.17') < 0 {
    $dynflow_in_core = false
  }
  else {
    $dynflow_in_core = true
  }

  unless "${facts['osfamily']}" != 'RedHat' {
    
    class { selinux:
      mode => 'enforcing',
      type => 'targeted',
    }
    
    selinux::module { 'httpd_t':
      ensure    => 'present',
      source_te => '/home/puppetmaster/files/httpd_t.te',
      builder   => 'simple',
    }

    selinux::fcontext { 'set-httpd-file-context':
      seltype  => 'httpd_sys_content_t',
      pathspec => '/etc/puppetlabs/puppet/ssl(/.*)?',
    }
    
    selinux::exec_restorecon { '/etc/puppetlabs/puppet/ssl':
      require => Selinux::Fcontext['set-httpd-file-context'],
    }
  }


  @firewall { '443 accept template and UI':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => ['80','443'],
    proto  => 'tcp',
    action => 'accept',
    tag    => foreman,
  }

  @firewall { '8443 accept foreman proxies':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => '8443',
    proto  => 'tcp',
    action => 'accept',
  }

  @firewall { '8140 allow puppet':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }

  @firewall { '8443 allow traffic to smart proxies':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '8443',
    proto  => 'tcp',
    action => 'accept',
  }

  if ($foreman_manage_memcached) {
    class { 'memcached':
      max_memory => $foreman_memcached_max_memory,
    }
  }

  cron { 'Collect trend data':
    environment => 'PATH=/opt/puppetlabs/bin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
    command     => '/sbin/foreman-rake foreman-rake trends:counter',
    user        => 'root',
    hour        => 0,
    minute      => 0/30,
    require     => Class['::foreman'],
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

  class { '::epel':
    before => Class['::foreman'],
  }
  

  unless defined(Class['::puppetmaster::common']) {
    
    class { '::puppetmaster::common':
      primary_names => $primary_names,
      timezone      => $timezone, 
      before        => Class['::foreman'],
    }
  }
  
  class { '::puppet':
    server         => true,
    show_diff      => true,
    server_foreman => true,
    autosign       => '/etc/puppetlabs/puppet/autosign.conf',
    server_reports => 'store, foreman',
    require        => [ File['/etc/puppetlabs/puppet/fileserver.conf'], Puppet_authorization::Rule['files'] ],
    before         => Class['::foreman'],
  }

  class { '::puppetmaster::databaseserver':
  }
  
  class { '::puppetdb':
    database_password     => $puppetdb_database_password,
    ssl_deploy_certs      => true,
    manage_dbserver       => false, 
    require               => [
      Class['::puppet'],
      Class['::puppetmaster::databaseserver'],
    ]
  }
  
  class { '::puppetdb::master::config':
    puppetdb_server => $puppetdb_server,
    restart_puppet  => true,
  }

  ::puppetmaster::database { 'foreman':
    dbname   => foreman,
    username => foreman,
    password => $foreman_db_password,
    require  => Class['::puppetmaster::databaseserver'],
    before   => Class['::foreman'],
  }  

  class { '::foreman':
    foreman_url           => $foreman_url,
    db_manage             => false,
    db_username           => 'foreman',
    db_password           => $foreman_db_password,
    db_type               => 'postgresql',
    db_host               => 'localhost',
    db_database           => 'foreman',
    authentication        => true,
    admin_username        => 'admin',
    admin_password        => $foreman_admin_password,
    servername            => 'foreman',
    serveraliases         => $foreman_serveraliases,
    admin_first_name      => $foreman_admin_firstname,
    admin_last_name       => $foreman_admin_lastname,
    admin_email           => $foreman_admin_email,
    organizations_enabled => false,
    initial_organization  => '',
    repo                  => $foreman_repo,
    version               => $foreman_version,
    configure_epel_repo   => false,
    configure_scl_repo    => true,
    locations_enabled     => true,
    initial_location      => 'Foreman Cloud',
    selinux               => true,
    unattended            => true,
    dynflow_in_core       => $dynflow_in_core,
  }

  if $foreman_compute_vmware {
    class { '::foreman::compute::vmware':
    }
  }

  if $foreman_compute_libvirt {
    class { '::foreman::compute::libvirt':
    }
  }
    
  if $foreman_compute_ec2 {
    class { '::foreman::compute::ec2':
    }
  }

  if $foreman_compute_gce {
    class { '::foreman::compute::gce':
    }
  }
  
  if $foreman_compute_openstack {
    class { '::foreman::compute::openstack':
    }
  }
  
  if $foreman_compute_ovirt {
    class { '::foreman::compute::ovirt':
    }
  }

  if $foreman_plugin_azure {
    class { '::foreman::plugin::azure':
    }
  }
  
  if $foreman_plugin_cockpit {
    class { '::foreman::plugin::cockpit':
    }
  }
  
  if $foreman_plugin_ansible {
    
    class { '::foreman::plugin::ansible':
    }

    package { 'ansible':
      ensure  => installed,
      require => Class['::foreman::plugin::ansible'],
    }
  }

  if $foreman_plugin_docker {
    class { '::foreman::plugin::docker':
    }
  }

  if $foreman_plugin_bootdisk {
    class { '::foreman::plugin::bootdisk':
    }
  }

  if $foreman_plugin_default_hostgroup {

    class { '::foreman::plugin::default_hostgroup':
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
  }

  if $foreman_plugin_dhcp_browser {
    class { '::foreman::plugin::dhcp_browser':
    }
  }

  if $foreman_plugin_digitalocean {
    class { '::foreman::plugin::digitalocean':
    }
  }

  if $foreman_plugin_discovery {
    class { '::foreman::plugin::discovery':
    }
  }
  

  if $foreman_plugin_hooks {
    class { '::foreman::plugin::hooks':
    }
  }

  if $foreman_plugin_memcache {
    class { '::foreman::plugin::memcache':
    }
  }

  if $foreman_plugin_remote_execution {
    class { '::foreman::plugin::remote_execution':
    }
  }

  if $foreman_plugin_tasks {
    class { '::foreman::plugin::tasks':
    }
  }

  if $foreman_plugin_templates {
    class { '::foreman::plugin::templates':
    }
  }

  class { '::foreman::plugin::puppetdb':
    dashboard_address => $foreman_puppetdb_dashboard_address,
    address           => $foreman_puppetdb_address,
  }
  
  class { '::foreman::cli':
    version            => $foreman_version,
    foreman_url        => $foreman_url,
    username           => 'admin',
    password           => $foreman_admin_password,
    manage_root_config => true,
  }
}
