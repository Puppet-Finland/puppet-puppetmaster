# Reboot host
#
# == Parameters:
#
# apply:: When to apply the reboot
class puppetmaster::reboot
(
  Enum['immediately', 'finished'] $apply,
)
{

  exec { 'About to reboot':
    command => '/bin/true',
  }

  reboot { 'reboot after':
    subscribe => Exec['About to reboot'],
    apply     => $apply,
    message   => 'Host rebooted by puppetmaster-installer',
  }
}
