class hiera(
  $hierarchy  = [],
  $hiera_yaml     = '/etc/puppet/hiera.yaml',
  $datadir        = '/etc/puppet/hieradata',
  $manage_datadir = false,
  $owner          = 'puppet',
  $group          = 'puppet'
) {
  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }

  if $manage_datadir {
    file { $datadir:
      ensure => directory,
    }
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
