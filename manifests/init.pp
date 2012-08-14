class hiera(
  $hierarchy  = [],
  $hiera_yaml = '/etc/puppetlabs/puppet/hiera.yaml',
  $datadir    = '/etc/puppetlabs/puppet/hieradata'
) {
  File {
    owner => 'pe-puppet',
    group => 'pe-puppet',
    mode  => '0644',
  }
  file { $datadir:
    ensure => directory,
  }
  # Template uses $hierarchy, $datadir
  file { $hiera_yaml:
    ensure  => present,
    content => template('hiera/hiera.yaml.erb'),
  }
  # Symlink for hiera command line tool
  file { "/etc/hiera.yaml":
    ensure => symlink,
    target => $hiera_yaml,
  }
}
