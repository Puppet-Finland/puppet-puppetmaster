# A wrapper class for setting up puppetserver. Usable on Puppet servers as
# well as in Kafo installers.
#
# == Parameters:
#
# $primary_names:: Primary names for this machine
#
# $reports_lifetime:: How long to keep reports
#
# $logs_lifetime:: How long to keep logs
#
# $show_diff:: Show diffs
#
# $server_foreman:: Install foreman
#
# $autosign:: Set up autosign entries
#
# $autosign_entries:: List of autosign entries
#
# $server_reports:: Reporting to where
#
# $server_external_nodes:: Path to external node classifier
#
class puppetmaster
(
  Array[String]            $primary_names,
  String                   $reports_lifetime = '14d',
  String                   $logs_lifetime = '90d',
  Boolean                  $show_diff = false,
  Variant[Boolean, String] $autosign = false,
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $server_reports = 'store',
  Boolean                  $server_foreman = false,
  Optional[String]         $server_external_nodes = undef,
)
{

  class { '::hosts':
    primary_names => $primary_names,
  }

  @firewall { '8140 accept incoming agent traffic to puppetserver':
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
    tag    => 'default',
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
    match_request_path => '^/puppet/v3/file_(content|metadata)s?/files/',
    match_request_type => 'regex',
    allow              => '*',
    sort_order         => 400,
    path               => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
  }

  class { '::puppet':
    server                => true,
    show_diff             => $show_diff,
    server_foreman        => $server_foreman,
    autosign              => $autosign,
    autosign_entries      => $autosign_entries,
    server_external_nodes => $server_external_nodes,
    additional_settings   => $additional_settings,
    server_reports        => $puppetserver_server_reports,
    require               => [ File['/etc/puppetlabs/puppet/fileserver.conf'], Puppet_authorization::Rule['files'] ],
  }

  tidy { '/opt/puppetlabs/server/data/puppetserver/reports':
    age     => $reports_lifetime,
    matches => "*.yaml",
    recurse => true,
    rmdirs  => false,
    type    => ctime,
  }

  tidy { '/var/log/puppetlabs/puppetserver':
    age     => $logs_lifetime,
    matches => "puppetserver.*",
    recurse => true,
    rmdirs  => false,
    type    => ctime,
  }
}
