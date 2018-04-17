# A wrapper class for setting up puppetserver. Usable on Puppet servers as
# well as in Kafo installers.
#
# == Parameters:
#
# $primary_names:: Primary names for this machine
#
# $autosign:: Set up autosign entries. Set to true to enable naive autosigning.
#
# $autosign_entries:: List of autosign entries. Requires that autosign is pointing to the path of autosign.conf.
#
class puppetmaster::puppetserver
(
  Array[String]            $primary_names,
  Variant[Boolean, String] $autosign = '/etc/puppetlabs/puppet/autosign.conf',
  Optional[Array[String]]  $autosign_entries = undef,
)
{

  class { '::puppetmaster::common':
    primary_names => $primary_names,
  }

  class { '::puppet':
    server                => true,
    show_diff             => false,
    server_foreman        => false,
    autosign              => $autosign,
    autosign_entries      => $autosign_entries,
    server_external_nodes => '',
    additional_settings   => $additional_settings,
    server_reports        => 'store',
    require               => [ File['/etc/puppetlabs/puppet/fileserver.conf'], Puppet_authorization::Rule['files'] ],
  }
}
