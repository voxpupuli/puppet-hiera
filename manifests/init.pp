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
# Copyright (C) 2016 Vox Pupuli, unless otherwise noted.
#
class hiera (
  $hierarchy               = $::hiera::params::hierarchy,
  $backends                = ['yaml'],
  $hiera_yaml              = $::hiera::params::hiera_yaml,
  $create_symlink          = true,
  $datadir                 = $::hiera::params::datadir,
  $datadir_manage          = true,
  $owner                   = $::hiera::params::owner,
  $group                   = $::hiera::params::group,
  $provider                = $::hiera::params::provider,
  $eyaml                   = false,
  $eyaml_name              = 'hiera-eyaml',
  $eyaml_version           = undef,
  $eyaml_source            = undef,
  $eyaml_datadir           = undef,
  $eyaml_extension         = undef,
  $confdir                 = $::hiera::params::confdir,
  $puppet_conf_manage      = true,
  $logger                  = 'console',
  $cmdpath                 = $::hiera::params::cmdpath,
  $create_keys             = true,
  $keysdir                 = undef,
  $deep_merge_name         = 'deep_merge',
  $deep_merge_version      = undef,
  $deep_merge_source       = undef,
  $deep_merge_options      = {},
  $merge_behavior          = undef,
  $extra_config            = '',
  $master_service          = $::hiera::params::master_service,
  $manage_package          = $::hiera::params::manage_package,
  $package_name            = $::hiera::params::package_name,
  $package_ensure          = $::hiera::params::package_ensure,
  $eyaml_gpg_name          = 'hiera-eyaml-gpg',
  $eyaml_gpg_version       = undef,
  $eyaml_gpg_source        = undef,
  $eyaml_gpg               = false,
  $eyaml_gpg_recipients    = undef,
  $eyaml_pkcs7_private_key = undef,
  $eyaml_pkcs7_public_key  = undef,

  #Deprecated
  $gem_source              = undef,
) inherits ::hiera::params {

  if $keysdir {
    $_keysdir = $keysdir
  } else {
    $_keysdir = "${confdir}/keys"
  }

  if $eyaml_pkcs7_private_key {
    $_eyaml_pkcs7_private_key = $eyaml_pkcs7_private_key
  } else {
    $_eyaml_pkcs7_private_key = "${_keysdir}/private_key.pkcs7.pem"
  }

  if $eyaml_pkcs7_public_key {
    $_eyaml_pkcs7_public_key = $eyaml_pkcs7_public_key
  } else {
    $_eyaml_pkcs7_public_key = "${_keysdir}/public_key.pkcs7.pem"
  }

  if $eyaml_source {
    $_eyaml_source = $eyaml_source
  } else {
    $_eyaml_source = $gem_source
  }

  if $eyaml_gpg_source {
    $_eyaml_gpg_source = $eyaml_gpg_source
  } else {
    $_eyaml_gpg_source = $gem_source
  }

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
    if $merge_behavior != 'native' {
      require ::hiera::deep_merge
    }
  }

  if ( $eyaml_gpg ) or ( $eyaml ) {
    $eyaml_real_datadir = empty($eyaml_datadir) ? {
      false => $eyaml_datadir,
      true  => $datadir,
    }
  }

  if $eyaml_gpg {
    require ::hiera::eyaml_gpg
  } elsif $eyaml {
    require ::hiera::eyaml
  }

  if $manage_package {
    package { 'hiera':
      ensure => $package_ensure,
      name   => $package_name,
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
  # - $_keysdir
  # - $confdir
  # - $merge_behavior
  # - $deep_merge_options
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
  if $puppet_conf_manage {
    ini_setting { 'puppet.conf hiera_config main section' :
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'main',
      setting => 'hiera_config',
      value   => $hiera_yaml,
    }
    $master_subscribe = [
      File[$hiera_yaml],
      Ini_setting['puppet.conf hiera_config main section'],
    ]
  } else {
    $master_subscribe = File[$hiera_yaml]
  }

  # Restart master service
  Service <| title == $master_service |> {
    subscribe +> $master_subscribe,
  }
}
