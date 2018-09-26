notify { 'Installing Git': }

package { 'git':
  ensure => 'latest',
}
