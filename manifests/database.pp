#
define puppetmaster::database
(
  String $dbname,
  String $username,
  String $password,
  Boolean $extension_trgm = false
)
{

  $contrib_package_name = 'postgresql96-contrib'
  $connection_limit     = '300'

  ::postgresql::server::role { $dbname:
    password_hash    => postgresql_password($username, $password),
    connection_limit => $connection_limit,
  }

  ::postgresql::server::database_grant { "Grant all to ${username}":
    privilege => 'ALL',
    db        => $dbname,
    role      => $username,
  }

  ::postgresql::server::db { $dbname:
    user     => $username,
    password => postgresql_password($username, $password),
  }

  if $extension_trgm {

    ::postgresql::server::extension { 'Add trgm':
      database     => $dbname,
      package_name => $contrib_package_name,
      extension    => 'pg_trgm',
      require      => Class['::postgresql::server']
    }
  }
}
