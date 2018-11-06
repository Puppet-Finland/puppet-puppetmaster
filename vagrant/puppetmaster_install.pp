notify { 'Installing puppetmaster': }

$installer_dir = '/usr/share/puppetmaster-installer'
$last_scenario = "${installer_dir}/config/installer-scenarios.d/last_scenario.yaml"
$install_cmd = "${installer_dir}/bin/puppetmaster-installer --scenario puppetserver --puppetmaster-puppetserver-autosign=true --puppetmaster-puppetserver-timezone='Europe/Helsinki'"

file { $last_scenario:
  ensure => 'absent',
}

exec { 'Setup vanilla puppetserver':
  cwd       => $installer_dir,
  logoutput => true,
  command   => $install_cmd,
  timeout   => 600,
  path      => ['/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin', '/bin', '/usr/bin'],
}
