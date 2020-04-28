notify { 'Running r10k': }

$installer_dir = '/usr/share/puppetmaster-installer'

exec { 'Run r10k':
  cwd       => $::basedir,
  logoutput => true,
  command   => 'r10k puppetfile install --moduledir=modules --force',
  timeout   => 600,
  path      => ['/bin','/usr/bin','/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin'],
}

notify { 'Ensuring symbolic link is present': }

file { "${installer_dir}/modules/puppetmaster":
  ensure => 'link',
  target => $installer_dir,
}
