# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
#   See README.
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir (if $datadir_manage == true).
#
# === Requires:
#
# puppetlabs-stdlib >= 4.3.1
#
# === Sample Usage:
#
#   class { 'hiera':
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
# Terri Haber <terri@puppetlabs.com>
# Greg Kitson <greg.kitson@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera (
  $hierarchy       = [],
  $backends        = ['yaml'],
  $hiera_yaml      = $hiera::params::hiera_yaml,
  $create_symlink  = true,
  $datadir         = $hiera::params::datadir,
  $datadir_manage  = true,
  $owner           = $hiera::params::owner,
  $group           = $hiera::params::group,
  $provider        = $hiera::params::provider,
  $eyaml           = false,
  $eyaml_datadir   = undef,
  $eyaml_extension = undef,
  $confdir         = $hiera::params::confdir,
  $logger          = 'console',
  $cmdpath         = $hiera::params::cmdpath,
  $create_keys     = true,
  $gem_source      = undef,
  $eyaml_version   = undef,
  $merge_behavior  = undef,
  $extra_config    = '',
  $master_service  = $hiera::params::master_service,
) inherits hiera::params {
  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  if ($datadir !~ /%\{.*\}/) and ($datadir_manage == true) {
    file { $datadir:
      ensure => directory,
    }
  }
  if $merge_behavior {
    unless $merge_behavior in ['native', 'deep', 'deeper'] {
      fail("${merge_behavior} merge behavior is invalid. Valid values are: native, deep, deeper")
    }
  }
  if $eyaml {
    require hiera::eyaml
    $eyaml_real_datadir = empty($eyaml_datadir) ? {
      false => $eyaml_datadir,
      true  => $datadir,
    }
  }
  # Template uses:
  # - $eyaml
  # - $backends
  # - $logger
  # - $hierarchy
  # - $datadir
  # - $eyaml_real_datadir
  # - $eyaml_extension
  # - $confdir
  # - $merge_behavior
  # - $extra_config
  file { $hiera_yaml:
    ensure  => present,
    content => template('hiera/hiera.yaml.erb'),
  }
  # Symlink for hiera command line tool
  if $create_symlink {
    file { '/etc/hiera.yaml':
      ensure => symlink,
      target => $hiera_yaml,
    }
  }

  # Restart master service
  Service <| title == $master_service |> {
    subscribe +> File[$hiera_yaml],
  }
}
