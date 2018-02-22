# A wrapper class for setting up puppetmasters.
# in Kafo installers. Note this is designed to also work in a control repo case for testing and development.
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
class puppetmaster
(
  Boolean $puppetserver                 = true,
  Boolean $with_puppetdb                = false,
  Boolean $with_puppetboard             = false,
  Boolean $with_foreman                 = false,
  Boolean $with_foreman_proxy           = false,
  # Puppetserver spesific parameters using foreman puppet module
  String $reports_liftime               = '14d',
  String $logs_liftime                  = '90d',
  Boolean $show_diff                    = false,
  Boolean $server_foreman               = false,
  Boolean $autosign                     = false,
  Array[String] $autosign_entries       = [ '*.example.com' ],
  Array[String] $primary_names          = [ 'foo.example.com', 'foo' ],
  String $server_reports                = 'store',
  # Puppetdb spesific parameters
  String $puppetdb_listen_address       = '0.0.0.0',
  String $puppetdb_listen_port          = '8082',
  String $puppetdb_ssl_listen_port      = '8081',
  String $puppetdb_database_host        = '127.0.0.1',
  String $puppetdb_database_name        = 'puppetdb',
  String $puppetdb_database_username    = 'puppetdb',
  String $puppetdb_database_password    = 'puppetdb',
  Boolean $puppetdb_manage_dbserver     = false,
  Boolean $puppetdb_manage_package_repo = false,
  String $puppetdb_puppetdb_server      = 'puppet.tietoteema.vm',
  String $puppetdb_connection_limit     = '-1',
  String $puppetdb_db_connection_limit  = '-1',
  String $puppetdb_contrib_package_name = 'postgresql-contrib-96',
  Boolean $puppetdb_ssl_deploy_certs    = true,
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

    if ($puppetdb_database_host == '127.0.0.1') {
      
      firewall { '5432 allow incoming database':
        chain       => 'INPUT',
        state       => ['NEW'],
        destination => '127.0.0.1/8',
        dport       => '5432',
        proto       => 'tcp',
        action      => 'accept',
      }
    }
    else {
      firewall { '5432 allow outgoing database':
        chain       => 'OUTPUT',
        state       => ['NEW'],
        destination => $puppetdb_database_host,
        dport       => '5432',
        proto       => 'tcp',
        action      => 'accept',
      }                       
    }
    
    firewall { '8081 allow incoming puppetdb':
      chain       => 'INPUT',
      state       => ['NEW'],
      dport       => ['8080','8081'], 
      proto       => 'tcp',
      action      => 'accept',
    }           
    
    if $puppetdb_manage_dbserver {
      
      ::postgresql::server::role { $puppetdb_database_username:
        password_hash => postgresql_password($puppetdb_database_username, $puppetdb_database_password),
        connection_limit => $puppetdb_connection_limit,
      }
      
      ::postgresql::server::database_grant { 'Grant access to puppetdb':
        privilege => 'ALL',
        db        => $puppetdb_database_name,
        role      => $puppetdb_database_username,
      }
      
      ::postgresql::server::extension { 'Add trgm':
        database     => $puppetdb_database_name,
        package_name => $puppetdb_contrib_package_name,
        extension    => 'pg_trgm',
      }    
    }
    
    class { '::puppetdb':
      listen_address      => $puppetdb_listen_address,
      listen_port         => $puppetdb_listen_port,
      ssl_listen_port     => $puppetdb_ssl_listen_port,
      manage_dbserver     => $puppetdb_manage_dbserver,
      database_name       => $puppetdb_database_name,
      database_host       => $puppetdb_database_host,
      manage_package_repo => $puppetdb_manage_package_repo,
      database_username   => $puppetdb_database_username,
      database_password   => $puppetdb_database_password,
      ssl_deploy_certs    => $puppetdb_ssl_deploy_certs,
      require             => Postgresql::Server::Extension['Add trgm'],
    }
    
    class { '::puppetdb::master::config':
      puppetdb_server     => $puppetdb_puppetdb_server,
      restart_puppet      => false,
    }
  }
}
