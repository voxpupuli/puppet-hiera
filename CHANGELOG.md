# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest Vox Pupuli modulesync defaults.
These should not impact the functionality of the module.

## 2017-05-10 - Release 3.0.0

puppet/hiera no longer supports Puppet 3
* [GH-191](https://github.com/voxpupuli/puppet-hiera/pull/191)
  Replace validate_* calls with Puppet 4 data types
* [GH-187](https://github.com/voxpupuli/puppet-hiera/issues/187)
  Add parameter for passing gem install options.
  Especially helpful for those who need to use an http proxy when installing gems.

## 2017-01-13 - Release 2.4.0

This is the last release with Puppet 3 support!
* Do not make files in the gnupg home executable
* Support deep_merge_options with 'deeper' merge_behavior
* Correct spelling of @merge_behavior in template
* Bump min version_requirement for Puppet + deps
* Strict variables fix for `pe_server_version`

## 2016-11-07 Release 2.3.0

* [GH-128](https://github.com/voxpupuli/puppet-hiera/issues/128)
  The `manage_package` parameter now effects all packages.
* [GH-161](https://github.com/voxpupuli/puppet-hiera/issues/161)
  Regression fix. Make eyaml be the first backend again.

## 2016-10-07 Release 2.2.0

* Modulesync with latest Vox Pupuli defaults
* Removes unused `eyaml_gpg_keygen` variable

### Features

* Adds support for 3rd party backends #153

This module now supports configuration of any backend via a new `backend_options`
parameter. This is a big deal as this opens the doors up to configuring any
backend in a generic way. This is also backwards compatible with prior versions
of this module.

## 2016-08-31 Release 2.1.2

* Modulesync with latest Vox Pupuli defaults
* Fix handling of `gem_source` (correctly handle URLs)

## 2016-08-19 Release 2.1.1

* Modulesync with latest Vox Pupuli defaults
* Fix: Replace `to_yaml` in hiera.yaml template (PR #134)

## 2016-05-21 Release 2.1.0

Note: this is the first release of the module in the voxpupuli namespace.

### Features

* Add parameters to give more control over package management:
  * `eyaml_name`
  * `eyaml_version`
  * `eyaml_source` (deprecates `gem_source` parameter)
  * `deep_merge_name`
  * `deep_merge_version`
  * `deep_merge_source`
  * `manage_package`
  * `package_name`
  * `package_source`
* Add `deep_merge_options` parameter for passing parameters in hiera.yaml
* The `merge_behavior` parameter installs the `deep_merge` gem when needed.

### Bugfixes

* Typo for `master_service` parameter in readme.
* Improve dependency management around packages
* Fix `hierarchy` parameter default on Puppet 4

## 2016-01-27 Release 2.0.1

### Fixes

* Fix key creation when passing a custom `hiera::keysdir`

## 2016-01-26 Release 2.0.0

### Changes

* eyaml keys/ directory moved from `/etc/puppetlabs/code/keys` to
  `/etc/puppetlabs/puppet/keys` on PE > 3.x. You should move you keys directory
  when upgrading.
* `hiera::hiera_yaml` default changed from `/etc/puppetlabs/code/hiera.yaml` to
  `/etc/puppetlabs/puppet/hiera.yaml` on Puppet >= 4.x. The hiera\_yaml puppet
  config setting in puppet.conf should be updated when upgrading; see
  `hiera::puppet_conf_manage`
* `hiera::datadir` default changed from `/etc/puppetlabs/puppet/hieradata` to
  `/etc/puppetlabs/code/environments/%{::environment}/hieradata` on puppet
  versions >= 4. Verify that this is your prefered value when upgrading.

### Features

* No longer using exec resources to install eyaml on puppet versions >= 4!
* Add `hiera::puppet_conf_manage` parameter to manage `hiera_conf` puppet.conf setting
* Add `hiera::keysdir` parameter for putting the keys somewhere other than $confdir/keys

### Bugfixes

* Fix hiera.yaml and keys/ directory being overwritten by file sync on PE 2015.x
* Fix eyaml package provider detection on puppet versions >= 4

## 2016-01-08 Release 1.4.1

### Bugfixes

* Fix rubocop linting
* Correct the name of the license file so the forge can find it.
* Add travis testing

## 2016-01-05 Release 1.4.0

### Features

* Added `hiera::create_symlink` parameter to disable /etc/hiera.yaml creation
* Added `hiera::master_service` parameter to set the master service name
* Added ability to restart master service on hiera.yaml change
* Added beaker-rspec acceptance tests
* Bumped PE range to include 2015.3

### Bugfixes

* Fixed bugs on PE 2015.2 when versioncmp() raised errors
* Fixed hiera.yaml output to be consistent across puppet 3 and 4
* Fixed stdlib metadata requirement.

## 2015-09-14 Release 1.3.2

### Bugfixes

* Detect correct user on 2015.2.0
* Clean up hiera formatting.

## 2015-07-24 Release 1.3.1

### Bugfixes

* Allow `eyaml_version` to be undef (the default) on PE 3.7/3.8

## 2015-07-23 Release 1.3.0

### Features

* Add PE 3.8 support
* Add Puppet 4 support

### Bugfixes

* Fix `eyaml_datadir` parameter default to `datadir` value
* Handle cmdpath on different versions of puppet

## 2015-03-05 Release 1.2.0

### Features

* Added `hiera::create_keys` param to disable pkcs7 key generation with
  hiera-eyaml
* Added `hiera::gem_source` param to specify source of hiera-eyaml gem
* Added `hiera::eyaml_version` param to specify the version of eyaml

### Bugfixes

* Change Modulefile to metadata.json
* Add validation on `merge_behavior` param
* Make it kind of work on PE 3.7 (pe-puppetserver must still be restarted after
  the gem is installed)

## 2014-11-21 Release 1.1.1

### Bugfixes

* Correct handling of `cmdpath` (using an array of paths instead of hardcoded
  path). Also adds `cmdpath` parameter
* Fix permissions on private key (604 was a typo)
* Add "Managed by puppet" header

## 2014-10-15 Release 1.1.0

### Features

* Added `eyaml`, `eyaml_datadir`, & `eyaml_extension` parameters to hiera class
  for configuring hiera-eyaml
* Added `hiera::datadir_manage` parameter to disable datadir management
* Added `hiera::logger` parameter to change logger
* Added `hiera::merge_behavior` parameter to change the hash merge behavior
* Added some spec tests
* Added new readme

### Bugfixes

* Correct datadir regex `{}` matching

## 2014-05-01 Release 1.0.2

* Remove swap files from package

## 2014-03-25 Release 1.0.1

### Bugfixes

* Readme tweak
* Use template instance variables to remove warnings

## 2014-02-27 Release 1.0.0

### Features

* `backends` parameter for an array of hiera backends
* `extra_config` parameter for a string of extra yaml config

### Bugfixes

* Correct the yaml formatting

## 2013-06-17 Release 0.3.1

### Bugfixes

* Docs!

## 2013-06-17 Release 0.3.0

### Features

* PE + POSS support

### Bugfixes

* Only ensure datadir if it does not have `%{.*}`

[2.2.0]: https://github.com/hunner/puppet-hiera/compare/2.1.1...v2.2.0
[2.1.1]: https://github.com/hunner/puppet-hiera/compare/2.1.0...v2.1.1
[2.1.0]: https://github.com/hunner/puppet-hiera/compare/2.0.1...v2.1.0
[2.0.1]: https://github.com/hunner/puppet-hiera/compare/2.0.0...2.0.1
[2.0.0]: https://github.com/hunner/puppet-hiera/compare/1.4.1...2.0.0
[1.4.1]: https://github.com/hunner/puppet-hiera/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/hunner/puppet-hiera/compare/1.3.2...1.4.0
[1.3.2]: https://github.com/hunner/puppet-hiera/compare/1.3.1...1.3.2
[1.3.1]: https://github.com/hunner/puppet-hiera/compare/1.3.0...1.3.1
[1.3.0]: https://github.com/hunner/puppet-hiera/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/hunner/puppet-hiera/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/hunner/puppet-hiera/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/hunner/puppet-hiera/compare/1.0.2...1.1.0
[1.0.2]: https://github.com/hunner/puppet-hiera/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/hunner/puppet-hiera/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/hunner/puppet-hiera/compare/0.3.1...1.0.0
[0.3.1]: https://github.com/hunner/puppet-hiera/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/hunner/puppet-hiera/compare/0.2.1...0.3.0
