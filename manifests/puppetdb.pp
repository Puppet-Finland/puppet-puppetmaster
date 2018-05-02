# Setup Puppetserver with PuppetDB
#
# == Parameters:
#
# $server_reports:: Where to store reports. Defaults to 'store,puppetdb'.
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
# $puppetdb_database_password:: Password for the puppetdb database in postgresql
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki' or 'Etc/UTC'.
class puppetmaster::puppetdb
(
  String                   $server_reports = 'store,puppetdb',
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $puppetdb_database_password,
  String                   $timezone 
)
{

  $primary_names = [ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ]

  class { '::puppetmaster::puppetserver':
    server_reports   => $server_reports,
    autosign         => $autosign,
    autosign_entries => $autosign_entries,
    timezone         => $timezone, 
  }

  class { '::puppetdb':
    database_password => $puppetdb_database_password,
    ssl_deploy_certs  => true,
    database_validate => false,
  }

  class { '::puppetdb::master::config':
    puppetdb_server     => $facts['fqdn'],
    restart_puppet      => true,
  }
}
