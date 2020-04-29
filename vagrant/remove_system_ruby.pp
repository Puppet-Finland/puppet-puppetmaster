case $facts['os']['codename'] {
  /(xenial|bionic)/: { package { 'ruby': ensure => 'absent' } }
  default: { }
}

