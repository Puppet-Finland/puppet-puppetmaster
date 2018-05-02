# Class to setup Foreman smart proxy
#
# == Parameters:
#
# $foreman_proxy_foreman_base_url:: XXX
#
# $foreman_proxy_templates:: XXX
#
# $foreman_proxy_templates_listen_on:: XXX
#
# $foreman_proxy_trusted_hosts:: XXX
#
# $foreman_proxy_dhcp:: XXX
#
# $foreman_proxy_dhcp_listen_on:: XXX
#
# $foreman_proxy_dns:: XXX
#
# $foreman_proxy_dhcp_managed:: XXX
#
# $foreman_proxy_dhcp_interface:: XXX
#
# $foreman_proxy_dhcp_option_domain:: XXX
#
# $foreman_proxy_dhcp_search_domains:: XXX
#
# $foreman_proxy_dhcp_server:: XXX
#
# $foreman_proxy_dhcp_provider:: XXX
#
# $foreman_proxy_dhcp_subnets:: XXX
#
# $foreman_proxy_dhcp_gateway:: XXX
#
# $foreman_proxy_dhcp_range:: XXX
#
# $foreman_proxy_dhcp_nameservers:: XXX
#
# $foreman_proxy_dhcp_pxeserver:: XXX
#
# $foreman_proxy_dns_managed:: XXX
#
# $foreman_proxy_dns_forwarders:: XXX
#
# $foreman_proxy_dns_interface:: XXX
#
# $foreman_proxy_dns_listen_on:: XXX
#
# $foreman_proxy_dns_provider:: XXX
#
# $foreman_proxy_dns_zone:: XXX
#
# $foreman_proxy_dns_reverse:: XXX
#
# $foreman_proxy_dns_server:: XXX
#
# $foreman_proxy_dns_ttl:: XXX
#
# $foreman_proxy_tftp:: XXX
#
# $foreman_proxy_tftp_managed:: XXX
#
# $foreman_proxy_tftp_servername:: XXX
#
# $foreman_proxy_tftp_manage_wget:: XXX
#
# $foreman_proxy_tftp_listen_on:: XXX
#
# $foreman_proxy_bmc:: XXX
#
# $foreman_proxy_bmc_listen_on:: XXX
#
# $primary_names:: Primary names for this machine. Example: ['puppet.local', 'puppet' ]
#
# $timezone:: The timezone the server wants to be located in. Example: 'Europe/Helsinki'
#
# == Advanced parameters:
#
class puppetmaster::foreman_proxy
(
  
  String $foreman_proxy_foreman_base_url,
  Boolean $foreman_proxy_templates,
  String $foreman_proxy_templates_listen_on,
  Array[String] $foreman_proxy_trusted_hosts,
  Boolean $foreman_proxy_dhcp,
  String $foreman_proxy_dhcp_listen_on,
  Boolean $foreman_proxy_dns,
  Boolean $foreman_proxy_dhcp_managed,
  String $foreman_proxy_dhcp_interface,
  Array[String] $foreman_proxy_dhcp_option_domain,
  Array[String] $foreman_proxy_dhcp_search_domains,
  String $foreman_proxy_dhcp_server,
  String $foreman_proxy_dhcp_provider,
  Array[String] $foreman_proxy_dhcp_subnets,
  String $foreman_proxy_dhcp_gateway,
  String $foreman_proxy_dhcp_range,
  String $foreman_proxy_dhcp_nameservers,
  String $foreman_proxy_dhcp_pxeserver,
  Boolean $foreman_proxy_dns_managed,
  Array[String] $foreman_proxy_dns_forwarders,
  String $foreman_proxy_dns_interface,
  String $foreman_proxy_dns_listen_on,
  String $foreman_proxy_dns_provider,
  String $foreman_proxy_dns_zone,
  String $foreman_proxy_dns_reverse,
  String $foreman_proxy_dns_server,
  Integer $foreman_proxy_dns_ttl,
  Boolean $foreman_proxy_tftp,
  Boolean $foreman_proxy_tftp_managed,
  String $foreman_proxy_tftp_servername,
  Boolean $foreman_proxy_tftp_manage_wget,
  String $foreman_proxy_tftp_listen_on,
  Boolean $foreman_proxy_bmc,
  String $foreman_proxy_bmc_listen_on,
  
)
{
  if defined(Service['foreman::service']) {
    service { 'foreman::service':
      ensure => running,
    }
  }

  $primary_names = [ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ]
  $foreman_proxy_registered_name = 'puppet.local'
  $foreman_proxy_repo = '1.16'
  $foreman_proxy_version = '1.16.0'
  $foreman_proxy_bind_host = '0.0.0.0'
  $foreman_proxy_register_in_foreman = true
  $foreman_proxy_registered_proxy_url = 'https://puppet.local:8443'
  $foreman_proxy_ensure_packages_version = 'installed'
  $foreman_proxy_template_url = 'http://puppet.local:8000'
  $foreman_proxy_manage_sudoersd = true
  $foreman_proxy_use_sudoers = true
  $foreman_proxy_use_sudoersd = true
  # puppet
  $foreman_proxy_puppet = true
  $foreman_proxy_autosignfile = '/etc/puppetlabs/puppet/autosign.conf'
  $foreman_proxy_puppet_url = 'https://puppet.local:8140'
  $foreman_proxy_puppet_use_environment_api = true
  $foreman_proxy_puppet_use_cache = true
  # puppetca settings
  $foreman_proxy_puppetca = true
  $foreman_proxy_puppetca_listen_on = https
  $foreman_proxy_puppetca_cmd = '/opt/puppetlabs/bin/puppet cert'
  # puppetrun settings
  $foreman_proxy_puppet_listen_on = https
  $foreman_proxy_puppetrun_cmd = puppetssh
  $foreman_proxy_puppetrun_provider = puppetssh
  $foreman_proxy_mcollective_user = root
  $foreman_proxy_puppetssh_sudo = true

  @firewall { '22 accept outgoing foreman-proxy remote ssh execution':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  if ($foreman_proxy_dns) {

    @firewall { '53 allow incoming dns tcp':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => '53',
      proto  => 'tcp',
      action => 'accept',
    }

    firewall { '53 allow incoming dns udp':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => '53',
      proto  => 'udp',
      action => 'accept',
    }

  }

  if ($foreman_proxy_dhcp) {

    @firewall { '6768 allow incoming dhcp':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => [ '67', '68'],
      proto  => 'tcp',
      action => 'accept',
    }

  }

  if ($foreman_proxy_tftp_managed) {

    @firewall { '80 allow incoming kickstart request':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => '80',
      proto  => 'tcp',
      action => 'accept',
    }

    @firewall { '103 allow incoming tftp':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => '69',
      proto  => 'udp',
      action => 'accept',
    }

  }

  if ($foreman_proxy_templates) {

    cron { 'Sync Foreman community templates':
      environment => 'PATH=/opt/puppetlabs/bin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
      command     => 'foreman-rake templates:sync',
      user        => 'root',
      hour        => '0',
      minute      => '0',
    }
  }

  firewall { '8140 allow foreman proxy incoming puppet':
    chain  => 'INPUT',
    state  => ['NEW'],
    dport  => '8140',
    proto  => 'tcp',
    action => 'accept',
  }

  unless defined(Class['::puppetmaster::common']) {
    
    class { '::puppetmaster::common':
      primary_names => $primary_names,
      timezone      => $timezone, 
      before        => Class['::foreman'],
    }
  }


  class { '::foreman_proxy':
    version                 => $foreman_proxy_version,
    ensure_packages_version => $foreman_proxy_ensure_packages_version,
    repo                    => $foreman_proxy_repo,
    registered_name         => $foreman_proxy_registered_name,
    registered_proxy_url    => $foreman_proxy_registered_proxy_url,
    foreman_base_url        => $foreman_proxy_foreman_base_url,
    trusted_hosts           => $foreman_proxy_trusted_hosts,
    bind_host               => $foreman_proxy_bind_host,
    puppet                  => $foreman_proxy_puppet,
    puppet_use_cache        => $foreman_proxy_puppet_use_cache,
    puppetca                => $foreman_proxy_puppetca,
    puppetca_cmd            => $foreman_proxy_puppetca_cmd,
    tftp                    => $foreman_proxy_tftp,
    tftp_managed            => $foreman_proxy_tftp_managed,
    tftp_manage_wget        => $foreman_proxy_tftp_manage_wget,
    dhcp_managed            => $foreman_proxy_dhcp_managed,
    dhcp                    => $foreman_proxy_dhcp,
    dhcp_listen_on          => $foreman_proxy_dhcp_listen_on,
    dhcp_interface          => $foreman_proxy_dhcp_interface,
    dhcp_subnets            => $foreman_proxy_dhcp_subnets,
    dhcp_gateway            => $foreman_proxy_dhcp_gateway,
    dhcp_range              => $foreman_proxy_dhcp_range,
    dhcp_nameservers        => $foreman_proxy_dhcp_nameservers,
    dhcp_option_domain      => $foreman_proxy_dhcp_option_domain,
    dhcp_search_domains     => $foreman_proxy_dhcp_search_domains,
    dns                     => $foreman_proxy_dns,
    dns_managed             => $foreman_proxy_dns_managed,
    dns_interface           => $foreman_proxy_dns_interface,
    dns_zone                => $foreman_proxy_dns_zone,
    dns_forwarders          => $foreman_proxy_dns_forwarders,
    dns_ttl                 => $foreman_proxy_dns_ttl,
    dns_reverse             => $foreman_proxy_dns_reverse,
    bmc                     => $foreman_proxy_bmc,
    bmc_listen_on           => $foreman_proxy_bmc_listen_on,
    templates               => $foreman_proxy_templates,
    templates_listen_on     => $foreman_proxy_templates_listen_on,
    template_url            => $foreman_proxy_template_url,
    tftp_servername         => $foreman_proxy_tftp_servername,
    manage_sudoersd         => $foreman_proxy_manage_sudoersd,
    use_sudoersd            => $foreman_proxy_use_sudoersd,
    use_sudoers             => $foreman_proxy_use_sudoers,
    register_in_foreman     => $foreman_proxy_register_in_foreman,
    autosignfile            => $foreman_proxy_autosignfile,
  }
}
