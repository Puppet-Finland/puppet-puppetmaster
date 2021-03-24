#
# @summary settings based on operating system
#
class puppetmaster::params {

  # From Debian 8 onwards (and on recent Ubuntu versions) use conf-enabled 
  # instead of conf.d dir. puppetlabs-apache module does not follow this 
  # convention, and config files are not read from the correct place.
  #
  # https://tickets.puppetlabs.com/browse/MODULES-5990
  # https://tickets.puppetlabs.com/browse/MODULES-3116
  #
  case $::osfamily {
    'Debian': {
      $apache_conf_dir    = '/etc/apache2'
      $apache_confd_dir   = "${apache_conf_dir}/conf-enabled"
      $seltype            = undef
      $wsgi_socket_prefix = undef
      if $::lsbdistcodename == 'focal' {
        $wsgi_package_name = 'libapache2-mod-wsgi-py3'
        $wsgi_mod_path     = '/usr/lib/apache2/modules/mod_wsgi.so'
      } else {
        $wsgi_package_name = undef
        $wsgi_mod_path     = undef
      }
    }
    'RedHat': {
      $apache_conf_dir    = '/etc/httpd'
      $apache_confd_dir   = "${apache_conf_dir}/conf.d"
      $seltype            = 'httpd_sys_content_t'
      $wsgi_mod_path      = undef
      $wsgi_package_name  = undef
      $wsgi_socket_prefix = '/var/run/wsgi'
    }
    default: {
      $apache_conf_dir    = '/etc/httpd'
      $apache_confd_dir   = "${apache_conf_dir}/conf.d"
      $seltype            = undef
      $wsgi_mod_path      = undef
      $wsgi_package_name  = undef
      $wsgi_socket_prefix = undef
    }
  }
}
