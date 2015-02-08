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
#   Hiera backends.
#   Default: ['yaml']
#
# [*hiera_yaml*]
#   Heira config file.
#   Default: auto-set, platform specific
#
# [*datadir*]
#   Directory in which hiera will start looking for databases.
#   Default: auto-set, platform specific
#
# [*datadir_manage*]
#   Enables creating $datadir directory
#   Default: true
#
# [*owner*]
#   Owner of the files.
#   Default: auto-set, platform specific
#
# [*group*]
#   Group owner of the files.
#   Default: auto-set, platform specific
#
# [*extra_config*]
#   An extra string fragment of YAML to append to the config file.
#   Useful for configuring backend-specific parameters.
#   Default: ''
#
# [*eyaml*]
#   Install and configure hiera-eyaml
#   Default: false
#
# [*eyaml_datadir*]
#   Location of eyaml-specific data
#   Default: Same as datadir
#
# [*eyaml_extension*]
#   File extension for eyaml backend
#   Default: undef, use backend default
#
# [*logger*]
#   Configure a valid hiera logger
#   Note: You need to manage any package/gem dependancies
#   Default: console
#
# [*merge_behavior*]
#   Configure hiera merge behavior.
#   Note: You need to manage any package/gem dependancies
#   Default: native
#
# [*create_keys*]
#   Enable or disable pkcs7 key generation and file management with hiera-eyaml
#   This is helpful if you need to distribute a pkcs7 key pair
#   Default: true
#
# [*cmdpath*]
#   Search paths for command binaries, like the 'eyaml' command.
#   The default should cover most cases.
#   Default: ['/opt/puppet/bin', '/usr/bin', '/usr/local/bin']
#
# [*gem_source*]
#   Configure an alternative Gem source
#   Default: undef, use backend default
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir (if $datadir_manage == true).
#
# === Requires:
#
# Nothing.
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
  $backends        = $hiera::params::backends,
  $hiera_yaml      = $hiera::params::hiera_yaml,
  $datadir         = $hiera::params::datadir,
  $datadir_manage  = $hiera::params::datadir_manage,
  $owner           = $hiera::params::owner,
  $group           = $hiera::params::group,
  $eyaml           = false,
  $eyaml_datadir   = $hiera::params::datadir,
  $eyaml_extension = $hiera::params::eyaml_extension,
  $confdir         = $hiera::params::confdir,
  $logger          = $hiera::params::logger,
  $cmdpath         = $hiera::params::cmdpath,
  $create_keys     = $hiera::params::create_keys,
  $gem_source      = $hiera::params::gem_source,
  $merge_behavior  = undef,
  $extra_config    = '',
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
  }
  # Template uses:
  # - $eyaml
  # - $backends
  # - $logger
  # - $hierarchy
  # - $datadir
  # - $eyaml_datadir
  # - $eyaml_extension
  # - $confdir
  # - $merge_behavior
  # - $extra_config
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
