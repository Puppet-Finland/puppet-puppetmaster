#
class puppetmaster::puppetboard::ssl_workarounds {

  # On Ubuntu 20.04 and CentOS 8 there's an issue with PuppetDB <-> Puppetboard
  # interaction:
  #
  # <https://github.com/voxpupuli/puppetboard/issues/535>
  #
  ini_setting { 'puppetdb-cipher-suites':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetdb/conf.d/jetty.ini',
    section => 'jetty',
    setting => 'cipher-suites',
    value   => '”TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA"',
    require => File['/etc/puppetlabs/puppetdb/conf.d/jetty.ini'],
    notify  => Service['puppetdb'],
  }

  # The above workaround will break Puppetserver -> Puppetboard
  # connections, so we need to make sure Puppetserver will only use
  # strong ciphers there. This is done by removing the cipher-suites setting
  # in puppetserver.conf. For details see
  #
  # <https://puppet.com/docs/puppet/7.5/server/known_issues.html>
  #
  # Quote: "Cipher updates in Puppet Server 6.5: ... Remove the weak ciphers by
  # removing the cipher-suite configuration section from the webserver.conf.
  # After you remove the cipher-suite, Puppet Server uses the FIPS-compliant
  # ciphers instead."
  #
  # We just apply the above recipe to puppetserver.conf which determines
  # outbound connection ciphers in puppetserver.
  #
  hocon_setting { 'puppetserver.conf cipher-suites':
    ensure  => absent,
    path    => '/etc/puppetlabs/puppetserver/conf.d/puppetserver.conf',
    setting => 'http-client.cipher-suites',
    require => Package['puppetserver'],
    notify  => Service['puppetserver'],
  }
}
