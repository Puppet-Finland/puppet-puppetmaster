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
class puppetmaster
(
  Boolean $puppetserver           = true,
  Boolean $with_puppetdb          = false,
  Boolean $with_puppetboard       = false,
  Boolean $with_foreman           = false,
  Boolean $with_foreman_proxy     = false,
  # Puppetserver spesific parameters using foreman puppet module
  String $reports_liftime         = '14d',
  String $logs_liftime            = '90d',
  Boolean $show_diff              = false,
  Boolean $server_foreman         = false,
  Boolean $autosign               = false,
  Array[String] $autosign_entries = [ '*.tietoteema.vm' ],
  Array[String] $primary_names    = [ 'puppetserver.tietoteema.vm' ],
  String $server_reports          = 'store',
) {
    
  if $with_puppetboard and ! $with_puppetdb {
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
  
  if $with_foreman {
    #
  }
  
  if $with_foreman_proxy {
    #
  }
  
}
