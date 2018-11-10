notify { 'Installing puppetmaster': }

$installer_dir = '/usr/share/puppetmaster-installer'
$last_scenario = "${installer_dir}/config/installer-scenarios.d/last_scenario.yaml"
$install_cmd = "${installer_dir}/bin/puppetmaster-installer --scenario ${facts['scenario']} --dont-save-answers"

file { $last_scenario:
  ensure => 'absent',
}

exec { "Run puppetmaster scenario ${facts['scenario']}":
  cwd       => $installer_dir,
  logoutput => true,
  command   => $install_cmd,
  timeout   => 600,
  path      => ['/opt/puppetlabs/bin','/opt/puppetlabs/puppet/bin', '/bin', '/usr/bin'],
}
