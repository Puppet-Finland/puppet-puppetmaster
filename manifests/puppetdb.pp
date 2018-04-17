# Setup Puppetserver with PuppetDB
#
# == Parameters:
#
# $primary_names:: Primary names for this machine
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
# $puppetdb_database_password:: Password for the puppetdb database in postgresql
#
class puppetmaster::puppetdb
(
  Array[String]            $primary_names,
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $puppetdb_database_password
)
{
  class { '::puppetmaster::puppetserver':
    primary_names    => $primary_names,
    autosign         => $autosign,
    autosign_entries => $autosign_entries,
  }

  class { '::puppetdb':
    database_password   => $puppetdb_database_password,
    ssl_deploy_certs    => true,
  }

  class { '::puppetdb::master::config':
    puppetdb_server     => 'localhost',
    restart_puppet      => true,
  }
}
