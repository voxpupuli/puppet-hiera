# == Class: hiera
#
# This class handles installing the hiera.yaml for Puppet's use.
#
# === Parameters:
#
#   See README.
#
# === Actions:
#
# Installs either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml.
# Links /etc/hiera.yaml to the above file.
# Creates $datadir (if $datadir_manage == true).
#
# === Requires:
#
# puppetlabs-stdlib >= 4.3.1
#
# === Sample Usage:
#
#   class { 'hiera':
#     hierarchy => [
#       '%{environment}',
#       'common',
#     ],
#   }
#
# === Authors:
#
# Hunter Haugen <h.haugen@gmail.com>
# Mike Arnold <mike@razorsedge.org>
# Terri Haber <terri@puppetlabs.com>
# Greg Kitson <greg.kitson@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
# Copyright (C) 2016 Vox Pupuli, unless otherwise noted.
#
class hiera (
  $hierarchy               = $::hiera::params::hierarchy,
  $backends                = ['yaml'],
  $backend_options         = {},
  $hiera_yaml              = $::hiera::params::hiera_yaml,
  $create_symlink          = true,
  $datadir                 = $::hiera::params::datadir,
  $datadir_manage          = true,
  $owner                   = $::hiera::params::owner,
  $group                   = $::hiera::params::group,
  $provider                = $::hiera::params::provider,
  $eyaml                   = false,
  $eyaml_name              = 'hiera-eyaml',
  $eyaml_version           = undef,
  $eyaml_source            = undef,
  $eyaml_datadir           = undef,
  $eyaml_extension         = undef,
  $confdir                 = $::hiera::params::confdir,
  $puppet_conf_manage      = true,
  $logger                  = 'console',
  $cmdpath                 = $::hiera::params::cmdpath,
  $create_keys             = true,
  $keysdir                 = undef,
  $deep_merge_name         = 'deep_merge',
  $deep_merge_version      = undef,
  $deep_merge_source       = undef,
  $deep_merge_options      = {},
  $merge_behavior          = undef,
  $extra_config            = '',
  $master_service          = $::hiera::params::master_service,
  $manage_package          = $::hiera::params::manage_package,
  $package_name            = $::hiera::params::package_name,
  $package_ensure          = $::hiera::params::package_ensure,
  $eyaml_gpg_name          = 'hiera-eyaml-gpg',
  $eyaml_gpg_version       = undef,
  $eyaml_gpg_source        = undef,
  $eyaml_gpg               = false,
  $eyaml_gpg_recipients    = undef,
  $eyaml_pkcs7_private_key = undef,
  $eyaml_pkcs7_public_key  = undef,

  $ruby_gpg_name           = 'ruby_gpg',
  $ruby_gpg_version        = undef,
  $ruby_gpg_source         = undef,

  Optional[Array] $gem_install_options = undef,

  #Deprecated
  $gem_source              = undef,
) inherits ::hiera::params {

  if $keysdir {
    $_keysdir = $keysdir
  } else {
    $_keysdir = "${confdir}/keys"
  }

  if $eyaml_pkcs7_private_key {
    $_eyaml_pkcs7_private_key = $eyaml_pkcs7_private_key
  } else {
    $_eyaml_pkcs7_private_key = "${_keysdir}/private_key.pkcs7.pem"
  }

  if $eyaml_pkcs7_public_key {
    $_eyaml_pkcs7_public_key = $eyaml_pkcs7_public_key
  } else {
    $_eyaml_pkcs7_public_key = "${_keysdir}/public_key.pkcs7.pem"
  }

  if $eyaml_source {
    $_eyaml_source = $eyaml_source
  } else {
    $_eyaml_source = $gem_source
  }

  if $eyaml_gpg_source {
    $_eyaml_gpg_source = $eyaml_gpg_source
  } else {
    $_eyaml_gpg_source = $gem_source
  }

  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }

  if ($datadir !~ /%\{.*\}/) and ($datadir_manage == true) {
    file { $datadir:
      ensure => directory,
    }
  }

  if $merge_behavior {
    unless $merge_behavior in ['native', 'deep', 'deeper'] {
      fail("${merge_behavior} merge behavior is invalid. Valid values are: native, deep, deeper")
    }
    if $merge_behavior != 'native' {
      require ::hiera::deep_merge
    }
  }

  if ( $eyaml_gpg ) or ( $eyaml ) {

    $eyaml_real_datadir = empty($eyaml_datadir) ? {
      false => $eyaml_datadir,
      true  => $datadir,
    }
    # the requested_backends has a side affect in that the eyaml will always be
    # first for backend lookups.  This can be fixed by specifing the order in
    # the backends parameter ie. ['yaml', 'eyaml', 'redis']
    $requested_backends = unique(concat(['eyaml'], $backends))
  } else {
    $requested_backends = $backends
    $eyaml_real_datadir = undef
  }

  # without these variables defined here puppet will puke when strict
  # variables is enabled, which are needed for delete_undef_values
  if $eyaml_gpg {
    $encrypt_method = 'gpg'
    $gpg_gnupghome  = "${_keysdir}/gpg"
    require ::hiera::eyaml_gpg
  } elsif $eyaml {
    require ::hiera::eyaml
    $encrypt_method = undef
    $gpg_gnupghome  = undef
  } else {
    $encrypt_method = undef
    $gpg_gnupghome  = undef
  }

  if $manage_package {
    package { 'hiera':
      ensure => $package_ensure,
      name   => $package_name,
    }
  }
  # these are the default eyaml options that were interpolated in
  # the above logic.  This was neccessary in order to maintain compability
  # with prior versions of this module
  $eyaml_options = {
    'eyaml' => delete_undef_values({
      'datadir'           => $eyaml_real_datadir,
      'extension'         => $eyaml_extension,
      'pkcs7_private_key' => $_eyaml_pkcs7_private_key,
      'pkcs7_public_key'  => $_eyaml_pkcs7_public_key,
      'encrypt_method'    => $encrypt_method,
      'gpg_gnupghome'     => $gpg_gnupghome,
      'gpg_recipients'    => $eyaml_gpg_recipients,
    }),
  }
  $yaml_options = { 'yaml' => { 'datadir' => $datadir } }
  # all the backend options are merged together into a single hash
  # the user can override anything via the backend_options hash parameter
  # which will override any data set in the eyaml or yaml parameters above.
  # the template will only use the backends that were defined in the backends
  # array even if there is info in the backend data hash
  $backend_data = deep_merge($yaml_options, $eyaml_options, $backend_options)
  # if for some reason the user mispelled the backend in the backend_options lets
  # catch that error here and notify the user
  $missing_backends = difference($backends, keys($backend_data))
  if count($missing_backends) > 0 {
    fail("The supplied backends: ${missing_backends} are missing from the backend_options hash:\n ${backend_options}\n
    or you might be using symbols in your hiera data")
  }

  # Template uses:
  # - $backends
  # - $requested_backends
  # - $backend_data
  # - $logger
  # - $hierarchy
  # - $confdir
  # - $merge_behavior
  # - $deep_merge_options
  # - $extra_config
  file { $hiera_yaml:
    ensure  => present,
    content => template('hiera/hiera.yaml.erb'),
  }
  # Symlink for hiera command line tool
  if $create_symlink {
    file { '/etc/hiera.yaml':
      ensure => symlink,
      target => $hiera_yaml,
    }
  }
  if $puppet_conf_manage {
    ini_setting { 'puppet.conf hiera_config main section' :
      ensure  => present,
      path    => "${confdir}/puppet.conf",
      section => 'main',
      setting => 'hiera_config',
      value   => $hiera_yaml,
    }
    $master_subscribe = [
      File[$hiera_yaml],
      Ini_setting['puppet.conf hiera_config main section'],
    ]
  } else {
    $master_subscribe = File[$hiera_yaml]
  }

  # Restart master service
  Service <| title == $master_service |> {
    subscribe +> $master_subscribe,
  }
}
