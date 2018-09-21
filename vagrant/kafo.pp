notify { 'Installing Kafo': }

class { '::kafo':
  gem_provider => 'puppet_gem',
}

