# Remove system ruby to ensure that Puppetlabs' version is used
package { 'ruby':
  ensure => 'absent',
}

