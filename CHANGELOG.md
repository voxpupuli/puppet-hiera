# Change log
All notable changes to this project will be documented in this file.

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
