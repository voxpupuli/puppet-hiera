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
  $confdir          = $::settings::confdir
  $hiera_version    = '3'
  $hiera5_defaults  = { 'datadir' => 'data', 'data_hash' => 'yaml_data' }
  $package_ensure   = 'present'
  $package_name     = 'hiera'
  $hierarchy        = []
  $mode             = '0644'
  # Configure for AIO packaging.
  if $facts['pe_server_version'] {
    $master_service = 'pe-puppetserver'
    $provider       = 'puppetserver_gem'
    $owner          = 'root'
    $group          = 'root'
    $eyaml_owner    = 'pe-puppet'
    $eyaml_group    = 'pe-puppet'
  }
  else {
    # It would probably be better to assume this is puppetserver, but that
    # would be a backwards-incompatible change.
    $master_service = 'puppetmaster'
    $provider       = 'puppet_gem'
    $owner          = 'puppet'
    $group          = 'puppet'
    $eyaml_owner    = 'puppet'
    $eyaml_group    = 'puppet'
  }
  $cmdpath        = ['/opt/puppetlabs/puppet/bin', '/usr/bin', '/usr/local/bin']
  $datadir        = '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
  $manage_package = false
  $hiera_yaml = "${confdir}/hiera.yaml"
}
