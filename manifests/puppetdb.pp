# Setup Puppetserver with PuppetDB
#
# == Parameters:
#
# $puppetdb_database_password:: Password for the puppetdb database in postgresql
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
# $puppetserver_allow_ipv4:: Allow connections to puppetserver from this IPv4 address or subnet. Example: '10.0.0.0/8'. Defaults to '127.0.0.1'.
#
# $puppetserver_allow_ipv6:: Allow connections to puppetserver from this IPv6 address or subnet. Defaults to '::1'.
#
# $server_reports:: Where to store reports. Defaults to 'store,puppetdb'.
#
# $server_external_nodes:: The path to the ENC executable. Defaults to empty string.
#
# $server_foreman:: Used internally in Foreman scenarios. Do not change the default (false) unless you know what you are doing.
#
# $show_diff:: Used internally in Foreman scenarios. Do not change the default (false) unless you know what you are doing.
#
# $provider:: Your git repository provider. Providers 'gitlab' (gitlab.com) and 'bitbucket' are fully supported, but this parameter can be any string: you just need to add the public SSH key of the Git server to /root/.ssh/known_hosts manually.
# 
# $repo_url:: The url to your control repository. Example: 'git@gitlab.com:mycompany/control-repo.git'
#
# $key_path:: The private key to use for accessing $repo_url. defaults to '/etc/puppetlabs/r10k/ssh/r10k_key'
# 
# $repo_host:: The fully qualified name of the $provider host. For example 'gitlab.com' or 'bitbucket.org'.
class puppetmaster::puppetdb
(
  String                   $puppetdb_database_password,
  String                   $timezone = 'Etc/UTC',
  Boolean                  $manage_packetfilter = false,
  String                   $puppetserver_allow_ipv4 = '127.0.0.1',
  String                   $puppetserver_allow_ipv6 = '::1',
  String                   $server_reports = 'store,puppetdb',
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Boolean                  $show_diff = false,
  Boolean                  $server_foreman = false,
  String                   $server_external_nodes = '',
  String                   $key_path = '/etc/puppetlabs/r10k/ssh/r10k_key',
  Boolean                  $control_repo = false,
  Optional[Array[String]]  $autosign_entries = undef,
  Optional[String]         $provider = undef,
  Optional[String]         $repo_url = undef,
  Optional[String]         $repo_host = undef,
)
{
  class { '::puppetmaster::puppetserver':
    manage_packetfilter     => $manage_packetfilter,
    puppetserver_allow_ipv4 => $puppetserver_allow_ipv4,
    puppetserver_allow_ipv6 => $puppetserver_allow_ipv6,
    server_reports          => $server_reports,
    autosign                => $autosign,
    autosign_entries        => $autosign_entries,
    timezone                => $timezone,
    show_diff               => $show_diff,
    server_foreman          => $server_foreman,
    server_external_nodes   => $server_external_nodes,
    provider                => $provider,
    key_path                => $key_path,
    control_repo            => $control_repo,
    repo_url                => $repo_url,
    repo_host               => $repo_host,
  }

  class { '::puppetdb':
    database_password => $puppetdb_database_password,
    ssl_deploy_certs  => true,
    database_validate => false,
  }

  class { '::puppetdb::master::config':
    puppetdb_server => $facts['fqdn'],
    restart_puppet  => true,
  }
}
