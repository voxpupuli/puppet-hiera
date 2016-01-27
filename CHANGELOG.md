# Change log
All notable changes to this project will be documented in this file.

## [2.0.1] - 2016-01-27
### Fixes:
- Fix key creation when passing a custom `hiera::keysdir`

## [2.0.0] - 2016-01-26
### Changes:
- eyaml keys/ directory moved from `/etc/puppetlabs/code/keys` to
  `/etc/puppetlabs/puppet/keys` on PE > 3.x. You should move you keys directory
  when upgrading.
- `hiera::hiera_yaml` default changed from `/etc/puppetlabs/code/hiera.yaml` to
  `/etc/puppetlabs/puppet/hiera.yaml` on Puppet >= 4.x. The hiera\_yaml puppet
  config setting in puppet.conf should be updated when upgrading; see
  `hiera::puppet_conf_manage`
- `hiera::datadir` default changed from `/etc/puppetlabs/puppet/hieradata` to
  `/etc/puppetlabs/code/environments/%{::environment}/hieradata` on puppet
  versions >= 4. Verify that this is your prefered value when upgrading.

### Features:
- No longer using exec resources to install eyaml on puppet versions >= 4!
- Add `hiera::puppet_conf_manage` parameter to manage `hiera_conf` puppet.conf setting
- Add `hiera::keysdir` parameter for putting the keys somewhere other than $confdir/keys

### Bugfixes:
- Fix hiera.yaml and keys/ directory being overwritten by file sync on PE 2015.x
- Fix eyaml package provider detection on puppet versions >= 4

## [1.4.1] - 2016-01-08
### Bugfixes:
- Fix rubocop linting
- Correct the name of the license file so the forge can find it.
- Add travis testing

## [1.4.0] - 2016-01-05
### Features:
- Added `hiera::create_symlink` parameter to disable /etc/hiera.yaml creation
- Added `hiera::master_service` parameter to set the master service name
- Added ability to restart master service on hiera.yaml change
- Added beaker-rspec acceptance tests
- Bumped PE range to include 2015.3

### Bugfixes:
- Fixed bugs on PE 2015.2 when versioncmp() raised errors
- Fixed hiera.yaml output to be consistent across puppet 3 and 4
- Fixed stdlib metadata requirement.

## [1.3.2] - 2015-09-14
### Bugfixes:
- Detect correct user on 2015.2.0
- Clean up hiera formatting.

## [1.3.1] - 2015-07-24
### Bugfixes:
- Allow `eyaml_version` to be undef (the default) on PE 3.7/3.8

## [1.3.0] - 2015-07-23
### Features:
- Add PE 3.8 support
- Add Puppet 4 support

### Bugfixes:
- Fix `eyaml_datadir` parameter default to `datadir` value
- Handle cmdpath on different versions of puppet

## [1.2.0] - 2015-03-05
### Features:
- Added `hiera::create_keys` param to disable pkcs7 key generation with
  hiera-eyaml
- Added `hiera::gem_source` param to specify source of hiera-eyaml gem
- Added `hiera::eyaml_version` param to specify the version of eyaml

### Bugfixes:
- Change Modulefile to metadata.json
- Add validation on `merge_behavior` param
- Make it kind of work on PE 3.7 (pe-puppetserver must still be restarted after
  the gem is installed)

## [1.1.1] - 2014-11-21
### Bugfixes:
- Correct handling of `cmdpath` (using an array of paths instead of hardcoded
  path). Also adds `cmdpath` parameter
- Fix permissions on private key (604 was a typo)
- Add "Managed by puppet" header

## [1.1.0] - 2014-10-15
### Features:
- Added `eyaml`, `eyaml_datadir`, & `eyaml_extension` parameters to hiera class
  for configuring hiera-eyaml
- Added `hiera::datadir_manage` parameter to disable datadir management
- Added `hiera::logger` parameter to change logger
- Added `hiera::merge_behavior` parameter to change the hash merge behavior
- Added some spec tests
- Added new readme

### Bugfixes:
- Correct datadir regex `{}` matching

## [1.0.2] - 2014-05-01
- Remove swap files from package

## [1.0.1] - 2014-03-25
### Bugfixes:
- Readme tweak
- Use template instance variables to remove warnings

## [1.0.0] - 2014-02-27
### Features:
- `backends` parameter for an array of hiera backends
- `extra_config` parameter for a string of extra yaml config

### Bugfixes:
- Correct the yaml formatting

## [0.3.1] - 2013-06-17
### Bugfixes:
- Docs!

## [0.3.0] - 2013-06-17
### Features:
- PE + POSS support

### Bugfixes:
- Only ensure datadir if it does not have `%{.*}`

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
