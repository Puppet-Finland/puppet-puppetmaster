class puppetmaster::foreman_proxy
(  # foreman
  $foreman_proxy_foreman_url                       = 'https://puppet.tietoteema.vm',
  $foreman_proxy_foreman_admin_user                = 'admin',
  $foreman_proxy_foreman_admin_password 'changeme',
  # foreman-proxy
  $foreman_proxy_bind_host                         = [ '0.0.0.0' ], 
  $foreman_proxy_trusted_hosts                     = [ 'puppet.tietoteema.vm', 'lcm-proxy.tietoteema.vm' ],
  $foreman_proxy_register_in_foreman               = true, 
  $foreman_proxy_registered_name                   = 'puppet.tietoteema.vm',
  $foreman_proxy_registered_proxy_url              = 'https://puppet.tietoteema.vm:8443',
  $foreman_proxy_foreman_base_url                  = 'https://puppet.tietoteema.vm',
  $foreman_proxy_version                           = '1.15.6',
  $repo                                            = '1.15',
  $foreman_proxy_ensure_packages_version           = 'installed',
  $foreman_proxy_manage_memcached                  = false,
  $foreman_proxy_memcached_max_memory              = '8%',  
  $foreman_proxy_user                              = 'foreman-proxy',
  $foreman_proxy_group                             = 'foreman-proxy'
  $foreman_proxy_additional_groups                 = ['puppet'],
  $foreman_proxy_oauth_consumer_key                = 'xEL7pzhskio8AHqWhMWCwskzvWNgvQRB',
  $foreman_proxy_oauth_consumer_secret             = '2F5iKu5VzuRzVYRaYFQiNcPghihYn7dP',
  $foreman_proxy_templates                         = true,
  $foreman_proxy_templates_listen_on               = 'http',
  $foreman_proxy_template_url                      = 'http://puppet.tietoteema.vm:8000',
  $foreman_proxy_http                              = true,
  $foreman_proxy_http_port                         = 8000,
  $foreman_proxy_manage_sudoersd false,
  $foreman_proxy_use_sudoersd                      = false,

  # puppet
  $foreman_proxy_puppet_url                        = 'https://puppet.tietoteema.vm:8140',
  $foreman_proxy_puppet_use_environment_api        = true,
  $foreman_proxy_puppet_use_cache                  = true,
  $foreman_proxy_puppet_manage_authorization_rules = false,
  $foreman_proxy_puppet_configure_puppetserver     = false,

  # puppetca settings
  $foreman_proxy_puppetca                          = false,
  $foreman_proxy_puppetca_listen_on                = 'https',
  $foreman_proxy_puppetca_cmd                      = '/opt/puppetlabs/bin/puppet cert', 
  $foreman_proxy_puppetdir                         = '/etc/puppetlabs/puppet',

  # puppetrun settings
  $foreman_proxy_puppet                            = true,
  $foreman_proxy_puppet_listen_on                  = 'https',
  $foreman_proxy_puppetrun_cmd                     = 'puppetssh', 
  $foreman_proxy_puppetrun_provider                = 'puppetssh', 
  $foreman_proxy_customrun_cmd                     = '/bin/bash',
  $foreman_proxy_customrun_args                    = '-ay -f -s',
  $foreman_proxy_mcollective_user                  = 'root',
  $foreman_proxy_puppetssh_sudo                    = false,
  $foreman_proxy_puppetssh_user                    = 'vagrant',
  $foreman_proxy_puppetssh_keyfile                 = '/etc/foreman-proxy/id_rsa',
  $foreman_proxy_puppetssh_wait                    = false,
  # dhcp
  $foreman_proxy_dhcp                              = false,
  $foreman_proxy_dhcp_managed                      = false,
  $foreman_proxy_dhcp_listen_on                    = 'both',
  $foreman_proxy_dhcp_interface                    = 'eth1',
  $foreman_proxy_dhcp_option_domain                = [ 'tietoteema.vm' ],
  $foreman_proxy_dhcp_search_domains               = [ 'tietoteema.vm' ],
  $foreman_proxy_dhcp_server                       = 'puppet.tietoteema.vm',
  $foreman_proxy_dhcp_provider                     = 'isc',
  $foreman_proxy_dhcp_subnets                      = ['192.168.137.0/255.255.255.0'],
  $foreman_proxy_dhcp_gateway                      = '192.168.137.10')
  $foreman_proxy_dhcp_range                        = '192.168.137.100 192.168.137.200',
  $foreman_proxy_dhcp_nameservers                  = '192.168.137.10')    
  $foreman_proxy_dhcp_pxeserver                    = dhcp_pxeserver, '192.168.137.201',

  # dns
  $foreman_proxy_dns                               = false,
  $foreman_proxy_dns_managed                       = false,  
  $foreman_proxy_dns_forwarders                    = [ '192.168.137.201', '8.8.8.8' ],
  $foreman_proxy_dns_interface                     = 'eth1',
  $foreman_proxy_dns_listen_on                     = 'https',  
  $foreman_proxy_dns_provider                      = 'nsupdate',  
  $foreman_proxy_dns_zone                          = $::domain,  
  $foreman_proxy_dns_reverse                       = '137.168.192.in-addr.arpa',  
  $foreman_proxy_dns_server                        = '192.168.137.10',
  $foreman_proxy_dns_ttl                           = '86400',  
  
  # tftp
  $foreman_proxy_tftp                              = false,
  $foreman_proxy_tftp_managed                      = false,
  $foreman_proxy_tftp_servername                   = '192.168.137.10',
  $foreman_proxy_tftp_manage_wget                  =true,
  $foreman_proxy_tftp_listen_on                    = 'both',  
  $foreman_proxy_tftp_root                         = '/var/lib/tftpboot',
  $foreman_proxy_tftp_dirs                         = ["${tftp_root}/pxelinux.cfg","${tftp_root}/boot","${tftp_root}/ztp.cfg","${tftp_root}/poap.cfg"],

  # BMC
  $foreman_proxy_bmc                               = false,
  $foreman_proxy_bmc_listen_on                     = 'https',
  $foreman_proxy_bmc_default_provider              = 'ipmitool',

  # misc
  $foreman_proxy_include_epel                      = false,
)
{ 
  if ($foreman_proxy_include_epel) {
    include epel
  }
  
  if ($foreman_proxy_manage_memcached) {
    class { 'memcached':
      max_memory => "$memcached_max_memory",
    }
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
    
    #    class { '::puppet::server':
      #      use_legacy_auth_conf => false,
      #      require              => Class['::foreman_proxy'],
      #    }
    
    puppet_authorization::rule { 'environments':
      match_request_path   => '/puppet/v3/environments',
      match_request_type   => 'path',
      match_request_method => 'get',
      allow                => '*',
      sort_order           => 500,
      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    }

    puppet_authorization::rule { 'environment_classes':
      match_request_path   => '/puppet/v3/environment_classes',
      match_request_type   => 'path',
      match_request_method => 'get',
      allow                => '*',
      sort_order           => 500,
      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
      notify               => Service['puppetserver']
    }

    puppet_authorization::rule { 'resource_types':
      match_request_path   => '/puppet/v3/resource_types',
      match_request_type   => 'path',
      match_request_method => [ 'get', 'post' ],
      allow                => '*',
      sort_order           => 500,
      path                 => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    }                                                            

    #wget::fetch { 'node.rb':
      #  source      => 'https://raw.githubusercontent.com/theforeman/puppet-foreman/master/files/external_node_v2.rb',
      #  destination => '/etc/puppetlabs/puppet/node.rb',
      #}
    
    #file { '/etc/puppetlabs/puppet/node.rb':
      #  ensure  => present,
      #  mode    => '0755',
      #  require => Wget::Fetch['node.rb'],
      #}
    
    #file { '/etc/puppetlabs/puppet/foreman.yaml':
      #  content  => template('/opt/local/server/templates/foreman.yaml.erb'),
      # require => [ Wget::Fetch['node.rb'], Class['::foreman_proxy'] ],
      #}
    
    # Despite us commanding to use only new style auth.conf, old style seems to be needed
#    file { '/etc/puppetlabs/puppet/auth.conf':
#      source       => $::fqdn ? {
#        /^.*\.vm$/ => "/opt/local/server/files/auth.conf",
#        default    => "/opt/local/server/files/auth.conf",
#      },
#    require        => Class['::foreman_proxy'],
#    }                                                                
    
    ini_setting { 'puppet_conf_node_terminus':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'node_terminus',
      value   => 'exec',
    }
    
    ini_setting { 'puppet_conf_reports':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'reports',
      value   => 'log, foreman',
      require => Class['::foreman_proxy'],
    }                                          

    ini_setting { 'Configure puppet vardir':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'main',
      setting => 'vardir',
      value   => '/opt/puppetlabs/puppet/cache',
    }

    ini_setting { 'Configure puppet auto-signing':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'autosign',
      value   => '/etc/puppetlabs/puppet/autosign.conf { mode = 0664 }',
    }

#    file { '/etc/puppetlabs/puppet/autosign.conf':
#      owner   => $foreman_proxy_user,
#      group   => 'puppet',
#      mode    => '0664',
#      require => Class['::foreman_proxy'], 
#    }

    wget::fetch { 'foreman.rb':
      source      => 'https://raw.githubusercontent.com/theforeman/puppet-foreman/master/files/foreman-report_v2.rb',
      destination => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/reports/foreman.rb',
      require     => Class['::foreman_proxy'],
    }                                               
    
    firewall { '8140 allow foreman proxy incoming puppet':
      chain       => 'INPUT',
      state       => ['NEW'],
      dport       => '8140',
      proto       => 'tcp',
      action      => 'accept',
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
    puppetdir               => $foreman_proxy_puppetdir,
    puppetca_cmd            => $foreman_proxy_puppetca_cmd,
    log_level               => 'DEBUG',
    tftp                    => $foreman_proxy_tftp,
    tftp_managed            => $foreman_proxy_tftp_managed,
    tftp_manage_wget        => $foreman_proxy_tftp_manage_wget,
    #tftp_dirs              => $foreman_proxy_tftp_dirs,
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
    # dhcp_pxeserver          => $foreman_proxy_dhcp_pxeserver,
    dns                     => $foreman_proxy_dns,
    dns_managed             => $foreman_proxy_dns_managed,
    dns_interface           => $foreman_proxy_dns_interface,
    dns_zone                => $foreman_proxy_dns_zone,
    dns_forwarders          => $foreman_proxy_dns_forwarders,
    dns_ttl                 => $foreman_proxy_dns_ttl,
    dns_reverse             => $foreman_proxy_dns_reverse, 
    bmc                     => $foreman_proxy_bmc,
    bmc_listen_on           => $foreman_proxy_bmc_listen_on,
    bmc_default_provider    => $foreman_proxy_bmc_default_provider,
    # groups                  => $foreman_proxy_additional_groups, 
    oauth_consumer_key      => $foreman_proxy_oauth_consumer_key,
    oauth_consumer_secret   => $foreman_proxy_oauth_consumer_secret,
    templates               => $foreman_proxy_templates,
    templates_listen_on     => $foreman_proxy_templates_listen_on,
    template_url            => $foreman_proxy_template_url,
    http                    => $foreman_proxy_http,
    http_port               => $foreman_proxy_http_port,
    tftp_servername         => $foreman_proxy_tftp_servername,
    manage_sudoersd         => $foreman_proxy_manage_sudoersd,
    use_sudoersd            => $foreman_proxy_use_sudoersd,
  }
}
