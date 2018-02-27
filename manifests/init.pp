# A wrapper class for setting up puppetmasters in Kafo installers. 
#
# == Parameters:
#
# $puppetserver:: Setup puppetserver
#
# $with_puppetdb:: Setup puppetserver with puppetdb
#
# $with_puppetboard:: Setup puppetserver with puppetboard
#
# $with_foreman:: Setup puppetserver with foreman
#
# $with_foreman_proxy:: Setup puppetserver with foreman_proxy
#
#
# Puppetmaster spesific parameters:
#
# $reports_liftime:: How long to keep reports
#
# $logs_liftime:: How long to keep logs
# 
# $show_diff:: Show diffs
#
# $server_foreman:: Install foreman
#
# $autosign:: Set up autosign entries
#
# $autosign_entries:: List of autosign entries
#
# $primary_names:: Primary names for this machine
# 
# $server_reports:: Reporting to where
#
#
# Puppetdb spesific parameters
#
# $puppetdb_listen_address:: Address to listen to
#
# $puppetdb_listen_port:: Port to listen to 
#
# $puppetdb_ssl_listen_port:: SSL port to listen to
#
# $puppetdb_database_host:: Database host 
#
# $puppetdb_database_name:: Database name 
#
# $puppetdb_database_username:: Database user name
#
# $puppetdb_database_password:: Datbase password
#
# $puppetdb_manage_dbserver:: Whether to manage DB server 
#
# $puppetdb_manage_package_repo:: Whether to manage package repo
#
# $puppetdb_puppetdb_server:: Server   
#
# $puppetdb_connection_limit:: Connection limit  
#
# $puppetdb_db_connection_limit:: Database connection limit
#
# $puppetdb_contrib_package_name:: Name of the contrib package
#
# $puppetdb_ssl_deploy_certs:: Whether to deploy certificates
#
# $puppetdb_postgresql_version:: PostgreSQL version
#
# $puppetdb_postgresql_listen_address:: PostgreSQL listen address
#
# Foreman spesific parameters
#
# $foreman_db_manage:: XXX
#
# $foreman_db_type:: XXX
#
# $foreman_db_host:: XXX
#
# $foreman_db_database:: XXX
#
# $foreman_db_username:: XXX
#
# $foreman_db_password:: XXX
#
# $foreman_connection_limit:: XXX
#  
# $foreman_authentication:: XXX
#
# $foreman_servername:: XXX
#
# $foreman_serveraliases:: XXX
#
# $foreman_admin_first_name:: XXX
#
# $foreman_admin_last_name:: XXX
#
# $foreman_admin_email:: XXX
#
# $foreman_organizations_enabled:: XXX
#
# $foreman_initial_organization:: XXX
#
# $foreman_locations_enabled:: XXX
#
# $foreman_initial_location:: XXX
#
# $foreman_admin_username:: XXX
#
# $foreman_admin_password:: XXX
#
# $foreman_puppetdb_dashboard_address:: XXX
#
# $foreman_puppetdb_address:: XXX
#
# $foreman_foreman_url:: XXX
#
# $foreman_repo:: XXX
#
# $foreman_version:: XXX
#
# $foreman_manage_memcached:: XXX
#
# $foreman_memcached_max_memory:: XXX
#
# $foreman_configure_epel_repo:: XXX
#
# $foreman_configure_scl_repo:: XXX
#
# $foreman_oauth_consumer_key:: XXX
#
# $foreman_oauth_consumer_secret:: XXX
#
# $foreman_selinux:: XXX
#
# $foreman_unattended:: XXX
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
#
#
# Foreman Proxy spesific parameters
#
# $foreman_proxy_http::                       Enable http
#
# $foreman_proxy_http_port::                  HTTP port to listen on (if http is enabled)
#
# $foreman_proxy_user::                       User under which foreman proxy will run
#
# $foreman_proxy_group::                      Group under which foreman proxy will run
#
# $foreman_proxy_groups::                     Array of additional groups for the foreman proxy user
#
# $foreman_proxy_log_level::                  Foreman proxy log level
#
# $foreman_proxy_trusted_hosts::              Only hosts listed will be permitted, empty array to disable authorization
#
# $foreman_proxy_manage_sudoersd::            Whether to manage File['/etc/sudoers.d'] or not.  When reusing this module, this may be
#                               disabled to let a dedicated sudo module manage it instead.
# $foreman_proxy_use_sudoersd::               Add a file to /etc/sudoers.d (true).
#
# $foreman_proxy_use_sudoers::                Add contents to /etc/sudoers (true). This is ignored if $use_sudoersd is true.
#
# $foreman_proxy_puppetca::                   Enable Puppet CA feature
#
# $foreman_proxy_puppetca_listen_on::         Protocols for the Puppet CA feature to listen on
#
# $foreman_proxy_puppetdir::                  Puppet var directory
#
# $foreman_proxy_puppetca_cmd::               Puppet CA command to be allowed in sudoers
#
# $foreman_proxy_puppet::                     Enable Puppet module for environment imports and Puppet runs
#
# $foreman_proxy_puppet_listen_on::           Protocols for the Puppet feature to listen on
#
# $foreman_proxy_puppetrun_provider::         Provider for running/kicking Puppet agents
#
# $foreman_proxy_puppetrun_cmd::              Puppet run/kick command to be allowed in sudoers
#
# $foreman_proxy_customrun_cmd::              Puppet customrun command
#
# $foreman_proxy_customrun_args::             Puppet customrun command arguments
#
# $foreman_proxy_mcollective_user::           The user for puppetrun_provider mcollective
#
# $foreman_proxy_puppetssh_sudo::             Whether to use sudo before commands when using puppetrun_provider puppetssh
#
# $foreman_proxy_puppetssh_user::             The user for puppetrun_provider puppetssh
#
# $foreman_proxy_puppetssh_keyfile::          The keyfile for puppetrun_provider puppetssh commands
#
# $foreman_proxy_puppet_url::                 URL of the Puppet master itself for API requests
#
# $foreman_proxy_puppet_use_environment_api:: Override use of Puppet's API to list environments.  When unset, the proxy will
#                               try to determine this automatically.
# $foreman_proxy_templates::                  Enable templates feature
#
# $foreman_proxy_templates_listen_on::        Templates proxy to listen on https, http, or both
#
# $foreman_proxy_template_url::               URL a client should use for provisioning templates
#
# $foreman_proxy_tftp::                       Enable TFTP feature
#
# $foreman_proxy_tftp_listen_on::             TFTP proxy to listen on https, http, or both
#
# $foreman_proxy_tftp_managed::               TFTP is managed by Foreman proxy
#
# $foreman_proxy_tftp_manage_wget::           If enabled will install the wget package
#
# $foreman_proxy_tftp_root::                  TFTP root directory
#
# $foreman_proxy_tftp_servername::            Defines the TFTP Servername to use, overrides the name in the subnet declaration
#
# $foreman_proxy_dhcp::                       Enable DHCP feature
#
# $foreman_proxy_dhcp_listen_on::             DHCP proxy to listen on https, http, or both
#
# $foreman_proxy_dhcp_managed::               DHCP is managed by Foreman proxy
#
# $foreman_proxy_dhcp_provider::              DHCP provider
#
# $foreman_proxy_dhcp_subnets::               Subnets list to restrict DHCP management to
# $foreman_proxy_dhcp_option_domain::         DHCP use the dhcpd config option domain-name
#
# $foreman_proxy_dhcp_search_domains::        DHCP search domains option
#
# $foreman_proxy_dhcp_interface::             DHCP listen interface
#
# $foreman_proxy_dhcp_gateway::               DHCP pool gateway
#
# $foreman_proxy_dhcp_range::                 Space-separated DHCP pool range
#
# $foreman_proxy_dhcp_nameservers::           DHCP nameservers, comma-separated
#
# $foreman_proxy_dhcp_pxeserver::             DHCP "next-server" value, defaults otherwise to IP of dhcp_interface
#
# $foreman_proxy_dhcp_server::                Address of DHCP server to manage
#
# $foreman_proxy_dns::                        Enable DNS feature
#
# $foreman_proxy_dns_listen_on::              DNS proxy to listen on https, http, or both
#
# $foreman_proxy_dns_managed::                DNS is managed by Foreman proxy
#
# $foreman_proxy_dns_provider::               DNS provider
#
# $foreman_proxy_dns_interface::              DNS interface
#
# $foreman_proxy_dns_zone::                   DNS zone name
#
# $foreman_proxy_dns_reverse::                DNS reverse zone name
#
# $foreman_proxy_dns_server::                 Address of DNS server to manage
#
# $foreman_proxy_dns_ttl::                    DNS default TTL override
#
# $foreman_proxy_dns_forwarders::             DNS forwarders
#
# $foreman_proxy_bmc::                        Enable BMC feature
#
# $foreman_proxy_bmc_listen_on::              BMC proxy to listen on https, http, or both
#
# $foreman_proxy_bmc_default_provider::       BMC default provider.
#
# $foreman_proxy_register_in_foreman::        Register proxy back in Foreman
#
# $foreman_proxy_registered_name:: Proxy name which is registered in Foreman
#
# $foreman_proxy_registered_proxy_url:: Proxy URL which is registered in Foreman
#
# $foreman_proxy_oauth_consumer_key::         OAuth key to be used for REST interaction
#
# $foreman_proxy_oauth_consumer_secret::      OAuth secret to be used for REST interaction
#
# $foreman_proxy_puppet_use_cache::           Whether to enable caching of puppet classes
#
# $foreman_proxy_include_epel::               Whether to configure EPEL
#
# $foreman_proxy_version::                    Foreman proxy version
#
# $foreman_proxy_ensure_packages_version::    Ensure extra packages version
class puppetmaster
(
  Boolean $puppetserver                                    = true,
  Boolean $with_puppetdb                                   = false,
  Boolean $with_puppetboard                                = false,
  Boolean $with_foreman                                    = false,
  Boolean $with_foreman_proxy                              = false,
  # Puppetserver spesific parameters using foreman puppet module
  String $reports_liftime                                  = '14d',
  String $logs_liftime                                     = '90d',
  Boolean $show_diff                                       = false,
  Boolean $server_foreman                                  = false,
  Boolean $autosign                                        = false,
  Array[String] $autosign_entries                          = [ '*.tietoteema.vm' ],
  Array[String] $primary_names                             = [ 'kafo.tietoteema.vm', 'kafo' ],
  String $server_reports                                   = 'store',
  # Puppetdb spesific parameters
  String $puppetdb_listen_address                          = '127.0.0.1',
  String $puppetdb_listen_port                             = '8082',
  String $puppetdb_ssl_listen_port                         = '8081',
  String $puppetdb_database_host                           = '127.0.0.1',
  String $puppetdb_database_name                           = 'puppetdb',
  String $puppetdb_database_username                       = 'puppetdb',
  String $puppetdb_database_password                       = 'puppetdb',
  Boolean $puppetdb_manage_dbserver                        = false,
  Boolean $puppetdb_manage_package_repo                    = false,
  String $puppetdb_puppetdb_server                         = 'kafo.tietoteema.vm',
  String $puppetdb_connection_limit                        = '-1',
  String $puppetdb_db_connection_limit                     = '-1',
  String $puppetdb_contrib_package_name                    = 'postgresql96-contrib',
  Boolean $puppetdb_ssl_deploy_certs                       = true,
  String $puppetdb_postgresql_version                      = '9.6',
  String $puppetdb_postgresql_listen_address               = '127.0.0.1',
  # Foreman spesific parameters
  String $foreman_initial_organization                     = 'tietoteema.com',
  Boolean $foreman_locations_enabled                       = false, 
  String $foreman_initial_location                         = 'Virtualbox',
  String $foreman_admin_username                           = 'admin',
  String $foreman_admin_password                           = 'changeme',
  String $foreman_puppetdb_dashboard_address               = 'http://puppet.tietoteema.vm:8080/pdb/dashboard',
  String $foreman_puppetdb_address                         = 'https://puppet.tietoteema.vm:8081/v2/commands',
  String $foreman_foreman_url                              = 'https://puppet.tietoteema.vm',
  String $foreman_repo                                     = '1.15',
  String $foreman_version                                  = '1.15.6',
  String $foreman_manage_memcached                         = true,
  String $foreman_memcached_max_memory                     = '8%',
  Boolean $foreman_configure_epel_repo                     = true,
  Boolean $foreman_configure_scl_repo                      = true,
  String $foreman_oauth_consumer_key                       = 'xEL7pzhskio8AHqWhMWCwskzvWNgvQRB',
  String $foreman_oauth_consumer_secret                    = '2F5iKu5VzuRzVYRaYFQiNcPghihYn7dP',     
  Boolean $foreman_selinux                                 = false,
  Boolean $foreman_unattended                              = true,
  Boolean $foreman_plugin_cockpit                          = true,
  String $foreman_admin_email                              = 'hostmaster@tietoteema.fi',
  String $foreman_admin_first_name                         = 'Admin',
  String $foreman_admin_last_name                          = 'User',
  Boolean $foreman_authentication                          = true,
  String $foreman_connection_limit                         = '-1',
  String $foreman_db_database                              = 'foreman',
  String $foreman_db_host                                  = '127.0.0.1',
  Boolean $foreman_db_manage                               = false,
  String $foreman_db_password                              = 'changeme',
  String $foreman_db_type                                  = 'postgresql',
  String $foreman_db_username                              = 'foreman',
  Boolean $foreman_organizations_enabled                   = false,
  Array[String] $foreman_serveraliases                     = [ 'foreman' ],
  String $foreman_servername                               = 'kafo.tietoteema.vm',
  Boolean $foreman_compute_vmware                          = false,
  Boolean $foreman_compute_libvirt                         = false,
  Boolean $foreman_compute_ec2                             = false,
  Boolean $foreman_compute_gce                             = false,
  Boolean $foreman_compute_openstack                       = false,
  Boolean $foreman_compute_ovirt                           = false,
  Boolean $foreman_compute_rackspace                       = false,
  Boolean $foreman_plugin_ansible                          = false,
  Boolean $foreman_plugin_docker                           = false,
  Boolean $foreman_plugin_bootdisk                         = false,
  Boolean $foreman_plugin_default_hostgroup                = false,
  Boolean $foreman_plugin_dhcp_browser                     = false,
  Boolean $foreman_plugin_digitalocean                     = false,
  Boolean $foreman_plugin_discovery                        = false,
  Boolean $foreman_plugin_hooks                            = false,
  Boolean $foreman_plugin_memcache                         = false,
  Boolean $foreman_plugin_remote_execution                 = false,
  Boolean $foreman_plugin_tasks                            = false,
  Boolean $foreman_plugin_templates                        = false,    
  # foreman proxy spesific settings
  String $foreman_proxy_user                               = 'foreman-proxy',
  String $foreman_proxy_group                              = 'foreman-proxy',
  Array[String] $foreman_proxy_groups                      = ['puppet'],
  String $foreman_proxy_oauth_consumer_key                 = 'xEL7pzhskio8AHqWhMWCwskzvWNgvQRB',
  String $foreman_proxy_oauth_consumer_secret              = '2F5iKu5VzuRzVYRaYFQiNcPghihYn7dP',
  Boolean $foreman_proxy_templates                         = false,
  String $foreman_proxy_templates_listen_on                = 'http',
  String $foreman_proxy_template_url                       = 'http://puppet.tietoteema.vm:8000',
  Boolean $foreman_proxy_http                              = true,
  String $foreman_proxy_http_port                          = '8000',
  Boolean $foreman_proxy_manage_sudoersd                   = false,
  Boolean $foreman_proxy_use_sudoersd                      = false,
  # puppet
  String $foreman_proxy_puppet_url                         = 'https://kafo.tietoteema.vm:8140',
  Boolean $foreman_proxy_puppet_use_environment_api        = true,
  Boolean $foreman_proxy_puppet_use_cache                  = true,
  # puppetca settings
  Boolean $foreman_proxy_puppetca                          = false,
  String $foreman_proxy_puppetca_listen_on                 = 'https',
  String $foreman_proxy_puppetca_cmd                       = '/opt/puppetlabs/bin/puppet cert', 
  String $foreman_proxy_puppetdir                          = '/etc/puppetlabs/puppet',
  # puppetrun settings
  Boolean $foreman_proxy_puppet                            = true,
  String $foreman_proxy_puppet_listen_on                   = 'https',
  String $foreman_proxy_puppetrun_cmd                      = 'puppetssh', 
  String $foreman_proxy_puppetrun_provider                 = 'puppetssh', 
  String $foreman_proxy_customrun_cmd                      = '/bin/bash',
  String $foreman_proxy_customrun_args                     = '-ay -f -s',
  String $foreman_proxy_mcollective_user                   = 'root',
  Boolean $foreman_proxy_puppetssh_sudo                    = false,
  String $foreman_proxy_puppetssh_user                     = 'vagrant',
  String $foreman_proxy_puppetssh_keyfile                  = '/etc/foreman-proxy/id_rsa',
  # dhcp
  Boolean $foreman_proxy_dhcp                              = false,
  Boolean $foreman_proxy_dhcp_managed                      = false,
  String $foreman_proxy_dhcp_listen_on                     = 'both',
  String $foreman_proxy_dhcp_interface                     = 'eth1',
  Array[String] $foreman_proxy_dhcp_option_domain          = [ 'tietoteema.vm' ],
  Array[String] $foreman_proxy_dhcp_search_domains         = [ 'tietoteema.vm' ],
  String $foreman_proxy_dhcp_server                        = 'puppet.tietoteema.vm',
  String $foreman_proxy_dhcp_provider                      = 'isc',
  Array[String] $foreman_proxy_dhcp_subnets                = ['192.168.137.0/255.255.255.0'],
  String $foreman_proxy_dhcp_gateway                       = '192.168.137.10',
  String $foreman_proxy_dhcp_range                         = '192.168.137.100 192.168.137.200',
  String $foreman_proxy_dhcp_nameservers                   = '192.168.137.10',    
  String $foreman_proxy_dhcp_pxeserver                     = '192.168.137.201',
  # dns
  Boolean $foreman_proxy_dns                               = false,
  Boolean $foreman_proxy_dns_managed                       = false,  
  Array[String] $foreman_proxy_dns_forwarders              = [ '192.168.137.201', '8.8.8.8' ],
  String $foreman_proxy_dns_interface                      = 'eth1',
  String $foreman_proxy_dns_listen_on                      = 'https',  
  String $foreman_proxy_dns_provider                       = 'nsupdate',  
  String $foreman_proxy_dns_zone                           = $::domain,  
  String $foreman_proxy_dns_reverse                        = '137.168.192.in-addr.arpa',  
  String $foreman_proxy_dns_server                         = '192.168.137.10',
  String $foreman_proxy_dns_ttl                            = '86400',  
  # tftp
  Boolean $foreman_proxy_tftp                              = false,
  Boolean $foreman_proxy_tftp_managed                      = false,
  String $foreman_proxy_tftp_servername                    = '192.168.137.10',
  Boolean $foreman_proxy_tftp_manage_wget                  = true,
  String $foreman_proxy_tftp_listen_on                     = 'both',  
  String $foreman_proxy_tftp_root                          = '/var/lib/tftpboot',
  # BMC
  Boolean $foreman_proxy_bmc                               = false,
  String $foreman_proxy_bmc_listen_on                      = 'https',
  String $foreman_proxy_bmc_default_provider               = 'ipmitool',
  # misc
  Boolean $foreman_proxy_include_epel                      = false,
  String $foreman_proxy_log_level                          = 'DEBUG',
  Boolean $foreman_proxy_register_in_foreman               = true,
  String $foreman_proxy_registered_name                    = 'kafo.tietoteema.vm',
  String $foreman_proxy_registered_proxy_url               = 'https://kafo.tietoteema.vm:8443',
  Array[String] $foreman_proxy_trusted_hosts               = [ 'kafo.tietoteema.vm' ],
  Boolean $foreman_proxy_use_sudoers                       = true,
  String $foreman_proxy_version                            = '1.15.6',
  String $foreman_proxy_ensure_packages_version            = '1.15.6',
  String $foreman_proxy_repo                               = '1.15.6',
  ) {
    
  if $with_puppetboard and !$with_puppetdb {
    notify { "Puppetboard needs Puppetdb. installing Puppetdb too": }
    $with_puppetdb = true
  }            

  if $with_foreman {
    $puppetserver_server_external_nodes = '/etc/puppetlabs/puppet/node.rb' 
    $puppetserver_show_diff             = true
    $puppetserver_server_reports        = 'log, foreman'
  }
  else {
    $puppetserver_server_external_nodes = '' # this is needed to prevent foreman to try ENC
    $puppetserver_show_diff             = $show_diff
    $puppetserver_server_reports        = $server_reports
  }
  
  if $puppetserver {
    
    class { '::hosts':
      primary_names => $primary_names,
    }               
    
    firewall { '8140 accept incoming agent traffic to puppetserver':
      dport  => '8140',
      proto  => 'tcp',
      action => 'accept',
    }
    
    file { '/var/files':
      ensure => 'directory',
      mode   => '0660',
      owner  => 'puppet',
      group  => 'puppet',
    }
    
    file { '/etc/puppetlabs/puppet/fileserver.conf':
      ensure => 'present'
    }
    
    ini_setting { 'files_path':
      ensure            => present,
      path              => '/etc/puppetlabs/puppet/fileserver.conf',
      section           => 'files',
      setting           => 'path',
      value             => '/var/files',
      key_val_separator => ' ',
      require           => File['/etc/puppetlabs/puppet/fileserver.conf'],
    }
    
    ini_setting { 'files_allow':
      ensure            => present,
      path              => '/etc/puppetlabs/puppet/fileserver.conf',
      section           => 'files',
      setting           => 'allow',
      value             => '*',
      key_val_separator => ' ',
      require           => File['/etc/puppetlabs/puppet/fileserver.conf'],
    }
    
    puppet_authorization::rule { 'files':
      match_request_path   => '^/puppet/v3/file_(content|metadata)s?/files/',
      match_request_type   => 'regex',
      allow                => '*',
      sort_order           => 400,
      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    }
    
    class { '::puppet':
      server                => true,
      show_diff             => $puppetserver_show_diff,
      server_foreman        => $puppetserver_server_foreman,
      autosign              => $autosign,
      autosign_entries      => $autosign_entries,
      server_external_nodes => $puppetserver_server_external_nodes,
      additional_settings   => $additional_settings,
      server_reports        => $puppetserver_server_reports,
      require               => [ File['/etc/puppetlabs/puppet/fileserver.conf'], Puppet_authorization::Rule['files'] ],
    }
    
    tidy { '/opt/puppetlabs/server/data/puppetserver/reports':
      age          => $reports_lifetime,
      matches      => "*.yaml",
      recurse      => true,
      rmdirs       => false,
      type         => ctime,
    }
    
    tidy { '/var/log/puppetlabs/puppetserver':
      age          => $logs_lifetime,
      matches      => "puppetserver.*",
      recurse      => true,
      rmdirs       => false,
      type         => ctime,
    }
  }

  if $with_puppetdb {
    
    class { 'puppetmaster::puppetdb': 
      puppetdb_listen_address            => $puppetdb_listen_address,
      puppetdb_listen_port               => $puppetdb_listen_port,
      puppetdb_ssl_listen_port           => $puppetdb_ssl_listen_port,
      puppetdb_database_host             => $puppetdb_database_host,
      puppetdb_database_name             => $puppetdb_database_name,
      puppetdb_database_username         => $puppetdb_database_username,
      puppetdb_database_password         => $puppetdb_database_password,
      puppetdb_manage_dbserver           => $puppetdb_manage_dbserver,
      puppetdb_manage_package_repo       => $puppetdb_manage_package_repo,
      puppetdb_puppetdb_server           => $puppetdb_puppetdb_server,
      puppetdb_connection_limit          => $puppetdb_connection_limit,
      puppetdb_db_connection_limit       => $puppetdb_db_connection_limit,
      puppetdb_contrib_package_name      => $puppetdb_contrib_package_name,
      puppetdb_ssl_deploy_certs          => $puppetdb_ssl_deploy_certs,
      puppetdb_postgresql_version        => $puppetdb_postgresql_version,
      puppetdb_postgresql_listen_address => $puppetdb_postgresql_listen_address,
    }
  }

  if $with_foreman {
    
    class { 'puppetmaster::foreman': 
      foreman_initial_organization       => $foreman_initial_organization,    
      foreman_locations_enabled          => $foreman_locations_enabled,      
      foreman_initial_location           => $foreman_initial_location,      
      foreman_admin_username             => $foreman_admin_username,     
      foreman_admin_password             => $foreman_admin_password,
      foreman_puppetdb_dashboard_address => $foreman_puppetdb_dashboard_address,
      foreman_puppetdb_address           => $foreman_puppetdb_address,
      foreman_foreman_url                => $foreman_foreman_url,
      foreman_repo                       => $foreman_repo,
      foreman_version                    => $foreman_version,
      foreman_manage_memcached           => $foreman_manage_memcached,
      foreman_memcached_max_memory       => $foreman_memcached_max_memory,   
      foreman_configure_epel_repo        => $foreman_configure_epel_repo,
      foreman_configure_scl_repo         => $foreman_configure_scl_repo,
      foreman_oauth_consumer_key         => $foreman_oauth_consumer_key,
      foreman_oauth_consumer_secret      => $foreman_oauth_consumer_secret,
      foreman_selinux                    => $foreman_selinux,
      foreman_unattended                 => $foreman_unattended,
      foreman_plugin_cockpit             => $foreman_plugin_cockpit,
      foreman_admin_email                => $foreman_admin_email,
      foreman_admin_first_name           => $foreman_admin_first_name,
      foreman_admin_last_name            => $foreman_admin_last_name,
      foreman_authentication             => $foreman_authentication,
      foreman_connection_limit           => $foreman_connection_limit,
      foreman_db_database                => $foreman_db_database,
      foreman_db_host                    => $foreman_db_host,
      foreman_db_manage                  => $foreman_db_manage,
      foreman_db_password                => $foreman_db_password,
      foreman_db_type                    => $foreman_db_type,
      foreman_db_username                => $foreman_db_username,
      foreman_organizations_enabled      => $foreman_organizations_enabled,
      foreman_serveraliases              => $foreman_serveraliases,
      foreman_servername                 => $foreman_servername,
      foreman_compute_vmware             => $foreman_compute_vmware,
      foreman_compute_libvirt            => $foreman_compute_libvirt,
      foreman_compute_ec2                => $foreman_compute_ec2,
      foreman_compute_gce                => $foreman_compute_gce,
      foreman_compute_openstack          => $foreman_compute_openstack,
      foreman_compute_ovirt              => $foreman_compute_ovirt,
      foreman_compute_rackspace          => $foreman_compute_rackspace,
      foreman_plugin_ansible             => $foreman_plugin_ansible,
      foreman_plugin_docker              => $foreman_plugin_docker,
      foreman_plugin_bootdisk            => $foreman_plugin_bootdisk,
      foreman_plugin_default_hostgroup   => $foreman_plugin_default_hostgroup,
      foreman_plugin_dhcp_browser        => $foreman_plugin_dhcp_browser,
      foreman_plugin_digitalocean        => $foreman_plugin_digitalocean,
      foreman_plugin_discovery           => $foreman_plugin_discovery,
      foreman_plugin_hooks               => $foreman_plugin_hooks,
      foreman_plugin_memcache            => $foreman_plugin_memcache,
      foreman_plugin_remote_execution    => $foreman_plugin_remote_execution,
      foreman_plugin_tasks               => $foreman_plugin_tasks,
      foreman_plugin_templates           => $foreman_plugin_templates,
    }
  }

  if $with_foreman_proxy {

    class { '::puppetmaster::foreman_proxy':
      foreman_proxy_version                 => $foreman_proxy_version,
      foreman_proxy_ensure_packages_version => $foreman_proxy_ensure_packages_version,
      foreman_proxy_repo                    => $foreman_proxy_repo,
      foreman_proxy_registered_name         => $foreman_proxy_registered_name,
      foreman_proxy_registered_proxy_url    => $foreman_proxy_registered_proxy_url,
      foreman_proxy_foreman_base_ur         => $foreman_proxy_foreman_base_url,
      foreman_proxy_trusted_hosts           => $foreman_proxy_trusted_hosts,
      foreman_proxy_bind_host               => $foreman_proxy_bind_host,
      foreman_proxy_puppet                  => $foreman_proxy_puppet,
      foreman_proxy_puppet_use_cache        => $foreman_proxy_puppet_use_cache, 
      foreman_proxy_puppetca                => $foreman_proxy_puppetca,
      foreman_proxy_puppetdir               => $foreman_proxy_puppetdir,
      foreman_proxy_puppetca_cmd            => $foreman_proxy_puppetca_cmd,
      foreman_proxy_tftp                    => $foreman_proxy_tftp,
      foreman_proxy_tftp_managed            => $foreman_proxy_tftp_managed,
      foreman_proxy_tftp_manage_wget        => $foreman_proxy_tftp_manage_wget,
      foreman_proxy_tftp_dirs               => $foreman_proxy_tftp_dirs,
      foreman_proxy_dhcp_managed            => $foreman_proxy_dhcp_managed,
      foreman_proxy_dhcp                    => $foreman_proxy_dhcp,
      foreman_proxy_dhcp_listen_on          => $foreman_proxy_dhcp_listen_on,
      foreman_proxy_dhcp_interface          => $foreman_proxy_dhcp_interface,
      foreman_proxy_dhcp_subnets            => $foreman_proxy_dhcp_subnets, 
      foreman_proxy_dhcp_gateway            => $foreman_proxy_dhcp_gateway,
      foreman_proxy_dhcp_range              => $foreman_proxy_dhcp_range,
      foreman_proxy_dhcp_nameservers        => $foreman_proxy_dhcp_nameservers,
      foreman_proxy_dhcp_option_domain      => $foreman_proxy_dhcp_option_domain, 
      foreman_proxy_dhcp_search_domains     => $foreman_proxy_dhcp_search_domains,
      foreman_proxy_dhcp_pxeserver          => $foreman_proxy_dhcp_pxeserver,
      foreman_proxy_dns                     => $foreman_proxy_dns,
      foreman_proxy_dns                     => $foreman_proxy_dns_managed,
      foreman_proxy_dns_interface           => $foreman_proxy_dns_interface,
      foreman_proxy_dns_zone                => $foreman_proxy_dns_zone,
      foreman_proxy_dns_forwarders          => $foreman_proxy_dns_forwarders,
      foreman_proxy_dns_ttl                 => $foreman_proxy_dns_ttl,
      foreman_proxy_dns_reverse             => $foreman_proxy_dns_reverse, 
      foreman_proxy_bmc                     => $foreman_proxy_bmc,
      foreman_proxy_bmc_listen_on           => $foreman_proxy_bmc_listen_on,
      foreman_proxy_bmc_default_provider    => $foreman_proxy_bmc_default_provider,
      foreman_proxy_include_epel            => $foreman_proxy_include_epel, 
      foreman_proxy_group                   => $foreman_proxy_group, 
      foreman_proxy_groups                  => $foreman_proxy_groups, 
      foreman_proxy_http                    => $foreman_proxy_http,
      foreman_proxy_log_level               => $foreman_proxy_log_level,
      foreman_proxy_register_in_foreman     => $foreman_proxy_register_in_foreman,
      foreman_proxy_use_sudoers             => $foreman_proxy_use_sudoers,
      foreman_proxy_use_sudoersd            => $foreman_proxy_use_sudoersd,
    }
  }
}
