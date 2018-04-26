# A class to setup puppetserver with puppetdb and puppetboard
# == Parameters:
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki'
# 
# $puppetdb_database_password:: Database password for puppetdb
class puppetmaster::puppetboard
(
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $timezone,
  String                   $puppetdb_database_password,
)
{

  $puppetboard_puppetdb_host              = "${facts['fqdn']}"
  $puppetboard_puppetdb_port              = 8081
  $primary_names                          = unique([ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ])
  $puppetboard_puppetdb_dashboard_address = "http://${facts['fqdn']}:8080/pdb/dashboard"
  $puppetboard_puppetdb_address           = "https://${facts['fqdn']}:8081/v2/commands"
  $puppetdb_server                        = $facts['fqdn']
  $puppetboard_manage_git                 = true
  $puppetboard_manage_virtualenv          = true
  $puppetboard_reports_count              = 40
  $puppetboard_puppetdb_key               = "${::settings::ssldir}/private_keys/${puppetboard_certname}.pem"
  $puppetboard_puppetdb_ssl_verify        = "${::settings::ssldir}/certs/ca.pem"
  $puppetboard_puppetdb_cert              = "${::settings::ssldir}/certs/${puppetboard_certname}.pem"
  $puppetboard_groups                     = 'puppet'
  # Copy over Puppet keys to a place where Puppetboard can access them
  $puppet_ssldir                          = '/etc/puppetlabs/puppet/ssl'
  $puppetboard_config_dir                 = '/etc/puppetlabs/puppetboard'
  $puppetboard_ssl_dir                    = "${puppetboard_config_dir}/ssl"
  $puppetdb_cert                          = "${puppetboard_ssl_dir}/${::fqdn}.crt"
  $puppetdb_key                           = "${puppetboard_ssl_dir}/${::fqdn}.key"
  $puppetdb_ca_cert                       = "${puppetboard_ssl_dir}/ca.pem"


  unless defined(Class['::puppetmaster::common']) {
    
    class { '::puppetmaster::common':
      primary_names => $primary_names,
      timezone      => $timezone, 
      before        => Class['::puppetboard'],
    }
  }

  class { '::puppetmaster::puppetdb':
    autosign                   => false,
    autosign_entries           => undef,
    puppetdb_database_password => $puppetdb_database_password,
    timezone                   => $timezone, 
  }  
  
  file { [ $puppetboard_config_dir, $puppetboard_ssl_dir ]:
    ensure  => directory,
    owner   => 'root',
    group   => 'puppetboard',
    mode    => '0750',
    require => Class['::puppetmaster::puppetdb'],
  }

  $keys = { "${puppet_ssldir}/certs/${::fqdn}.pem" => $puppetdb_cert,
  "${puppet_ssldir}/private_keys/${::fqdn}.pem"    => $puppetdb_key,
  "${puppet_ssldir}/certs/ca.pem"                  => $puppetdb_ca_cert, }

  $keys.each |$key| {
    exec { $key[1]:
      command => "cp -f ${key[0]} ${key[1]}",
      unless  => "cmp ${key[0]} ${key[1]}",
      path    => ['/bin', '/usr/bin/' ],
      require => File[$puppetboard_ssl_dir],
    }

    file { $key[1]:
      group   => 'puppetboard',
      mode    => '0640',
      require => Exec[$key[1]],
    }
  }

  class { '::apache':
    purge_configs => true,
    mpm_module    => 'prefork',
    default_vhost => true,
    default_mods  => false,
  }

  unless "${facts['osfamily']}" == 'RedHat' {

    class { 'apache::mod::wsgi': }
  }
  else {

    class { 'apache::mod::wsgi':
      wsgi_socket_prefix => "/var/run/wsgi"
    }
  }

  class { '::puppetboard':
    groups              => $puppetboard_groups,
    puppetdb_host       => $puppetboard_puppetdb_host,
    puppetdb_port       => $puppetboard_puppetdb_port,
    manage_git          => $puppetboard_manage_git,
    manage_virtualenv   => $puppetboard_manage_virtualenv, 
    reports_count       => $puppetboard_reports_count,
    puppetdb_key        => $puppetdb_cert,
    puppetdb_ssl_verify => $puppetdb_ca_cert,
    puppetdb_cert       => $puppetdb_cert,
  }
  
  class { 'puppetboard::apache::conf': }
}
