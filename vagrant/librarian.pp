notify { 'Installing librarian-puppet': }

package { 'librarian-puppet':
  ensure   => latest,
  provider => 'puppet_gem',
}
