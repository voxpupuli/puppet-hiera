# == Class hiera::eyaml_gpg
#
# This calls install and configures hiera-eyaml-gpg
#
class hiera::eyaml_gpg {
  $provider          = $::hiera::provider
  $eyaml_gpg_name    = $::hiera::eyaml_gpg_name
  $eyaml_gpg_version = $::hiera::eyaml_gpg_version
  $eyaml_gpg_source  = $::hiera::_eyaml_gpg_source

  $ruby_gpg_name     = $::hiera::ruby_gpg_name
  $ruby_gpg_version  = $::hiera::ruby_gpg_version
  $ruby_gpg_source   = $::hiera::ruby_gpg_source

  $owner             = $::hiera::owner
  $group             = $::hiera::group
  $cmdpath           = $::hiera::cmdpath
  $_keysdir          = $::hiera::_keysdir

  $manage_package = $::hiera::manage_package

  require ::hiera::eyaml

  File {
    owner => $owner,
    group => $group,
  }

  if $manage_package {
    ::hiera::install { 'ruby_gpg':
      gem_name    => $ruby_gpg_name,
      provider    => $provider,
      gem_version => $ruby_gpg_version,
      gem_source  => $ruby_gpg_source,
    }
    -> ::hiera::install { 'hiera-eyaml-gpg':
      gem_name    => $eyaml_gpg_name,
      provider    => $provider,
      gem_version => $eyaml_gpg_version,
      gem_source  => $eyaml_gpg_source,
    }
  }

  file { "${_keysdir}/gpg":
    ensure  => directory,
    recurse => true,
    purge   => false,
    mode    => '0600',
  }
}
