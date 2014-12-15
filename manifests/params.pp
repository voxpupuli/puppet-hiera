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
  if str2bool($::is_pe) {
    $hiera_yaml = '/etc/puppetlabs/puppet/hiera.yaml'
    $datadir    = '/etc/puppetlabs/puppet/hieradata'
    $owner      = 'pe-puppet'
    $group      = 'pe-puppet'
    $confdir    = '/etc/puppetlabs/puppet'


    if versioncmp($::pe_version, '3.7.0') >= 0 {
      $provider = 'pe_puppetserver_gem'
    }
    else {
      $provider = 'pe_gem'
    }
  }
  else {
    $hiera_yaml = '/etc/puppet/hiera.yaml'
    $datadir    = '/etc/puppet/hieradata'
    $owner      = 'puppet'
    $group      = 'puppet'
    $provider   = 'gem'
    $confdir    = '/etc/puppet'
  }
  $cmdpath              = ['/opt/puppet/bin', '/usr/bin', '/usr/local/bin']
  $datadir_manage       = true
  $backends             = ['yaml']
  $logger               = 'console'
  $eyaml_extension      = undef
  $eyaml_gpg_recipients = undef
  
  if $::osfamily == 'RedHat' {
    $gnupg_package         = 'gnupg2'
  }
}
