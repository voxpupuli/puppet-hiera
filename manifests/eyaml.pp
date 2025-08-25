# @api private
#
# @summary
#   This class installs and configures hiera-eyaml
#
# @author
#   Terri Haber <terri@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
#
class hiera::eyaml {
  $eyaml_name    = $hiera::eyaml_name
  $provider      = $hiera::provider
  $eyaml_version = $hiera::eyaml_version
  $eyaml_source  = $hiera::_eyaml_source

  $owner         = $hiera::eyaml_owner
  $group         = $hiera::eyaml_group
  $cmdpath       = $hiera::cmdpath
  $confdir       = $hiera::confdir
  $create_keys   = $hiera::create_keys
  $_keysdir      = $hiera::_keysdir

  $manage_package = $hiera::manage_eyaml_package

  if $manage_package {
    hiera::install { 'eyaml':
      gem_name    => $eyaml_name,
      provider    => $provider,
      gem_version => $eyaml_version,
      gem_source  => $eyaml_source,
    }
    if $create_keys {
      Hiera::Install['eyaml'] {
        before => Exec['createkeys'],
      }
    }
  }

  File {
    owner => $owner,
    group => $group,
  }

  file { $_keysdir:
    ensure => directory,
  }

  $keysdir = dirname($_keysdir)

  if $create_keys {
    $privkey = $hiera::_eyaml_pkcs7_private_key
    $pubkey = $hiera::_eyaml_pkcs7_public_key

    exec { 'createkeys':
      user    => $owner,
      command => [
        'eyaml',
        'createkeys',
        "--pkcs7-private-key=${privkey}",
        "--pkcs7-public-key=${pubkey}",
      ],
      path    => $cmdpath,
      creates => $privkey,
    }

    file { $privkey:
      ensure  => file,
      mode    => '0600',
      require => Exec['createkeys'],
    }

    file { $pubkey:
      ensure  => file,
      mode    => '0644',
      require => Exec['createkeys'],
    }

    file { '/etc/eyaml':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { '/etc/eyaml/config.yaml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      # https://github.com/voxpupuli/puppet-lint-strict_indent-check/issues/20
      # lint:ignore:strict_indent
      content => @("CONF"),
        ---
        # This file is managed by puppet.
        pkcs7_private_key: ${privkey}
        pkcs7_public_key: ${pubkey}
        | CONF
      # lint:endignore
    }
  }
}
