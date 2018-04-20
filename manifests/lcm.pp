# 
# Class to setup Foreman 
#
# == Parameters:
#
# $foreman_db_password:: XXX
#
# $foreman_admin_firstname:: XXX
#
# $foreman_admin_lastname:: XXX
# 
# $foreman_admin_email:: XXX
#
# $foreman_admin_password:: XXX
#
# $puppetdb_database_password:: XXX
#
# $timezone:: Example: 'Europe/Helsinki'
#
# $foreman_plugin_cockpit:: XXX
#
# $foreman_compute_vmware:: XXX
#
# $foreman_compute_libvirt:: XXX
#
# $foreman_compute_ec2:: XXX
#
# $foreman_compute_gce:: XXX
#
# $foreman_compute_openstack:: XXX
#
# $foreman_compute_ovirt:: XXX
#
# $foreman_compute_rackspace:: XXX
#
# $foreman_plugin_azure:: Enable support for Microsoft Azure computing
#
# $foreman_plugin_ansible:: XXX
#
# $foreman_plugin_docker:: XXX
#
# $foreman_plugin_bootdisk:: XXX
# 
# $foreman_plugin_default_hostgroup:: XXX
#
# $foreman_plugin_dhcp_browser:: XXX
#
# $foreman_plugin_digitalocean:: XXX
#
# $foreman_plugin_discovery:: XXX
#
# $foreman_plugin_hooks:: XXX
#
# $foreman_plugin_memcache:: XXX
#
# $foreman_plugin_remote_execution:: XXX
#
# $foreman_plugin_tasks:: XXX
#
# $foreman_plugin_templates:: XXX
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
# == Advanced parameters:
#
class puppetmaster::lcm
(
  String $foreman_db_password,
  String $foreman_admin_firstname,
  String $foreman_admin_lastname,
  String $foreman_admin_email,
  String $foreman_admin_password,
  String $timezone,
  String $puppetdb_database_password,
  Boolean $foreman_plugin_cockpit,
  Boolean $foreman_compute_vmware,
  Boolean $foreman_compute_libvirt,
  Boolean $foreman_compute_ec2,
  Boolean $foreman_compute_gce,
  Boolean $foreman_compute_openstack,
  Boolean $foreman_compute_ovirt,
  Boolean $foreman_compute_rackspace,
  Boolean $foreman_plugin_azure,
  Boolean $foreman_plugin_ansible,
  Boolean $foreman_plugin_docker,
  Boolean $foreman_plugin_bootdisk,
  Boolean $foreman_plugin_default_hostgroup,
  Boolean $foreman_plugin_dhcp_browser,
  Boolean $foreman_plugin_digitalocean,
  Boolean $foreman_plugin_discovery,
  Boolean $foreman_plugin_hooks,
  Boolean $foreman_plugin_memcache,
  Boolean $foreman_plugin_remote_execution,
  Boolean $foreman_plugin_tasks,
  Boolean $foreman_plugin_templates,
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

  $foreman_version                    = '1.16.0'
  $foreman_repo                       = '1.16'
  $foreman_manage_memcached           = true
  $foreman_memcached_max_memory       = '8%'
  $foreman_url                        = "https://${facts['fqdn']}"
  $primary_names                      = unique([ "${facts['fqdn']}", "${facts['hostname']}", 'puppet', "puppet.${facts['domain']}" ])
  $foreman_puppetdb_dashboard_address = "http://${facts['fqdn']}:8080/pdb/dashboard"
  $foreman_puppetdb_address           = "https://${facts['fqdn']}:8081/v2/commands"
  $puppetdb_server                    = $facts['fqdn']

  unless defined(Class['::puppetmaster::common']) {
    
    class { '::puppetmaster::common':
      primary_names => $primary_names,
      timezone      => $timezone, 
      before        => Class['::puppetmaster::foreman'],
    }
  }
  
  class { '::puppetmaster::foreman':
    foreman_db_password              => $foreman_db_password, 
    foreman_admin_firstname          => $foreman_admin_firstname,
    foreman_admin_lastname           => $foreman_admin_lastname,
    foreman_admin_email              => $foreman_admin_email,
    foreman_admin_password           => $foreman_admin_password,
    timezone                         => $timezone,
    puppetdb_database_password       => $puppetdb_database_password,
    foreman_plugin_cockpit           => $foreman_plugin_cockpit,
    foreman_compute_vmware           => $foreman_compute_vmware,
    foreman_compute_libvirt          => $foreman_compute_libvirt,
    foreman_compute_ec2              => $foreman_compute_ec2,
    foreman_compute_gce              => $foreman_compute_gce,
    foreman_compute_openstack        => $foreman_compute_openstack,
    foreman_compute_ovirt            => $foreman_compute_ovirt,
    foreman_compute_rackspace        => $foreman_compute_rackspace,
    foreman_plugin_azure             => $foreman_plugin_azure,
    foreman_plugin_ansible           => $foreman_plugin_ansible,
    foreman_plugin_docker            => $foreman_plugin_docker,
    foreman_plugin_bootdisk          => $foreman_plugin_bootdisk,
    foreman_plugin_default_hostgroup => $foreman_plugin_default_hostgroup,
    foreman_plugin_dhcp_browser      => $foreman_plugin_dhcp_browser,
    foreman_plugin_digitalocean      => $foreman_plugin_digitalocean,
    foreman_plugin_discovery         => $foreman_plugin_discovery,
    foreman_plugin_hooks             => $foreman_plugin_hooks,
    foreman_plugin_memcache          => $foreman_plugin_memcache,
    foreman_plugin_remote_execution  => $foreman_plugin_remote_execution,
    foreman_plugin_tasks             => $foreman_plugin_tasks,
    foreman_plugin_templates         => $foreman_plugin_templates,
  }

  class { '::puppetmaster::foreman_proxy':
    foreman_proxy_foreman_base_url    => $foreman_proxy_foreman_base_url, 
    foreman_proxy_templates           => $foreman_proxy_templates,
    foreman_proxy_templates_listen_on => $foreman_proxy_templates_listen_on,
    foreman_proxy_trusted_hosts       => $foreman_proxy_trusted_hosts,
    foreman_proxy_dhcp                => $foreman_proxy_dhcp,
    foreman_proxy_dhcp_listen_on      => $foreman_proxy_dhcp_listen_on,
    foreman_proxy_dns                 => $foreman_proxy_dns,
    foreman_proxy_dhcp_managed        => $foreman_proxy_dhcp_managed,
    foreman_proxy_dhcp_interface      => $foreman_proxy_dhcp_interface,
    foreman_proxy_dhcp_option_domain  => $foreman_proxy_dhcp_option_domain,
    foreman_proxy_dhcp_search_domains => $foreman_proxy_dhcp_search_domains,
    foreman_proxy_dhcp_server         => $foreman_proxy_dhcp_server,
    foreman_proxy_dhcp_provider       => $foreman_proxy_dhcp_provider,
    foreman_proxy_dhcp_subnets        => $foreman_proxy_dhcp_subnets,
    foreman_proxy_dhcp_gateway        => $foreman_proxy_dhcp_gateway,
    foreman_proxy_dhcp_range          => $foreman_proxy_dhcp_range,
    foreman_proxy_dhcp_nameservers    => $foreman_proxy_dhcp_nameservers,
    foreman_proxy_dhcp_pxeserver      => $foreman_proxy_dhcp_pxeserver,
    foreman_proxy_dns_managed         => $foreman_proxy_dns_managed,
    foreman_proxy_dns_forwarders      => $foreman_proxy_dns_forwarders,
    foreman_proxy_dns_interface       => $foreman_proxy_dns_interface,
    foreman_proxy_dns_listen_on       => $foreman_proxy_dns_listen_on,
    foreman_proxy_dns_provider        => $foreman_proxy_dns_provider,           
    foreman_proxy_dns_zone            => $foreman_proxy_dns_zone,
    foreman_proxy_dns_reverse         => $foreman_proxy_dns_reverse,
    foreman_proxy_dns_server          => $foreman_proxy_dns_server,
    foreman_proxy_dns_ttl             => $foreman_proxy_dns_ttl,
    foreman_proxy_tftp                => $foreman_proxy_tftp,
    foreman_proxy_tftp_managed        => $foreman_proxy_tftp_managed,
    foreman_proxy_tftp_servername     => $foreman_proxy_tftp_servername,
    foreman_proxy_tftp_manage_wget    => $foreman_proxy_tftp_manage_wget,
    foreman_proxy_tftp_listen_on      => $foreman_proxy_tftp_listen_on,
    foreman_proxy_bmc                 => $foreman_proxy_bmc,
    foreman_proxy_bmc_listen_on       => $foreman_proxy_bmc_listen_on,
    require                           => Class['::puppetmaster::foreman'],
  }
}
