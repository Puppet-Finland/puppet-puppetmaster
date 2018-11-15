# r10k install and configure, but not run
#
class puppetmaster::common::r10k
(
  Enum['gitlab'] $provider,
  String         $repo_url,
  String         $key_path,
  String         $repo_host,
)
{

  file { '/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  case $provider {
    'gitlab': {

      sshkey { 'gitlab.com':
        ensure  => present,
        type    => 'ecdsa-sha2-nistp256',
        target  => '/root/.ssh/known_hosts',
        key     => 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=',
        require => File['/root/.ssh'],
      }
    }
    default: {
      notify { "provider ${provider} is not yet supported. Place the of key of provider ${provider} in /root/.ssh/known_hosts": }
    }
  }

  class { '::r10k':
    sources => {
      'control' => {
        'remote'  => $repo_url,
        'basedir' => '/etc/puppetlabs/code/environments',
        'prefix'  => false,
      },
    },
  }

  file { '/etc/puppetlabs/r10k/ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/root/.ssh/config':
    ensure  => 'present',
    mode    => '0400',
    content => template('puppetmaster/ssh-config.erb'),
    require => File['/root/.ssh'],
  }
}

