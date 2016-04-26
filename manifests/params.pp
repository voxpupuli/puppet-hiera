# == Class: hiera::params
#
# This class handles OS-specific configuration of the hiera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class hiera::params {
  $confdir        = $::settings::confdir
  $package_ensure = 'present'
  $package_name   = 'hiera'
  $hierarchy      = []
  if str2bool($::is_pe) {
    $hiera_yaml     = '/etc/puppetlabs/puppet/hiera.yaml'
    $datadir        = '/etc/puppetlabs/puppet/hieradata'
    $owner          = 'pe-puppet'
    $group          = 'pe-puppet'
    $cmdpath        = ['/opt/puppet/bin', '/usr/bin', '/usr/local/bin']
    $manage_package = false

    if $::pe_version and versioncmp($::pe_version, '3.7.0') >= 0 {
      $provider       = 'pe_puppetserver_gem'
      $master_service = 'pe-puppetserver'
    } else {
      $provider       = 'pe_gem'
      $master_service = 'pe-httpd'
    }
  } else {
    if $::puppetversion and versioncmp($::puppetversion, '4.0.0') >= 0 {
      # Configure for AIO packaging.
      if $::pe_server_version {
        $master_service = 'pe-puppetserver'
        $provider       = 'puppetserver_gem'
      } else {
        # It would probably be better to assume this is puppetserver, but that
        # would be a backwards-incompatible change.
        $master_service = 'puppetmaster'
        $provider       = 'puppet_gem'
      }
      $cmdpath        = ['/opt/puppetlabs/puppet/bin', '/usr/bin', '/usr/local/bin']
      $datadir        = '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
      $manage_package = false
    } else {
      $master_service = 'puppetmaster'
      $provider       = 'gem'
      $cmdpath        = ['/usr/bin', '/usr/local/bin']
      $datadir        = "${confdir}/hieradata"
      $manage_package = true
    }
    if $::pe_server_version {
      $owner = 'pe-puppet'
      $group = 'pe-puppet'
    } else {
      $owner = 'puppet'
      $group = 'puppet'
    }
    $hiera_yaml = "${confdir}/hiera.yaml"
  }
}
