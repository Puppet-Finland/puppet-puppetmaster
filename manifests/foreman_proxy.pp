class puppetmaster::foreman_proxy
( 
  $foreman_proxy_bind_host,             
  $foreman_proxy_trusted_hosts,         
  $foreman_proxy_register_in_foreman,   
  $foreman_proxy_registered_name,       
  $foreman_proxy_registered_proxy_url,  
  $foreman_proxy_foreman_base_url,      
  $foreman_proxy_version,               
  $foreman_proxy_repo,                                
  $foreman_proxy_ensure_packages_version,
  $foreman_proxy_user,                   
  $foreman_proxy_group,                  
  $foreman_proxy_groups,      
  $foreman_proxy_oauth_consumer_key,     
  $foreman_proxy_oauth_consumer_secret,  
  $foreman_proxy_templates,              
  $foreman_proxy_templates_listen_on,    
  $foreman_proxy_template_url,           
  $foreman_proxy_http,                   
  $foreman_proxy_http_port,              
  $foreman_proxy_manage_sudoersd,
  $foreman_proxy_use_sudoers,
  $foreman_proxy_use_sudoersd,    
  # puppet
  $foreman_proxy_puppet_url,      
  $foreman_proxy_puppet_use_environment_api,
  $foreman_proxy_puppet_use_cache,          
  # puppetca settings
  $foreman_proxy_puppetca,                         
  $foreman_proxy_puppetca_listen_on,               
  $foreman_proxy_puppetca_cmd,                     
  $foreman_proxy_puppetdir,                        
  # puppetrun settings
  $foreman_proxy_puppet,                           
  $foreman_proxy_puppet_listen_on,                 
  $foreman_proxy_puppetrun_cmd,                    
  $foreman_proxy_puppetrun_provider,               
  $foreman_proxy_customrun_cmd,                    
  $foreman_proxy_customrun_args,                   
  $foreman_proxy_mcollective_user,                 
  $foreman_proxy_puppetssh_sudo,                   
  $foreman_proxy_puppetssh_user,                   
  $foreman_proxy_puppetssh_keyfile,                
  # dhcp
  $foreman_proxy_dhcp,                             
  $foreman_proxy_dhcp_managed,                     
  $foreman_proxy_dhcp_listen_on,                   
  $foreman_proxy_dhcp_interface,                   
  $foreman_proxy_dhcp_option_domain,               
  $foreman_proxy_dhcp_search_domains,              
  $foreman_proxy_dhcp_server,                      
  $foreman_proxy_dhcp_provider,                    
  $foreman_proxy_dhcp_subnets,                     
  $foreman_proxy_dhcp_gateway,                     
  $foreman_proxy_dhcp_range,                       
  $foreman_proxy_dhcp_nameservers,                 
  $foreman_proxy_dhcp_pxeserver,                   
  # dns
  $foreman_proxy_dns,                              
  $foreman_proxy_dns_managed,                      
  $foreman_proxy_dns_forwarders,                   
  $foreman_proxy_dns_interface,                    
  $foreman_proxy_dns_listen_on,                    
  $foreman_proxy_dns_provider,                     
  $foreman_proxy_dns_zone,                         
  $foreman_proxy_dns_reverse,                      
  $foreman_proxy_dns_server,                       
  $foreman_proxy_dns_ttl,                          
  # tftp
  $foreman_proxy_tftp,                             
  $foreman_proxy_tftp_managed,                    
  $foreman_proxy_tftp_servername,                  
  $foreman_proxy_tftp_manage_wget,                 
  $foreman_proxy_tftp_listen_on,                   
  $foreman_proxy_tftp_root,                        
  # BMC
  $foreman_proxy_bmc,                              
  $foreman_proxy_bmc_listen_on,                    
  $foreman_proxy_bmc_default_provider,             
  # misc
  $foreman_proxy_include_epel,                     
  $foreman_proxy_log_level,
)
{ 
  if ($foreman_proxy_include_epel) {
    include epel
  }
  
  if defined(Service['foreman::service']) {
    service { 'foreman::service':
      ensure => running,
    }
  }

  firewall { '22 accept outgoing foreman-proxy remote ssh execution':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '22',
    proto  => 'tcp',
    action => 'accept',
  }

  if ($foreman_proxy_dns) {

    firewall { '53 allow incoming dns tcp':
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

    firewall { '6768 allow incoming dhcp':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => [ '67', '68'],
      proto  => 'tcp',
      action => 'accept',
    }

  }

  if ($foreman_proxy_tftp_managed) {
    
    firewall { '80 allow incoming kickstart request':
      chain  => 'INPUT',
      state  => ['NEW'],
      dport  => "$http_port",
      proto  => 'tcp',
      action => 'accept',
    }

    firewall { '103 allow incoming tftp':
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
      command     => "foreman-rake templates:sync",
      user        => 'root',
      hour      => '0',
      minute    => '0',
    }                       
  }
    
  if ($foreman_proxy_puppet) {
    
#    puppet_authorization::rule { 'environments':
#      match_request_path   => '/puppet/v3/environments',
#      match_request_type   => 'path',
#      match_request_method => 'get',
#      allow                => '*',
#      sort_order           => 500,
#      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
#    }

#    puppet_authorization::rule { 'environment_classes':
#      match_request_path   => '/puppet/v3/environment_classes',
#      match_request_type   => 'path',
#      match_request_method => 'get',
#      allow                => '*',
#      sort_order           => 500,
#      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
#      notify               => Service['puppetserver']
#    }

#    puppet_authorization::rule { 'resource_types':
#      match_request_path   => '/puppet/v3/resource_types',
#      match_request_type   => 'path',
#      match_request_method => [ 'get', 'post' ],
#      allow                => '*',
#      sort_order           => 500,
#      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
#    }                                                            

#    ini_setting { 'puppet_conf_node_terminus':
#      ensure  => present,
#      path    => '/etc/puppetlabs/puppet/puppet.conf',
#      section => 'master',
#      setting => 'node_terminus',
#      value   => 'exec',
#    }
    
#    ini_setting { 'puppet_conf_reports':
#      ensure  => present,
#      path    => '/etc/puppetlabs/puppet/puppet.conf',
#      section => 'main',
#      setting => 'reports',
#      value   => 'log, foreman',
#      require => Class['::foreman_proxy'],
#    }                                          

#    ini_setting { 'Configure puppet vardir':
#      ensure  => present,
#      path    => '/etc/puppetlabs/puppet/puppet.conf',
#      section => 'main',
#      setting => 'vardir',
#      value   => '/opt/puppetlabs/puppet/cache',
#    }

 #   ini_setting { 'Configure puppet auto-signing':
 #     ensure  => present,
 #     path    => '/etc/puppetlabs/puppet/puppet.conf',
 #     section => 'master',
 #     setting => 'autosign',
 #     value   => '/etc/puppetlabs/puppet/autosign.conf { mode = 0664 }',
 #   }

    firewall { '8140 allow foreman proxy incoming puppet':
      chain       => 'INPUT',
      state       => ['NEW'],
      dport       => '8140',
      proto       => 'tcp',
      action      => 'accept',
    }
    
  }

  class { '::foreman_proxy':
    version                        => $foreman_proxy_version,
    user                           => $foreman_proxy_user,
    ensure_packages_version        => $foreman_proxy_ensure_packages_version,
    repo                           => $foreman_proxy_repo,
    registered_name                => $foreman_proxy_registered_name,
    registered_proxy_url           => $foreman_proxy_registered_proxy_url,
    foreman_proxy_foreman_base_url => $foreman_proxy_foreman_base_url,
    trusted_hosts                  => $foreman_proxy_trusted_hosts,
    bind_host                      => $foreman_proxy_bind_host,
    puppet                         => $foreman_proxy_puppet,
    puppet_use_cache               => $foreman_proxy_puppet_use_cache, 
    puppetca                       => $foreman_proxy_puppetca,
    puppetdir                      => $foreman_proxy_puppetdir,
    puppetca_cmd                   => $foreman_proxy_puppetca_cmd,
    log_level                      => $foreman_proxy_log_level,
    tftp                           => $foreman_proxy_tftp,
    tftp_managed                   => $foreman_proxy_tftp_managed,
    tftp_manage_wget               => $foreman_proxy_tftp_manage_wget,
    dhcp_managed                   => $foreman_proxy_dhcp_managed,
    dhcp                           => $foreman_proxy_dhcp,
    dhcp_listen_on                 => $foreman_proxy_dhcp_listen_on,
    dhcp_interface                 => $foreman_proxy_dhcp_interface,
    dhcp_subnets                   => $foreman_proxy_dhcp_subnets, 
    dhcp_gateway                   => $foreman_proxy_dhcp_gateway,
    dhcp_range                     => $foreman_proxy_dhcp_range,
    dhcp_nameservers               => $foreman_proxy_dhcp_nameservers,
    dhcp_option_domain             => $foreman_proxy_dhcp_option_domain, 
    dhcp_search_domains            => $foreman_proxy_dhcp_search_domains,
    dns                            => $foreman_proxy_dns,
    dns_managed                    => $foreman_proxy_dns_managed,
    dns_interface                  => $foreman_proxy_dns_interface,
    dns_zone                       => $foreman_proxy_dns_zone,
    dns_forwarders                 => $foreman_proxy_dns_forwarders,
    dns_ttl                        => $foreman_proxy_dns_ttl,
    dns_reverse                    => $foreman_proxy_dns_reverse, 
    bmc                            => $foreman_proxy_bmc,
    bmc_listen_on                  => $foreman_proxy_bmc_listen_on,
    bmc_default_provider           => $foreman_proxy_bmc_default_provider,
    group                          => $foreman_proxy_group, 
    groups                         => $foreman_proxy_groups, 
    oauth_consumer_key             => $foreman_proxy_oauth_consumer_key,
    oauth_consumer_secret          => $foreman_proxy_oauth_consumer_secret,
    templates                      => $foreman_proxy_templates,
    templates_listen_on            => $foreman_proxy_templates_listen_on,
    template_url                   => $foreman_proxy_template_url,
    http                           => $foreman_proxy_http,
    http_port                      => $foreman_proxy_http_port,
    tftp_servername                => $foreman_proxy_tftp_servername,
    manage_sudoersd                => $foreman_proxy_manage_sudoersd,
    use_sudoersd                   => $foreman_proxy_use_sudoersd,
    use_sudoers                    => $foreman_proxy_use_sudoers,
    include_epel                   => $foreman_proxy_include_epel,
    register_in_foreman            => $foreman_proxy_register_in_foreman,
    foreman_proxy_base_url         => $foreman_proxy_base_url,
  }
}
