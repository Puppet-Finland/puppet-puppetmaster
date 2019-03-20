notify { 'Installing Kafo and its dependencies': }

package { 'rubygems':
  ensure => 'present',
}

# We need to use a stable version of Highline module or kafo installers
# won't work
package { 'highline':
  ensure   => '1.7.10',
  provider => 'puppet_gem',
}

package { 'kafo':
  ensure   => '2.1.0',
  provider => 'puppet_gem',
}

$gems = [ 'rdoc', 'yard', 'puppet-strings', 'librarian-puppet' ]

package { $gems:
  ensure   => 'present',
  provider => 'puppet_gem',
}
