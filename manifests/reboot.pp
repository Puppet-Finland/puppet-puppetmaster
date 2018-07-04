# Relabel and Reboot host
#
# == Parameters:
#
# apply:: When to apply the reboot
class puppetmaster::reboot
(
  Enum['immediately', 'finished'] $apply,
)
{

  $message = 'Puppetmaster-installer is rebooting this system'

  unless ($facts['osfamily'] == 'RedHat' and $facts['os']['release']['major'] == '7') {
    fail("${facts['os']['name']} ${facts['os']['release']['full']} not supported yet")
  }

  class { '::selinux':
    mode => 'enforcing',
    type => 'targeted',
  }

  selinux::module { 'httpd_t':
    ensure    => 'present',
    source_te => '/usr/share/puppetmaster-installer/files/httpd_t.te',
    builder   => 'simple',
  }

  exec { 'Relabel':
    command => '/bin/touch /.autorelabel',
    require => Selinux::Module['httpd_t'],
  }

  reboot { 'Reboot after relabel':
    subscribe => Exec['Relabel'],
    apply     => $apply,
    message   => $message,
  }
}
