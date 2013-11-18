# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
# [*hierarchy*]
#   Hiera hierarchy.
#   Default: empty
#
# [*backends*]
#   array of Hiera backends, including configuration hashes
#   Default: [ {'yaml' > { 'datadir' => $datadir } ]
#            ($datadir auto-set, platform-specific
#
# [*hiera_yaml*]
#   Heira config file.
#   Default: auto-set, platform specific
#
# [*owner*]
#   Owner of the files.
#   Default: auto-set, platform specific
#
# [*group*]
#   Group owner of the files.
#   Default: auto-set, platform specific
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'hiera':
#     backends => [
#       { 'yaml' => { 'datadir' => '/etc/puppet/hieradata' } },
#     ],
#     hierarchy => [
#       '%{environment}',
#       'common',
#     ],
#   }
#
# === Authors:
#
# Hunter Haugen <h.haugen@gmail.com>
# Mike Arnold <mike@razorsedge.org>
# Robin Bowes <robin.bowes@yo61.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2013 Robin Bowes, unless otherwise noted.
#

class hiera(
  $hierarchy    = $::hiera::params::hierarchy,
  $hiera_yaml   = $::hiera::params::hiera_yaml,
  $backends     = $::hiera::params::backends,
  $owner        = $::hiera::params::owner,
  $group        = $::hiera::params::group,
) inherits ::hiera::params {

  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  # Template uses $backends, $hierarchy
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
