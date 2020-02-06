notify { 'Installing r10k': }

package { 'r10k':
  ensure   => latest,
  provider => 'puppet_gem',
}
