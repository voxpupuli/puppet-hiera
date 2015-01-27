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
  $provider    = $hiera::params::provider,
  $owner       = $hiera::owner,
  $group       = $hiera::group,
  $cmdpath     = $hiera::cmdpath,
  $confdir     = $hiera::confdir,
  $create_keys = $hiera::create_keys,
  $gem_source  = $hiera::gem_source,
) inherits hiera::params {

  package { 'hiera-eyaml':
    ensure   => installed,
    provider => $provider,
    source   => $gem_source,
  }

  File {
    owner => $owner,
    group => $group
  }

  file { "${confdir}/keys":
    ensure => directory,
  }

  if ( $create_keys == true ) {
    exec { 'createkeys':
      user    => $owner,
      cwd     => $confdir,
      command => 'eyaml createkeys',
      path    => $cmdpath,
      creates => "${confdir}/keys/private_key.pkcs7.pem",
      require => [ Package['hiera-eyaml'], File["${confdir}/keys"] ]
    }

    file { "${confdir}/keys/private_key.pkcs7.pem":
      ensure  => file,
      mode    => '0600',
      require => Exec['createkeys'],
    }

    file { "${confdir}/keys/public_key.pkcs7.pem":
      ensure  => file,
      mode    => '0644',
      require => Exec['createkeys'],
    }
  }
}
