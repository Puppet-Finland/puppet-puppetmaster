# Common configurations for all scenarios
#
class puppetmaster::common
(
  Array[String] $primary_names,
  String        $timezone,
  Hash          $hosts_entries = {},
)
{

  $packages = $facts['os']['name'] ? {
    'CentOS' => [],
    'Debian' => ['apt-transport-https'],
    'Ubuntu' => [],
  }
  
  ensure_packages($packages)

  class { '::timezone':
    timezone => $timezone,
  }

  if empty($hosts_entries) {

    class { '::hosts':
      primary_names => $primary_names,
    }
  }
  else {
    
    class { '::hosts':
      primary_names => $primary_names,
      entries       => $valid_hosts_entries,
    }
  }
}
