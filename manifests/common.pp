# Common configurations for all scenarios
#
# == Parameters:
#
# $reports_lifetime:: How long reports are stored. For example '14d'.
#
# $logs_lifetime:: How long logs are stored. For example '90d'.
#
# $hosts_entries:: Hash of additional host entries. Example: 
class puppetmaster::common
(
  Array[String] $primary_names,
  String        $reports_lifetime = '14d',
  String        $logs_lifetime = '90d',
  String        $timezone,
  Hash          $hosts_entries = {},
)
{

  $packages = $facts['os']['name'] ? {
    'CentOS' => [],
    'Debian' => ['apt-transport-https'],
    'Ubuntu' => [],
  }
  
  ensure_packages($packages)

  class { '::timezone':
    timezone => $timezone,
  }


  class { '::hosts':
    primary_names => $primary_names,
    entries       => $hosts_entries,
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
