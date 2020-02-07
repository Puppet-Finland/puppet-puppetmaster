notify { 'Running r10k': }

exec { 'Run r10k':
  cwd       => $::basedir,
  logoutput => true,
  command   => 'r10k puppetfile install --moduledir=modules --force',
  timeout   => 600,
  path      => ['/bin','/usr/bin','/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin'],
}

