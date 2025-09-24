# @summary
#   This class handles installing the hiera.yaml for Puppet's use. Creates either /etc/puppet/hiera.yaml or /etc/puppetlabs/puppet/hiera.yaml in set hiera version and links /etc/hiera.yaml to it. Creates $datadir (if $datadir_manage == true).
#
# @param hierarchy
#   The hiera hierarchy.
# @param hiera_version
#   To set hiera 5 defaults. e.g. datadir, data_hash.
# @param hiera5_defaults
#   Version format to layout hiera.yaml. Should be a string.
# @param backends
#   The list of backends. If you supply a additional backend you must also supply the backend data in the backend_options hash.
# @param backend_options
#   An optional hash of backend data for any backend. Each key in the hash should be the name of the backend as listed in the backends array. You can also supply additional settings for the backend by passing in a hash. By default the yaml and eyaml backend data will be added if you enable them via their respective parameters. Any options you supply for yaml and eyaml backend types will always override other parameters supplied to the hiera class for that backend.
#
#   Example hiera data for the backend_options hash:
#
#   ```
#   backend_options:
#     json:
#       datadir: '/etc/puppetlabs/puppet/%{environment}/jsondata'
#     redis:
#       password: clearp@ssw0rd        # if your Redis server requires authentication
#       port: 6380                     # unless present, defaults to 6379
#       db: 1                          # unless present, defaults to 0
#       host: db.example.com           # unless present, defaults to localhost
#       path: /tmp/redis.sock          # overrides port if unixsocket exists
#       soft_connection_failure: true  # bypass exception if Redis server is unavailable; default is false
#       separator: /                   # unless present, defaults to :
#       deserialize: :json             # Try to deserialize; both :yaml and :json are supported
#   ```
#
#   NOTE: The backend_options must not contain symbols as keys ie :json: despite the hiera config needing symbols. The template will perform all the conversions to symbols in order for hiera to be happy. Because puppet does not use symbols there are minor annoyances when converting back and forth and merge data together.
# @param hiera_yaml
#   The path to the hiera config file. Note: Due to a bug, hiera.yaml is not placed in the codedir. Your puppet.conf hiera_config setting must match the configured value; see also hiera::puppet_conf_manage
# @param create_symlink
#   Whether to create the symlink /etc/hiera.yaml
# @param datadir
#   The path to the directory where hiera will look for databases.
# @param datadir_manage
#   Whether to create and manage the datadir as a file resource.
# @param owner
#   The owner of managed files and directories.
# @param group
#   The group owner of managed files and directories.
# @param mode
# @param eyaml_owner
# @param eyaml_group
# @param provider
#   Which provider to use to install hiera-eyaml. Can be:
#     puppetserver_gem (PE 2015.x or FOSS using puppetserver)
#     pe_puppetserver_gem (PE 3.7 or 3.8)
#     pe_gem (PE pre-3.7)
#     puppet_gem (agent-only gem)
#     gem (FOSS using system ruby (ie puppetmaster)) Note: this module cannot detect FOSS puppetserver and you must pass provider => 'puppetserver_gem' for that to work. See also master_service.
# @param eyaml
#   Whether to install, configure, and enable the eyaml backend. Also see the provider and master_service parameters.
# @param eyaml_name
#   The name of the eyaml gem.
# @param eyaml_version
#   The version of hiera-eyaml to install. Accepts 'installed', 'latest', '2.0.7', etc
# @param eyaml_source
#   An alternate gem source for installing hiera-eyaml.
# @param eyaml_datadir
#   The path to the directory where hiera will look for databases with the eyaml backend.
# @param eyaml_extension
#   The file extension for the eyaml backend.
# @param confdir
#   The path to Puppet's confdir.
# @param puppet_conf_manage
#   Whether to manage the puppet.conf hiera_config value or not.
# @param logger
#   Which hiera logger to use. Note: You need to manage any package/gem dependencies yourself.
# @param cmdpath
#   Search paths for command binaries, like the eyaml command. The default should cover most cases.
# @param create_keys
#   Whether to create pkcs7 keys and manage key files for hiera-eyaml. This is useful if you need to distribute a pkcs7 key pair.
# @param keysdir
#   Directory for hiera to manage for eyaml keys. Note: If using PE 2013.x+ and code-manager set the keysdir under the $confdir/code-staging directory to allow the code manager to sync the keys to all PuppetServers Example: /etc/puppetlabs/code-staging/keys
# @param deep_merge_name
#   The name of the deep_merge gem.
# @param deep_merge_version
#   The version of deep_merge to install. Accepts 'installed', 'latest', '2.0.7', etc.
# @param deep_merge_source
#   An alternate gem source for installing deep_merge.
# @param deep_merge_options
#   A hash of options to set in hiera.yaml for the deep merge behavior.
# @param merge_behavior
#   Which hiera merge behavior to use. Valid values are 'native', 'deep', and 'deeper'. Deep and deeper values will install the deep_merge gem into the puppet runtime.
# @param extra_config
#   Arbitrary YAML content to append to the end of the hiera.yaml config file. This is useful for configuring backend-specific parameters.
# @param master_service
#   The service name of the master to restart after package installation or hiera.yaml changes. Note: You must pass master_service => 'puppetserver' for FOSS puppetserver
# @param manage_package
#   A boolean for wether the hiera package should be managed.
# @param manage_eyaml_package
# @param manage_deep_merge_package
# @param manage_eyaml_gpg_package
# @param package_name
#   Specifies the name of the hiera package.
# @param package_ensure
#   Specifies the ensure value of the hiera package.
# @param eyaml_gpg_name
# @param eyaml_gpg_version
# @param eyaml_gpg_source
# @param eyaml_gpg
# @param eyaml_gpg_gnupghome_recurse
#   Whether to recurse and set permissions in the gpgdir. This is imporant to protect the key, but makes puppet agent raise an error on each run. You can set the mode on these files to 0600 by yourself and set this to false.
# @param eyaml_gpg_recipients
# @param eyaml_pkcs7_private_key
# @param eyaml_pkcs7_public_key
# @param ruby_gpg_name
# @param ruby_gpg_version
# @param ruby_gpg_source
# @param gem_install_options
#   An array of install options to pass to the gem package resources. Typically, this parameter is used to specify a proxy server. eg gem_install_options => ['--http-proxy', 'http://proxy.example.com:3128']
# @param gem_source
#
# @author
#   Hunter Haugen <h.haugen@gmail.com>
#   Mike Arnold <mike@razorsedge.org>
#   Terri Haber <terri@puppetlabs.com>
#   Greg Kitson <greg.kitson@puppetlabs.com>
#
# === Copyright:
#
# Copyright (C) 2012 Hunter Haugen, unless otherwise noted.
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
# Copyright (C) 2014 Terri Haber, unless otherwise noted.
# Copyright (C) 2016 Vox Pupuli, unless otherwise noted.
#
class hiera (
  Variant[Array, Array[Hash]] $hierarchy    = $hiera::params::hierarchy,
  Optional[Enum['3','5']] $hiera_version    = $hiera::params::hiera_version,
  Hiera::Hiera5_defaults $hiera5_defaults   = $hiera::params::hiera5_defaults,
  $backends                                 = ['yaml'],
  $backend_options                          = {},
  $hiera_yaml                               = $hiera::params::hiera_yaml,
  $create_symlink                           = true,
  $datadir                                  = $hiera::params::datadir,
  $datadir_manage                           = true,
  $owner                                    = $hiera::params::owner,
  $group                                    = $hiera::params::group,
  $mode                                     = $hiera::params::mode,
  $eyaml_owner                              = $hiera::params::eyaml_owner,
  $eyaml_group                              = $hiera::params::eyaml_group,
  $provider                                 = $hiera::params::provider,
  $eyaml                                    = false,
  $eyaml_name                               = 'hiera-eyaml',
  $eyaml_version                            = undef,
  $eyaml_source                             = undef,
  $eyaml_datadir                            = undef,
  $eyaml_extension                          = undef,
  $confdir                                  = $hiera::params::confdir,
  $puppet_conf_manage                       = true,
  $logger                                   = 'console',
  $cmdpath                                  = $hiera::params::cmdpath,
  $create_keys                              = true,
  $keysdir                                  = undef,
  $deep_merge_name                          = 'deep_merge',
  $deep_merge_version                       = undef,
  $deep_merge_source                        = undef,
  $deep_merge_options                       = {},
  $merge_behavior                           = undef,
  $extra_config                             = '',
  $master_service                           = $hiera::params::master_service,
  $manage_package                           = $hiera::params::manage_package,
  Boolean $manage_eyaml_package             = true,
  Boolean $manage_deep_merge_package        = true,
  Boolean $manage_eyaml_gpg_package         = true,
  $package_name                             = $hiera::params::package_name,
  $package_ensure                           = $hiera::params::package_ensure,
  $eyaml_gpg_name                           = 'hiera-eyaml-gpg',
  $eyaml_gpg_version                        = undef,
  $eyaml_gpg_source                         = undef,
  $eyaml_gpg                                = false,
  Boolean $eyaml_gpg_gnupghome_recurse      = true,
  $eyaml_gpg_recipients                     = undef,
  $eyaml_pkcs7_private_key                  = undef,
  $eyaml_pkcs7_public_key                   = undef,
  $ruby_gpg_name                            = 'ruby_gpg',
  $ruby_gpg_version                         = undef,
  $ruby_gpg_source                          = undef,

  Optional[Array] $gem_install_options = undef,

  #Deprecated
  $gem_source                               = undef,
) inherits hiera::params {
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
    mode  => $mode,
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
      require hiera::deep_merge
    }
  }

  if ( $eyaml_gpg ) or ( $eyaml ) {
    $eyaml_real_datadir = empty($eyaml_datadir) ? {
      false => $eyaml_datadir,
      true  => $datadir,
    }

    # if eyaml is present in $backends, preserve its location!
    if ( 'eyaml' in $backends ) {
      $requested_backends = $backends
    } else {
      $requested_backends = unique(concat(['eyaml'], $backends))
    }
  } else {
    $requested_backends = $backends
    $eyaml_real_datadir = undef
  }

  # without these variables defined here puppet will puke when strict
  # variables is enabled, which are needed for delete_undef_values
  if $eyaml_gpg {
    $encrypt_method = 'gpg'
    $gpg_gnupghome  = "${_keysdir}/gpg"
    require hiera::eyaml_gpg
  } elsif $eyaml {
    require hiera::eyaml
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
    'eyaml' => delete_undef_values(
      {
        'datadir'           => $eyaml_real_datadir,
        'extension'         => $eyaml_extension,
        'pkcs7_private_key' => $_eyaml_pkcs7_private_key,
        'pkcs7_public_key'  => $_eyaml_pkcs7_public_key,
        'encrypt_method'    => $encrypt_method,
        'gpg_gnupghome'     => $gpg_gnupghome,
        'gpg_recipients'    => $eyaml_gpg_recipients,
      },
    ),
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

  # Hiera 5 additional parameters:
  # - hiera_version (String)
  # - hiera5_defaults (Hash)
  # - hierarchy (Array[Hash])

  # Determine hiera version
  case $hiera_version {
    '5':  {
      if ($hierarchy !~ Hiera::Hiera5_hierarchy) {
        fail('`hierarchy` should be an array of hash')
      } else {
        $hiera_template = epp('hiera/hiera.yaml.epp',
          {
            'hiera_version'   => $hiera_version,
            'hiera5_defaults' => $hiera5_defaults,
            'hierarchy'       => $hierarchy
          }
        )
      }
    }                                                             # Apply epp if hiera version is 5
    default:  { $hiera_template = template('hiera/hiera.yaml.erb') }    # Apply erb for default version 3
  }
  file { $hiera_yaml:
    ensure  => file,
    content => $hiera_template,
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
