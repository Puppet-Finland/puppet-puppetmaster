class puppetmaster::control
(
  String $control_repo_url,
  String $control_repo_deploy_key,
  String $identity_key = '/etc/puppetlabs/r10k/ssh/control_private_key'
)
{
  
  file { '/etc/puppetlabs/r10k/ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  
  file { $identity_key:
    ensure  => 'present',
    mode    => '0400',
    content  => $control_repo_deploy_key,
    require => File['/etc/puppetlabs/r10k/ssh'],
  }

  $ssh_config_template = @(END)
Host $control_repo_host
StrictHostKeyChecking no
RSAAuthentication yes
IdentityFile $identity_key
User git
END

  file { '/root/.ssh/config':
    ensure  => 'present',
    mode    => '0400',
    content => inline_epp($ssh_config_template),
    require => File['/root/.ssh'],
  }


  file { '/root/.ssh':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  sshkey { 'Deploy key':
    ensure => present,
    target => '/root/.ssh/known_hosts',
    key    => $control_repo_deploy_key,
    require => File['/root/.ssh'],
  }

  class { '::r10k':
    sources => {
      'control' => {
        'remote'  => $control_repo_url,
        'basedir' => '/etc/puppetlabs/code/environments',
        'prefix'  => false,
      },
    },
  }
}


  


  
