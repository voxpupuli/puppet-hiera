class hiera::params {
  if $::puppetversion =~ /Puppet Enterprise/ {
    $hiera_yaml = '/etc/puppetlabs/puppet/hiera.yaml'
    $datadir    = '/etc/puppetlabs/puppet/hieradata'
    $owner      = 'pe-puppet'
    $group      = 'pe-puppet'
  } else {
    $hiera_yaml = '/etc/puppet/hiera.yaml'
    $datadir    = '/etc/puppet/hieradata'
    $owner      = 'puppet'
    $group      = 'puppet'
  }
}
