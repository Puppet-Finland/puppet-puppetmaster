# A wrapper class for setting up puppetserver. Usable on Puppet servers as
# well as in Kafo installers.
#
# == Parameters:
#
# $server_reports:: Where to store reports. Defaults to 'store'.
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki'
class puppetmaster::puppetserver
(
  String                   $server_reports = 'store',
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Optional[Array[String]]  $autosign_entries = undef,
  String                   $timezone,
)

{

  $primary_names = [ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ]  

  unless defined(Class['::puppetmaster::common']) {
    
    class { '::puppetmaster::common':
      primary_names => $primary_names,
      timezone      => $timezone, 
   }
  }
  
  class { '::puppet':
    server                => true,
    show_diff             => false,
    server_foreman        => false,
    autosign              => $autosign,
    autosign_entries      => $autosign_entries,
    server_external_nodes => '',
    server_reports        => $server_reports,
    require               => [ File['/etc/puppetlabs/puppet/fileserver.conf'], Puppet_authorization::Rule['files'] ],
  }
}
