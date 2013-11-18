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

  if $::puppetversion =~ /Puppet Enterprise/ {
    $backends   = [{'yaml' => {'datadir' => '/etc/puppetlabs/puppet/hieradata'}}]
    $hiera_yaml = '/etc/puppetlabs/puppet/hiera.yaml'
    $owner      = 'pe-puppet'
    $group      = 'pe-puppet'
  } else {
    $backends   = [{'yaml' => {'datadir' => '/etc/puppet/hieradata'}}]
    $hiera_yaml = '/etc/puppet/hiera.yaml'
    $owner      = 'puppet'
    $group      = 'puppet'
  }

  $hierarchy = []

}
