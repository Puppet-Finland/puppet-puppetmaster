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
# $foreman_foreman_plugin_cockpit:: XXX
#
class puppetmaster
(
  Boolean $puppetserver                      = true,
  Boolean $with_puppetdb                     = false,
  Boolean $with_puppetboard                  = false,
  Boolean $with_foreman                      = false,
  Boolean $with_foreman_proxy                = false,
  # Puppetserver spesific parameters using foreman puppet module
  String $reports_liftime                    = '14d',
  String $logs_liftime                       = '90d',
  Boolean $show_diff                         = false,
  Boolean $server_foreman                    = false,
  Boolean $autosign                          = false,
  Array[String] $autosign_entries            = [ '*.tietoteema.vm' ],
  Array[String] $primary_names               = [ 'kafo.tietoteema.vm', 'kafo' ],
  String $server_reports                     = 'store',
  # Puppetdb spesific parameters
  String $puppetdb_listen_address            = '127.0.0.1',
  String $puppetdb_listen_port               = '8082',
  String $puppetdb_ssl_listen_port           = '8081',
  String $puppetdb_database_host             = '127.0.0.1',
  String $puppetdb_database_name             = 'puppetdb',
  String $puppetdb_database_username         = 'puppetdb',
  String $puppetdb_database_password         = 'puppetdb',
  Boolean $puppetdb_manage_dbserver          = false,
  Boolean $puppetdb_manage_package_repo      = false,
  String $puppetdb_puppetdb_server           = 'kafo.tietoteema.vm',
  String $puppetdb_connection_limit          = '-1',
  String $puppetdb_db_connection_limit       = '-1',
  String $puppetdb_contrib_package_name      = 'postgresql96-contrib',
  Boolean $puppetdb_ssl_deploy_certs         = true,
  String $puppetdb_postgresql_version        = '9.6',
  String $puppetdb_postgresql_listen_address = '127.0.0.1',
  # Foreman spesific parameters
  String $foreman_initial_organization       = 'tietoteema.com',
  Boolean $foreman_locations_enabled         = false, 
  String $foreman_initial_location           = 'Virtualbox',
  String $foreman_admin_username             = 'admin',
  String $foreman_admin_password             = 'changeme',
  String $foreman_puppetdb_dashboard_address = 'http://puppet.tietoteema.vm:8080/pdb/dashboard',
  String $foreman_puppetdb_address           = 'https://puppet.tietoteema.vm:8081/v2/commands',
  String $foreman_foreman_url                = 'https://puppet.tietoteema.vm',
  String $foreman_repo                       = '1.15',
  String $foreman_version                    = '1.15.6',
  String $foreman_manage_memcached           = true,
  String $foreman_memcached_max_memory       = '8%',
  Boolean $foreman_configure_epel_repo       = true,
  Boolean $foreman_configure_scl_repo        = true,
  String $foreman_oauth_consumer_key         = 'xEL7pzhskio8AHqWhMWCwskzvWNgvQRB',
  String $foreman_oauth_consumer_secret      = '2F5iKu5VzuRzVYRaYFQiNcPghihYn7dP',     
  Boolean $foreman_selinux                   = false,
  Boolean $foreman_unattended                = true,
  Boolean $foreman_foreman_plugin_cockpit    = true,
  String $foreman_admin_email                = 'hostmaster@tietoteema.fi',
  String $foreman_admin_first_name           = 'Admin',
  String $foreman_admin_last_name            = 'User',
  Boolean $foreman_authentication            = true,
  String $foreman_connection_limit           = '-1',
  String $foreman_db_database                = 'foreman',
  String $foreman_db_host                    = '127.0.0.1',
  Boolean $foreman_db_manage                 = false,
  String $foreman_db_password                = 'changeme',
  String $foreman_db_type                    = 'postgresql',
  String $foreman_db_username                = 'foreman',
  Boolean $foreman_organizations_enabled     = false,
  Array[String] $foreman_serveraliases       = [ 'foreman' ],
  String $foreman_servername                 = 'kafo.tietoteema.vm',
  ) {
    
  if $with_puppetboard and !$with_puppetdb {
    notify { "Puppetboard needs Puppetdb. installing Puppetdb too": }
    $with_puppetdb = true
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
      show_diff             => $show_diff,
      server_foreman        => false,
      autosign              => $autosign,
      autosign_entries      => $autosign_entries,
      server_external_nodes => '', # this is needed for the module that tends towards foreman
      additional_settings   => $additional_settings,
      server_reports        => $server_reports,
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
      foreman_foreman_plugin_cockpit     => $foreman_foreman_plugin_cockpit,
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
    }
  }
}
