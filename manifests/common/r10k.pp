# r10k install and configure, but not run
#
class puppetmaster::common::r10k
(
  Optional[String] $provider,
  Optional[String] $repo_host,
  String           $repo_url,
  String           $key_path
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
      $l_repo_host = 'gitlab.com'

      sshkey { $l_repo_host:
        ensure  => present,
        type    => 'ecdsa-sha2-nistp256',
        target  => '/root/.ssh/known_hosts',
        key     => 'AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=',
        require => File['/root/.ssh'],
      }
    }
    'bitbucket': {
      $l_repo_host = 'bitbucket.org'
      sshkey { $l_repo_host:
        ensure  => present,
        type    => 'ssh-rsa',
        target  => '/root/.ssh/known_hosts',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==',
        require => File['/root/.ssh'],
      }
    }
    default: {
      if $repo_host {
        $l_repo_host = $repo_host
        notify { "provider ${provider} is not yet supported. Ensure that ${provider} has an entry in /root/.ssh/known_hosts": }
      } else {
        fail('ERROR: you need to define the $repo_host parameter when using a custom provider!')
      }
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

