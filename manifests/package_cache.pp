#
# Update package cache on Debian/Ubuntu to avoid installer failures due to
# missing packages
#
class puppetmaster::package_cache {

  if $::osfamily == 'Debian' {
    exec { 'update apt cache':
      command   => 'apt-get update',
      path      => ['/bin','/usr/bin'],
      logoutput => true,
    }
  }
}
