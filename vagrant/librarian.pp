notify { 'Installing librarian-puppet': }

package { 'librarian-puppet':
  ensure   => latest,
  provider => 'puppet_gem',
}

notify { 'Running librarian-puppet': }

exec { 'Run librarian-puppet':
  cwd       => "${::basedir}",
  logoutput => true,
  command   => 'librarian-puppet install --verbose',
  timeout   => 600,
  path      => ['/bin','/usr/bin','/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin'],
}

