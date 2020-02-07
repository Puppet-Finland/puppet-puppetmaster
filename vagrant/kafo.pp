notify { 'Installing Kafo and its dependencies': }

package { 'rubygems':
  ensure => 'present',
}

package { 'kafo':
  ensure   => 'present',
  provider => 'puppet_gem',
}

$gems = [ 'rdoc', 'yard', 'puppet-strings']

package { $gems:
  ensure   => 'present',
  provider => 'puppet_gem',
}
