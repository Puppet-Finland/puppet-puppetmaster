# Setup Puppetserver, PuppetDB and Puppetboard
#
# == Parameters:
#
# $puppetdb_database_password:: Password for the puppetdb database in postgresql
#
# $puppetboard_password:: Password for Puppetboard
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki' or 'Etc/UTC'.
#
# $control_repo:: Enable control repo. You MUST also set up $provider, $repo_url, $key_path and $repo_host
#                 in Advanced parameters to use this functionality. Defaults to false.
# == Advanced parameters:
#
# $manage_packetfilter:: Manage IPv4 and IPv6 rules. Defaults to false.
#
# $puppetboard_require_auth:: Require basic authentication in Puppetboard. Defaults to true, as Puppetboard exposes lots of information about your infrastructure and should not be accessible to anyone, not even internally within an organization or a network. So, you _should not_ disable this unless you are going to limit access to Puppetboard by some other means such as IP-based filtering or by using some other form of authentication.
#
# $puppetboard_username:: Username for accessing Puppetboard. Defaults to 'admin'.
#
# $puppetserver_allow_ipv4:: Allow connections to puppetserver from this IPv4 address or subnet. Example: '10.0.0.0/8'. Defaults to '127.0.0.1'.
#
# $puppetserver_allow_ipv6:: Allow connections to puppetserver from this IPv6 address or subnet. Defaults to '::1'.
#
# $server_reports:: Where to store reports. Defaults to 'store,puppetdb'.
#
# $server_external_nodes:: The path to the ENC executable. Defaults to empty string.
#
# $provider:: Your git repository provider. Providers 'gitlab' (gitlab.com) and 'bitbucket' are fully supported, but this parameter can be any string: you just need to add the public SSH key of the Git server to /root/.ssh/known_hosts manually.
# 
# $repo_url:: The url to your control repository. Example: 'git@gitlab.com:mycompany/control-repo.git'
#
# $key_path:: The private key to use for accessing $repo_url. defaults to '/etc/puppetlabs/r10k/ssh/r10k_key'
# 
# $repo_host:: The fully qualified name of the $provider host. For example 'gitlab.com' or 'bitbucket.org'.
class puppetmaster::puppetboard
(
  String                   $puppetdb_database_password,
  String                   $puppetboard_password,
  Boolean                  $puppetboard_require_auth = true,
  String                   $puppetboard_username = 'admin',
  String                   $timezone = 'Etc/UTC',
  Boolean                  $manage_packetfilter = false,
  String                   $puppetserver_allow_ipv4 = '127.0.0.1',
  String                   $puppetserver_allow_ipv6 = '::1',
  String                   $server_reports = 'store,puppetdb',
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  String                   $server_external_nodes = '',
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $key_path = '/etc/puppetlabs/r10k/ssh/r10k_key',
  Boolean                  $control_repo = false,
  Optional[String]         $provider = undef,
  Optional[String]         $repo_url = undef,
  Optional[String]         $repo_host = undef,
)
{
  # From Debian 8 onwards (and on recent Ubuntu versions) use conf-enabled 
  # instead of conf.d dir. puppetlabs-apache module does not follow this 
  # convention, and config files are not read from the correct place.
  #
  # https://tickets.puppetlabs.com/browse/MODULES-5990
  # https://tickets.puppetlabs.com/browse/MODULES-3116
  #
  case $::osfamily {
    'Debian': {
      $apache_conf_dir = '/etc/apache2'
      $apache_confd_dir = "${apache_conf_dir}/conf-enabled" }
    'RedHat': {
      $apache_conf_dir = '/etc/httpd'
      $apache_confd_dir = "${apache_conf_dir}/conf.d" }
    default: {
      $apache_conf_dir = '/etc/httpd'
      $apache_confd_dir = "${apache_conf_dir}/conf.d" }
  }

  include ::puppetmaster::package_cache

  $puppetboard_puppetdb_host              = $facts['fqdn']
  $puppetboard_puppetdb_port              = 8081
  $puppetboard_puppetdb_dashboard_address = "http://${facts['fqdn']}:8080/pdb/dashboard"
  $puppetboard_puppetdb_address           = "https://${facts['fqdn']}:8081/v2/commands"
  $puppetdb_server                        = $facts['fqdn']
  $puppetboard_manage_git                 = true
  $puppetboard_manage_virtualenv          = true
  $puppetboard_reports_count              = 40
  $puppetboard_puppetdb_key               = "${::settings::ssldir}/private_keys/${::fqdn}.pem"
  $puppetboard_puppetdb_ssl_verify        = "${::settings::ssldir}/certs/ca.pem"
  $puppetboard_puppetdb_cert              = "${::settings::ssldir}/certs/${::fqdn}.pem"
  $puppetboard_groups                     = 'puppet'
  # Copy over Puppet keys to a place where Puppetboard can access them
  $puppet_ssldir                          = '/etc/puppetlabs/puppet/ssl'
  $puppetboard_config_dir                 = '/etc/puppetlabs/puppetboard'
  $puppetboard_htpasswd_file              = "${apache_conf_dir}/puppetboard.htpasswd"
  $puppetboard_ssl_dir                    = "${puppetboard_config_dir}/ssl"
  $puppetdb_cert                          = "${puppetboard_ssl_dir}/${::fqdn}.crt"
  $puppetdb_key                           = "${puppetboard_ssl_dir}/${::fqdn}.key"
  $puppetdb_ca_cert                       = "${puppetboard_ssl_dir}/ca.pem"

  class { '::puppetmaster::puppetdb':
    manage_packetfilter        => $manage_packetfilter,
    puppetserver_allow_ipv4    => $puppetserver_allow_ipv4,
    puppetserver_allow_ipv6    => $puppetserver_allow_ipv6,
    server_reports             => $server_reports,
    autosign                   => $autosign,
    autosign_entries           => $autosign_entries,
    puppetdb_database_password => $puppetdb_database_password,
    timezone                   => $timezone,
    server_external_nodes      => $server_external_nodes,
    provider                   => $provider,
    key_path                   => $key_path,
    control_repo               => $control_repo,
    repo_url                   => $repo_url,
    repo_host                  => $repo_host,
    before                     => Class['::puppetboard'],
  }

  file { [ $puppetboard_config_dir, $puppetboard_ssl_dir ]:
    ensure  => directory,
    owner   => 'root',
    group   => 'puppetboard',
    mode    => '0750',
    require => Class['::puppetboard'],
  }

  $keys = { "${puppet_ssldir}/certs/${::fqdn}.pem" => $puppetdb_cert,
  "${puppet_ssldir}/private_keys/${::fqdn}.pem"    => $puppetdb_key,
  "${puppet_ssldir}/certs/ca.pem"                  => $puppetdb_ca_cert, }

  # Allow httpd to read Puppetboard's SSL keys
  if $::osfamily == 'RedHat' {
    $seltype = 'httpd_sys_content_t'
  } else {
    $seltype = undef
  }

  $keys.each |$key| {
    exec { $key[1]:
      command => "cp -f ${key[0]} ${key[1]}",
      unless  => "cmp ${key[0]} ${key[1]}",
      path    => ['/bin', '/usr/bin/' ],
      require => [ Class['::puppetmaster::puppetserver'], File[$puppetboard_ssl_dir] ],
    }

    file { $key[1]:
      group   => 'puppetboard',
      mode    => '0640',
      seltype => $seltype,
      require => Exec[$key[1]],
    }
  }

  class { '::apache':
    purge_configs     => true,
    mpm_module        => 'prefork',
    default_vhost     => true,
    default_ssl_vhost => true,
    default_mods      => false,
    confd_dir         => $apache_confd_dir,
  }

  if $facts['osfamily'] == 'RedHat' {
    include ::apache::mod::version

    class { '::apache::mod::wsgi':
      wsgi_socket_prefix => '/var/run/wsgi'
    }

  }
  else {
    class { '::apache::mod::wsgi': }
  }

  class { '::puppetboard':
    # puppet-puppetboard clones puppetboard from Git, so we need to specify a known-good version
    revision            => 'v2.0.0',
    groups              => $puppetboard_groups,
    puppetdb_host       => $puppetboard_puppetdb_host,
    puppetdb_port       => $puppetboard_puppetdb_port,
    manage_git          => $puppetboard_manage_git,
    manage_virtualenv   => $puppetboard_manage_virtualenv,
    reports_count       => $puppetboard_reports_count,
    puppetdb_key        => $puppetdb_key,
    puppetdb_ssl_verify => $puppetdb_ca_cert,
    puppetdb_cert       => $puppetdb_cert,
    require             => Class['::puppet'],
  }

  class { '::puppetboard::apache::conf': }

  if $puppetboard_require_auth {
    include ::apache::mod::auth_basic
    include ::apache::mod::authn_core
    include ::apache::mod::authn_file
    include ::apache::mod::authz_user

    file { "${apache_confd_dir}/puppetboard-basic-auth.conf":
      ensure  => 'present',
      content => template('puppetmaster/puppetboard-basic-auth.conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Class['::apache::service'],
    }

    # Create basic auth user and set password as needed. Note that if either
    # the username or password changes the file is recreated (see "man htpasswd").
    exec { 'set-puppetdb-password':
      command   => "echo ${puppetboard_password}|htpasswd -i -c ${puppetboard_htpasswd_file} ${puppetboard_username}",
      unless    => "echo ${puppetboard_password}|htpasswd -i -v ${puppetboard_htpasswd_file} ${puppetboard_username}",
      path      => ['/bin','/usr/bin'],
      logoutput => false,
    }

  } else {
    # If we could easily ensure that the above modules are disabled we would
    # do that. But we can't, not at least in a cross-platform way. So we just
    # get rid of the config file to disable authentication itself.
    file { "${apache_confd_dir}/puppetboard-basic-auth.conf":
      ensure => 'absent',
      notify => Class['::apache::service'],
    }

    file { $puppetboard_htpasswd_file:
      ensure => 'absent',
    }
  }

  if $manage_packetfilter {
    @firewall { '00443 accept tls traffic to puppetserver':
      dport  => '443',
      proto  => 'tcp',
      action => 'accept',
      tag    => 'default',
    }
  }
}
