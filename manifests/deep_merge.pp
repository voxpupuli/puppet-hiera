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
class hiera::deep_merge (
  $provider           = $hiera::provider,
  $deep_merge_version = $hiera::deep_merge_version,
  $gem_source         = $hiera::gem_source,
  $deep_merge_name    = $hiera::deep_merge_name,
) inherits hiera::params {

  $package_ensure = $deep_merge_version ? {
    undef   => 'installed',
    default => $deep_merge_version,
  }
  if $provider == 'pe_puppetserver_gem' {
    Exec {
      path => [
        '/opt/puppetlabs/server/bin',
        '/opt/puppetlabs/puppet/bin',
        '/opt/puppet/bin',
        '/usr/bin',
        '/bin',
      ],
    }

    if $::pe_server_version {
      # PE 2015
      $vendored_gem_creates = '/opt/puppetlabs/puppet/bin/deep_merge'
      $puppetserver_gem_creates = '/opt/puppetlabs/server/data/puppetserver/jruby-gems/bin/deep_merge'
    } else {
      $vendored_gem_creates = '/opt/puppet/bin/deep_merge'
      $puppetserver_gem_creates = '/var/opt/lib/pe-puppet-server/jruby-gems/bin/deep_merge'
    }

    # The puppetserver gem wouldn't install the commandline util, so we do
    # that here
    #XXX Pre-puppet 4.0.0 version (PUP-1073)
    #BUG This can't actually update the gem version if already installed.
    if $deep_merge_version and $deep_merge_version =~ /^\d+\.\d+\.\d+$/ {
      $gem_flag = "--version ${deep_merge_version}"
    } else {
      $gem_flag = undef
    }
    #XXX Post-puppet 4.0.0
    #package { 'deep_merge command line':
    #  ensure   => installed,
    #  name     => 'deep_merge',
    #  provider => 'pe_gem',
    #  source   => $gem_source,
    #}

    exec { 'install ruby gem deep_merge':
      command => "gem install deep_merge ${gem_flag}",
      creates => $vendored_gem_creates,
    }

    exec { 'install puppetserver gem deep_merge':
      command => "puppetserver gem install deep_merge ${gem_flag}",
      creates => $puppetserver_gem_creates,
    }
  } else {
    package { 'deep_merge':
      ensure   => $package_ensure,
      name     => $deep_merge_name,
      provider => $provider,
      source   => $gem_source,
    }
  }
}
