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
  $provider      = $hiera::params::provider,
  $owner         = $hiera::owner,
  $group         = $hiera::group,
  $cmdpath       = $hiera::cmdpath,
  $confdir       = $hiera::confdir,
  $create_keys   = $hiera::create_keys,
  $eyaml_version = $hiera::eyaml_version,
  $gem_source    = $hiera::gem_source,
) inherits hiera::params {

  $package_ensure = $eyaml_version ? {
    undef   => 'installed',
    default => $eyaml_version,
  }
  package { 'hiera-eyaml':
    ensure   => $package_ensure,
    provider => $provider,
    source   => $gem_source,
  }
  if $provider == 'pe_puppetserver_gem' {
    # The puppetserver gem wouldn't install the commandline util, so we do
    # that here
    #XXX Pre-puppet 4.0.0 version (PUP-1073)
    #BUG This can't actually update the gem version if already installed.
    if $eyaml_version and $eyaml_version =~ /^\d+\.\d+\.\d+$/ {
      $gem_flag = "--version ${eyaml_version}"
    } else {
      $gem_flag = undef
    }
    exec { 'install pe_gem':
      command => "/opt/puppet/bin/gem install hiera-eyaml ${gem_flag}",
      creates => '/opt/puppet/bin/eyaml',
    }
    #XXX Post-puppet 4.0.0
    #package { 'hiera-eyaml command line':
    #  ensure   => installed,
    #  name     => 'hiera-eyaml',
    #  provider => 'pe_gem',
    #  source   => $gem_source,
    #}
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
