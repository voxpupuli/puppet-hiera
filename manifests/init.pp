class hiera (
  $hierarchy  = [],
  $hiera_yaml = $hiera::params::hiera_yaml,
  $datadir    = $hiera::params::datadir,
  $owner      = $hiera::params::owner,
  $group      = $hiera::params::group
) inherits hiera::params {
  File {
    owner => $owner,
    group => $group,
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
  file { '/etc/hiera.yaml':
    ensure => symlink,
    target => $hiera_yaml,
  }
}
