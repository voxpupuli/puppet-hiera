# == Class: hiera::eyaml
#
# This class installs and configures hiera-eyaml
#
# === Authors:
#
# Terri Haber <terri@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera::eyaml (
  $provider = $hiera::params::provider,
  $owner    = $hiera::params::owner,
  $group    = $hiera::params::group,
  $cmdpath  = $hiera::params::cmdpath,
  $confdir  = $hiera::params::confdir
) inherits hiera::params {

  package { 'hiera-eyaml':
    ensure   => installed,
    provider => $provider,
  }

  file { "${confdir}/keys":
    ensure => directory,
    owner  => $owner,
    group  => $group,
    before => Exec['createkeys'],
  }

  exec { 'createkeys':
    user    => $owner,
    cwd     => $confdir,
    command => "${cmdpath}/eyaml createkeys",
    path    => $cmdpath,
    creates => "${confdir}/keys/private_key.pkcs7.pem",
    require => Package['hiera-eyaml'],
  }


  file { "${confdir}/keys/private_key.pkcs7.pem":
    ensure  => file,
    mode    => '0640',
    owner   => $owner,
    group   => $group,
    require => Exec['createkeys'],
  }

  file { "${confdir}/keys/public_key.pkcs7.pem":
    ensure  => file,
    mode    => '0644',
    owner   => $owner,
    group   => $group,
    require => Exec['createkeys'],
  }
}
