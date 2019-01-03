# Common configurations for all scenarios
#
class puppetmaster::common
(
  Array[String]    $primary_names,
  String           $timezone,
  Boolean          $control_repo = false,
  Optional[String] $provider = undef,
  Optional[String] $repo_url = undef,
  Optional[String] $key_path = undef,
  Optional[String] $repo_host = undef,
)
{

  $packages = $facts['os']['name'] ? {
    'CentOS' => [],
    'Debian' => ['apt-transport-https'],
    'Ubuntu' => [],
  }

  ensure_packages($packages)

  package { 'hiera-eyaml':
    ensure   => 'present',
    provider => 'puppetserver_gem',
  }

  $eyaml_dir = '/etc/puppetlabs/puppet/eyaml'

  $eyaml_file_defaults = {
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { $eyaml_dir:
    ensure => 'directory',
    mode   => '0700',
    *      => $eyaml_file_defaults,
  }

  exec { 'create-eyaml-keys':
    user    => 'puppet',
    cwd     => $eyaml_dir,
    command => 'eyaml createkeys',
    path    => ['/opt/puppetlabs/puppet/lib/ruby/vendor_gems/bin'],
    creates => "${eyaml_dir}/private_key.pkcs7.pem",
    require => [ Package['hiera-eyaml'], File[$eyaml_dir] ],
  }

  file { ["${eyaml_dir}/private_key.pkcs7.pem","${eyaml_dir}/public_key.pkcs7.pem"]:
    mode    => '0600',
    require => Exec['create-eyaml-keys'],
    *       => $eyaml_file_defaults,
  }

  class { '::timezone':
    timezone => $timezone,
  }

  class { '::hosts':
    primary_names => $primary_names,
  }

  if $control_repo {

    class { '::puppetmaster::common::r10k':
      provider  => $provider,
      repo_url  => $repo_url,
      key_path  => $key_path,
      repo_host => $repo_host,
    }
  }
}
