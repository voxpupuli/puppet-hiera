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
  if ($::pe_server_version) or (str2bool($::is_pe)) {
    $owner          = 'pe-puppet'
    $group          = 'pe-puppet'
    $cmdpath        = [ '/opt/puppetlabs/server/bin', '/opt/puppetlabs/puppet/bin', '/opt/puppet/bin', '/usr/bin', '/bin', ]

    if ($::pe_build) and (versioncmp($::pe_build, '2015.2') >= 0) {
      $confdir    = '/etc/puppetlabs/code'
      $hiera_yaml = "${confdir}/hiera.yaml"
      $datadir    = "${confdir}/environments/%{::environment}/hieradata"
    } else {
      $confdir    = '/etc/puppetlabs/puppet'
      $hiera_yaml = "${confdir}/hiera.yaml"
      $datadir    = "${confdir}/hieradata"
    }

    if ($::pe_build) and ((versioncmp($::pe_build, '2015.2') >= 0) or (versioncmp($::pe_version, '3.7.0') >= 0)) { 
      $provider       = 'puppetserver_gem'
      $master_service = 'pe-puppetserver'
    } else {
      $provider       = 'pe_gem'
      $master_service = 'pe-httpd'
    }
  } else {
    $owner    = 'puppet'
    $group    = 'puppet'
    $master_service = 'puppetmaster'
    $hiera_yaml = "${confdir}/hiera.yaml"
    $datadir    = "${confdir}/hieradata"

    if ($::puppetversion) and (versioncmp($::puppetversion, '4.0.0') >= 0) {
      # Configure for AIO packaging.
      $confdir  = '/etc/puppetlabs/code'
      $provider = 'puppet_gem'
      $cmdpath  = ['/opt/puppetlabs/puppet/bin', '/usr/bin', '/usr/local/bin']
    } else {
      $confdir  = '/etc/puppet'
      $provider = 'gem'
      $cmdpath  = ['/usr/bin', '/usr/local/bin']
    }
  }
}
