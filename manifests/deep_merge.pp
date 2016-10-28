# == Class: hiera::deep_merge
#
# This class installs and configures deep_merge
#
# === Authors:
#
# Joseph Yaworski <jyaworski@carotid.us>
#
# === Copyright:
#
# Copyright (C) 2016 Joseph Yaworski, unless otherwise noted.
#
class hiera::deep_merge {
  $provider           = $::hiera::provider
  $deep_merge_version = $::hiera::deep_merge_version
  $deep_merge_source  = $::hiera::deep_merge_source
  $deep_merge_name    = $::hiera::deep_merge_name
  $manage_package     = $::hiera::manage_package

  if $manage_package {
    ::hiera::install { 'deep_merge':
      gem_name    => $deep_merge_name,
      provider    => $provider,
      gem_version => $deep_merge_version,
      gem_source  => $deep_merge_source,
    }
  }
}
