class puppetmaster::databaseserver
(
  String $postgresql_version              = '9.6',
  Boolean $postgresql_manage_package_repo = true,
  String $postgresql_listen_address       = 'localhost',
  Integer $max_connections                = 300,
  String $contrib_package_name            = 'postgresql96-contrib',
)
{
  class { '::postgresql::globals':
    manage_package_repo => $postgresql_manage_package_repo,
    version             => $postgresql_version,
  }
  
  class { '::postgresql::server':
    listen_addresses => $postgresql_listen_address,
    require          => Class['::postgresql::globals']
  }                                                       
  
  ::postgresql::server::config_entry {'max_connections':
    value => $max_connections,
  }
}
