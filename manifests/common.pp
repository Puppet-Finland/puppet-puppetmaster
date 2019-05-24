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
  $eyaml_keys_dir = "${eyaml_dir}/keys"

  $eyaml_file_defaults = {
    owner  => 'puppet',
    group  => 'puppet',
  }

  file { $eyaml_dir:
    ensure => 'directory',
    mode   => '0700',
    *      => $eyaml_file_defaults,
  }

  file { $eyaml_keys_dir:
    ensure  => 'directory',
    mode    => '0700',
    require => File[$eyaml_dir],
    *       => $eyaml_file_defaults,
  }

  # For simplicity always create the eyaml keys, even if they get overwritten
  # by user-defined keys in the next step.
  exec { 'create-eyaml-keys':
    user    => 'puppet',
    cwd     => $eyaml_dir,
    command => 'eyaml createkeys',
    path    => ['/opt/puppetlabs/puppet/lib/ruby/vendor_gems/bin'],
    creates => "${eyaml_dir}/private_key.pkcs7.pem",
    require => [ Package['hiera-eyaml'], File[$eyaml_dir] ],
  }

  # If user has added eyaml keys into the installer directory copy them over.
  # Even if keys are not there, ensure that their permissions are correct
  ['private_key.pkcs7.pem','public_key.pkcs7.pem'].each |$eyaml_key| {
    $installer_dir = '/usr/share/puppetmaster-installer'

    exec { "copy-eyaml-key-${eyaml_key}":
      cwd     => $installer_dir,
      command => "test -r ${eyaml_key} && cp -v ${eyaml_key} ${eyaml_keys_dir} || true",
      path    => ['/bin','/sbin','/usr/bin','/usr/sbin'],
      require => Exec['create-eyaml-keys'],
    }

    file { "${eyaml_keys_dir}/${eyaml_key}":
      mode    => '0600',
      require => Exec["copy-eyaml-key-${eyaml_key}"],
      *       => $eyaml_file_defaults,
    }
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
