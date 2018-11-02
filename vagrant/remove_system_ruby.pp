case $::lsbdistcodename {
  /(xenial|bionic)/: { package { 'ruby': ensure => 'absent' } }
  default: { }
}
