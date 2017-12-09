# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.3.1](https://github.com/voxpupuli/puppet-hiera/tree/v3.3.1) (2017-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v3.3.0...v3.3.1)

**Merged pull requests:**

- Update Setup Requirements [\#210](https://github.com/voxpupuli/puppet-hiera/pull/210) ([krisamundson](https://github.com/krisamundson))
- Release 3.3.0 [\#209](https://github.com/voxpupuli/puppet-hiera/pull/209) ([bastelfreak](https://github.com/bastelfreak))

## [v3.3.0](https://github.com/voxpupuli/puppet-hiera/tree/v3.3.0) (2017-10-16)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v3.2.0...v3.3.0)

**Implemented enhancements:**

- Allow eyaml, eyaml\_gpg and deep\_merge packages to be installed independent of hiera package [\#208](https://github.com/voxpupuli/puppet-hiera/pull/208) ([treydock](https://github.com/treydock))

## [v3.2.0](https://github.com/voxpupuli/puppet-hiera/tree/v3.2.0) (2017-09-17)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Add datadir key for hiera5 hierarchy. [\#204](https://github.com/voxpupuli/puppet-hiera/pull/204) ([disappear89](https://github.com/disappear89))

**Closed issues:**

- Release new tag incorporating \#197, \#200 [\#202](https://github.com/voxpupuli/puppet-hiera/issues/202)

**Merged pull requests:**

- Release 3.2.0 [\#207](https://github.com/voxpupuli/puppet-hiera/pull/207) ([bastelfreak](https://github.com/bastelfreak))

## [v3.1.0](https://github.com/voxpupuli/puppet-hiera/tree/v3.1.0) (2017-08-31)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Hiera5 [\#194](https://github.com/voxpupuli/puppet-hiera/pull/194) ([naeem98](https://github.com/naeem98))

**Fixed bugs:**

- Remove restrictions on custom options hash [\#200](https://github.com/voxpupuli/puppet-hiera/pull/200) ([reidmv](https://github.com/reidmv))
- fail is not a resource type, it's a function. [\#197](https://github.com/voxpupuli/puppet-hiera/pull/197) ([sophomeric](https://github.com/sophomeric))

**Merged pull requests:**

- Release 3.1.0 [\#203](https://github.com/voxpupuli/puppet-hiera/pull/203) ([reidmv](https://github.com/reidmv))
- Minor README.md fixes [\#199](https://github.com/voxpupuli/puppet-hiera/pull/199) ([naeem98](https://github.com/naeem98))

## [v3.0.0](https://github.com/voxpupuli/puppet-hiera/tree/v3.0.0) (2017-05-11)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.4.0...v3.0.0)

**Breaking changes:**

- replace validate\_\* calls with datatypes [\#191](https://github.com/voxpupuli/puppet-hiera/pull/191) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Feature Request: Add Param For Passing Gem Install Options [\#187](https://github.com/voxpupuli/puppet-hiera/issues/187)

**Merged pull requests:**

- Release 3.0.0 [\#196](https://github.com/voxpupuli/puppet-hiera/pull/196) ([alexjfisher](https://github.com/alexjfisher))
- Add gem\_install\_options parameter [\#193](https://github.com/voxpupuli/puppet-hiera/pull/193) ([alexjfisher](https://github.com/alexjfisher))
- Modulesync 0.19.0 [\#185](https://github.com/voxpupuli/puppet-hiera/pull/185) ([bastelfreak](https://github.com/bastelfreak))
- release 2.4.0 [\#184](https://github.com/voxpupuli/puppet-hiera/pull/184) ([bastelfreak](https://github.com/bastelfreak))

## [v2.4.0](https://github.com/voxpupuli/puppet-hiera/tree/v2.4.0) (2017-01-13)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.3.0...v2.4.0)

**Closed issues:**

- deep\_merge\_options are not set when merge\_behavior =\> deeper [\#174](https://github.com/voxpupuli/puppet-hiera/issues/174)
- json backend datadir can not be set [\#152](https://github.com/voxpupuli/puppet-hiera/issues/152)
- Quoting of hierarchy entries only if string starts with percent sign [\#146](https://github.com/voxpupuli/puppet-hiera/issues/146)
- Variables in a single-quote is changed to value - should not be \(according to the README\) [\#141](https://github.com/voxpupuli/puppet-hiera/issues/141)
- Don't notify pe-puppetserver during eyaml installation [\#109](https://github.com/voxpupuli/puppet-hiera/issues/109)

**Merged pull requests:**

- modulesync 0.16.7 [\#183](https://github.com/voxpupuli/puppet-hiera/pull/183) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.16.6 [\#180](https://github.com/voxpupuli/puppet-hiera/pull/180) ([alexjfisher](https://github.com/alexjfisher))
- Bump min version\_requirement for Puppet + deps [\#179](https://github.com/voxpupuli/puppet-hiera/pull/179) ([juniorsysadmin](https://github.com/juniorsysadmin))
- modulesync 0.16.4 [\#178](https://github.com/voxpupuli/puppet-hiera/pull/178) ([bastelfreak](https://github.com/bastelfreak))
- Correct spelling of @merge\_behavior in template [\#176](https://github.com/voxpupuli/puppet-hiera/pull/176) ([antaflos](https://github.com/antaflos))
- Strict variables fix for `pe\_server\_version` [\#175](https://github.com/voxpupuli/puppet-hiera/pull/175) ([alexjfisher](https://github.com/alexjfisher))
- modulesync 0.16.3 [\#173](https://github.com/voxpupuli/puppet-hiera/pull/173) ([bastelfreak](https://github.com/bastelfreak))
- Support deep\_merge\_options with 'deeper' merge\_behavior [\#172](https://github.com/voxpupuli/puppet-hiera/pull/172) ([antaflos](https://github.com/antaflos))
- Do not make files in the gnupg home executable. [\#169](https://github.com/voxpupuli/puppet-hiera/pull/169) ([vStone](https://github.com/vStone))

## [v2.3.0](https://github.com/voxpupuli/puppet-hiera/tree/v2.3.0) (2016-11-07)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.2.0...v2.3.0)

**Closed issues:**

- incompatible changes in version 2.2.0 [\#161](https://github.com/voxpupuli/puppet-hiera/issues/161)
- Problems configuring eyaml-gpg without eyaml [\#158](https://github.com/voxpupuli/puppet-hiera/issues/158)
- manage\_package should exist for eyaml, deep\_merge, etc [\#128](https://github.com/voxpupuli/puppet-hiera/issues/128)

**Merged pull requests:**

- Release 2.3.0 [\#168](https://github.com/voxpupuli/puppet-hiera/pull/168) ([alexjfisher](https://github.com/alexjfisher))
- modulesync 0.15.0 [\#167](https://github.com/voxpupuli/puppet-hiera/pull/167) ([bastelfreak](https://github.com/bastelfreak))
- Update to new is\_expected.to syntax in favor of should [\#166](https://github.com/voxpupuli/puppet-hiera/pull/166) ([vStone](https://github.com/vStone))
- Add missing badges [\#165](https://github.com/voxpupuli/puppet-hiera/pull/165) ([dhoppe](https://github.com/dhoppe))
- Update based on voxpupuli/modulesync\_config 0.14.1 [\#164](https://github.com/voxpupuli/puppet-hiera/pull/164) ([dhoppe](https://github.com/dhoppe))
- Follow manage\_package for all packages \(Fixes \#128\) [\#163](https://github.com/voxpupuli/puppet-hiera/pull/163) ([vStone](https://github.com/vStone))
- make eyaml be the first backend [\#162](https://github.com/voxpupuli/puppet-hiera/pull/162) ([mmckinst](https://github.com/mmckinst))
- modulesync 0.13.0 [\#160](https://github.com/voxpupuli/puppet-hiera/pull/160) ([bbriggs](https://github.com/bbriggs))
- Test when eyaml\_gpg is true and eyaml is unspecified [\#159](https://github.com/voxpupuli/puppet-hiera/pull/159) ([earsdown](https://github.com/earsdown))

## [v2.2.0](https://github.com/voxpupuli/puppet-hiera/tree/v2.2.0) (2016-10-10)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.1.2...v2.2.0)

**Closed issues:**

- Add support for 3rd party backends [\#153](https://github.com/voxpupuli/puppet-hiera/issues/153)

**Merged pull requests:**

- release for version 2.2.0 [\#157](https://github.com/voxpupuli/puppet-hiera/pull/157) ([logicminds](https://github.com/logicminds))
- fixes issue with new backend merge logic [\#156](https://github.com/voxpupuli/puppet-hiera/pull/156) ([logicminds](https://github.com/logicminds))
- modulesync 0.12.8 [\#155](https://github.com/voxpupuli/puppet-hiera/pull/155) ([bastelfreak](https://github.com/bastelfreak))
- Fixes \#153 - Add support for 3rd party backends [\#154](https://github.com/voxpupuli/puppet-hiera/pull/154) ([logicminds](https://github.com/logicminds))
- Modulesync 0.12.4 & Release 2.1.2 [\#151](https://github.com/voxpupuli/puppet-hiera/pull/151) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.2](https://github.com/voxpupuli/puppet-hiera/tree/v2.1.2) (2016-08-31)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.1.1...v2.1.2)

**Merged pull requests:**

- Modify gem\_source handling \(Do not attempt to validate path if gem\_source is an URL\) [\#150](https://github.com/voxpupuli/puppet-hiera/pull/150) ([nbetm](https://github.com/nbetm))

## [v2.1.1](https://github.com/voxpupuli/puppet-hiera/tree/v2.1.1) (2016-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/v2.1.0...v2.1.1)

**Closed issues:**

- masterservice in the Documentation [\#140](https://github.com/voxpupuli/puppet-hiera/issues/140)
- Invalid package provider puppetserver\_gem  [\#138](https://github.com/voxpupuli/puppet-hiera/issues/138)
- hiera.yaml incorrectly rendered on puppet 4 [\#132](https://github.com/voxpupuli/puppet-hiera/issues/132)
- Minor: forge doc says 'masterservice', should be 'master\_service' [\#126](https://github.com/voxpupuli/puppet-hiera/issues/126)
- Does this module work on Windows platform? [\#82](https://github.com/voxpupuli/puppet-hiera/issues/82)
- OS support in metadata? [\#63](https://github.com/voxpupuli/puppet-hiera/issues/63)

**Merged pull requests:**

- Relicense BSD-2-Clause to Apache-2.0 [\#149](https://github.com/voxpupuli/puppet-hiera/pull/149) ([hunner](https://github.com/hunner))
- Modulesync 0.12.2 & Release 2.1.1 [\#148](https://github.com/voxpupuli/puppet-hiera/pull/148) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.11.1 [\#145](https://github.com/voxpupuli/puppet-hiera/pull/145) ([bastelfreak](https://github.com/bastelfreak))
- module is compatible with PE2016.2 [\#144](https://github.com/voxpupuli/puppet-hiera/pull/144) ([vchepkov](https://github.com/vchepkov))
- modulesync 0.11.0 [\#143](https://github.com/voxpupuli/puppet-hiera/pull/143) ([bastelfreak](https://github.com/bastelfreak))
- Update metadata.json to not give dependency errors in puppet3.8 [\#142](https://github.com/voxpupuli/puppet-hiera/pull/142) ([cryptk](https://github.com/cryptk))
- modulesync 0.8.0 [\#139](https://github.com/voxpupuli/puppet-hiera/pull/139) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 0.6.2 [\#137](https://github.com/voxpupuli/puppet-hiera/pull/137) ([bastelfreak](https://github.com/bastelfreak))
- add end-of-line after merge\_behavior [\#136](https://github.com/voxpupuli/puppet-hiera/pull/136) ([vchepkov](https://github.com/vchepkov))
- documentation updates for version 2.1.0 [\#135](https://github.com/voxpupuli/puppet-hiera/pull/135) ([vchepkov](https://github.com/vchepkov))
- Replace `to\_yaml` in hiera.yaml template [\#134](https://github.com/voxpupuli/puppet-hiera/pull/134) ([alexjfisher](https://github.com/alexjfisher))

## [v2.1.0](https://github.com/voxpupuli/puppet-hiera/tree/v2.1.0) (2016-05-21)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/2.0.1...v2.1.0)

**Closed issues:**

- hiera-eyaml-gpg and other gems never installed to puppetserver [\#129](https://github.com/voxpupuli/puppet-hiera/issues/129)
- hiera-eyaml failing to install with puppetserver\_gem as a provider [\#124](https://github.com/voxpupuli/puppet-hiera/issues/124)
- ReadMe incorrect with regards master\_service [\#122](https://github.com/voxpupuli/puppet-hiera/issues/122)
- Permissions issue on hieradata directory w/ vagrant [\#114](https://github.com/voxpupuli/puppet-hiera/issues/114)
- Puppet 4 and Above Use /etc/puppetlabs/code/hiera.yaml as the default location for hiera.yaml [\#97](https://github.com/voxpupuli/puppet-hiera/issues/97)
- Can't specify hiera::hierarchy in hiera [\#92](https://github.com/voxpupuli/puppet-hiera/issues/92)
- eyaml backend config doesn't quite work with 2015.2.3  [\#91](https://github.com/voxpupuli/puppet-hiera/issues/91)
- Hiera::params class attempts to set file ownership to `puppet` under Puppet Enterprise 2015.2 [\#76](https://github.com/voxpupuli/puppet-hiera/issues/76)
- It should be possible to decouple eyaml configuration from package management [\#67](https://github.com/voxpupuli/puppet-hiera/issues/67)
- Merge configuration, gem not installed by hiera module [\#62](https://github.com/voxpupuli/puppet-hiera/issues/62)
- given the predecent of eyaml, maybe we should manage other gems? [\#38](https://github.com/voxpupuli/puppet-hiera/issues/38)
- manage hiera gem|package? [\#20](https://github.com/voxpupuli/puppet-hiera/issues/20)

**Merged pull requests:**

- Update from voxpupuli modulesync\_config\(0.5.1\) [\#131](https://github.com/voxpupuli/puppet-hiera/pull/131) ([jyaworski](https://github.com/jyaworski))
- Fix issue where find returns exit code 0 regardless of a regex match [\#130](https://github.com/voxpupuli/puppet-hiera/pull/130) ([treydock](https://github.com/treydock))
- Add new eyaml\_pkcs7\_public/private\_key params [\#127](https://github.com/voxpupuli/puppet-hiera/pull/127) ([alexjfisher](https://github.com/alexjfisher))
- Allow puppetserver to be used with foss P3 [\#125](https://github.com/voxpupuli/puppet-hiera/pull/125) ([hunner](https://github.com/hunner))
- Release 2.1.0 [\#123](https://github.com/voxpupuli/puppet-hiera/pull/123) ([hunner](https://github.com/hunner))
- proper name for master\_service attribute [\#121](https://github.com/voxpupuli/puppet-hiera/pull/121) ([tuxmea](https://github.com/tuxmea))
- Remove custom eyaml package from test [\#120](https://github.com/voxpupuli/puppet-hiera/pull/120) ([hunner](https://github.com/hunner))
- GH-92: Default to undef for hierarchy on puppet 4+ [\#119](https://github.com/voxpupuli/puppet-hiera/pull/119) ([jyaworski](https://github.com/jyaworski))
- Merge the package management code into one define. [\#117](https://github.com/voxpupuli/puppet-hiera/pull/117) ([hunner](https://github.com/hunner))
- Allow arbitrary name for hiera-eyaml [\#116](https://github.com/voxpupuli/puppet-hiera/pull/116) ([hunner](https://github.com/hunner))
- Allow managing of the hiera package [\#104](https://github.com/voxpupuli/puppet-hiera/pull/104) ([jyaworski](https://github.com/jyaworski))
- Add deep\_merge support. Fixes GH-38 and GH-62 [\#103](https://github.com/voxpupuli/puppet-hiera/pull/103) ([jyaworski](https://github.com/jyaworski))
- adding ability to use eyaml\_gpg on RHEV based systems [\#85](https://github.com/voxpupuli/puppet-hiera/pull/85) ([smbambling](https://github.com/smbambling))

## [2.0.1](https://github.com/voxpupuli/puppet-hiera/tree/2.0.1) (2016-01-28)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/2.0.0...2.0.1)

**Merged pull requests:**

- Release 2.0.1 [\#112](https://github.com/voxpupuli/puppet-hiera/pull/112) ([hunner](https://github.com/hunner))
- Fix rubocop trailing comma and errors [\#111](https://github.com/voxpupuli/puppet-hiera/pull/111) ([hunner](https://github.com/hunner))
- Fixes bug in the latest push from PR \#102, that doesn't use the \_keysdir path when creating keys [\#110](https://github.com/voxpupuli/puppet-hiera/pull/110) ([smbambling](https://github.com/smbambling))

## [2.0.0](https://github.com/voxpupuli/puppet-hiera/tree/2.0.0) (2016-01-27)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.4.1...2.0.0)

**Closed issues:**

- Hierarchy interpolation seems to have changed. [\#108](https://github.com/voxpupuli/puppet-hiera/issues/108)

**Merged pull requests:**

- Update logic for PE 2015.x \(again\) [\#102](https://github.com/voxpupuli/puppet-hiera/pull/102) ([hunner](https://github.com/hunner))

## [1.4.1](https://github.com/voxpupuli/puppet-hiera/tree/1.4.1) (2016-01-08)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.4.0...1.4.1)

**Closed issues:**

- Enable Travis CI [\#96](https://github.com/voxpupuli/puppet-hiera/issues/96)
- Release 1.3.3.... [\#93](https://github.com/voxpupuli/puppet-hiera/issues/93)

**Merged pull requests:**

- Release 1.4.1 [\#101](https://github.com/voxpupuli/puppet-hiera/pull/101) ([hunner](https://github.com/hunner))
- Travis CI [\#100](https://github.com/voxpupuli/puppet-hiera/pull/100) ([rnelson0](https://github.com/rnelson0))
- Add provider to class parameters [\#90](https://github.com/voxpupuli/puppet-hiera/pull/90) ([jyaworski](https://github.com/jyaworski))

## [1.4.0](https://github.com/voxpupuli/puppet-hiera/tree/1.4.0) (2016-01-06)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.3.2...1.4.0)

**Closed issues:**

- versioncmp expects a string value [\#95](https://github.com/voxpupuli/puppet-hiera/issues/95)

**Merged pull requests:**

- Release 1.4.0 [\#99](https://github.com/voxpupuli/puppet-hiera/pull/99) ([hunner](https://github.com/hunner))
- Only pass strings to versioncmp [\#98](https://github.com/voxpupuli/puppet-hiera/pull/98) ([hunner](https://github.com/hunner))
- Added option to switch on/off the creation of the /etc/hiera.yaml [\#88](https://github.com/voxpupuli/puppet-hiera/pull/88) ([crayfishx](https://github.com/crayfishx))
- Fixing 2015.2 handling [\#86](https://github.com/voxpupuli/puppet-hiera/pull/86) ([hunner](https://github.com/hunner))
- restart puppet master [\#71](https://github.com/voxpupuli/puppet-hiera/pull/71) ([vchepkov](https://github.com/vchepkov))

## [1.3.2](https://github.com/voxpupuli/puppet-hiera/tree/1.3.2) (2015-09-14)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.3.1...1.3.2)

**Merged pull requests:**

- Release 1.3.2 [\#81](https://github.com/voxpupuli/puppet-hiera/pull/81) ([hunner](https://github.com/hunner))
- Clean up style of hiera.yaml.erb template [\#80](https://github.com/voxpupuli/puppet-hiera/pull/80) ([reidmv](https://github.com/reidmv))
- Add default compatibility with PE 2015.2.0 [\#79](https://github.com/voxpupuli/puppet-hiera/pull/79) ([reidmv](https://github.com/reidmv))

## [1.3.1](https://github.com/voxpupuli/puppet-hiera/tree/1.3.1) (2015-07-24)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.3.0...1.3.1)

**Closed issues:**

- In Puppet 3.8.0, pe\_puppetserver\_gem provider is not working [\#72](https://github.com/voxpupuli/puppet-hiera/issues/72)

**Merged pull requests:**

- check for eyaml\_version being undef [\#74](https://github.com/voxpupuli/puppet-hiera/pull/74) ([hunner](https://github.com/hunner))

## [1.3.0](https://github.com/voxpupuli/puppet-hiera/tree/1.3.0) (2015-07-23)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.2.0...1.3.0)

**Closed issues:**

- eyaml datadir [\#61](https://github.com/voxpupuli/puppet-hiera/issues/61)
- Generate a new release [\#48](https://github.com/voxpupuli/puppet-hiera/issues/48)
- Allow user to specify version of hiera-eyaml [\#47](https://github.com/voxpupuli/puppet-hiera/issues/47)
- Update Puppet Forge [\#26](https://github.com/voxpupuli/puppet-hiera/issues/26)

**Merged pull requests:**

- make 'eyaml\_datair' same as 'datadir' by default [\#70](https://github.com/voxpupuli/puppet-hiera/pull/70) ([vchepkov](https://github.com/vchepkov))
- Support AIO Puppet 4 [\#68](https://github.com/voxpupuli/puppet-hiera/pull/68) ([Sharpie](https://github.com/Sharpie))
- Fix typo in backends parameter name. [\#66](https://github.com/voxpupuli/puppet-hiera/pull/66) ([gabe-sky](https://github.com/gabe-sky))
- Added support for PE v3.8.0 [\#65](https://github.com/voxpupuli/puppet-hiera/pull/65) ([nbetm](https://github.com/nbetm))
- Fixing broken markdown link [\#64](https://github.com/voxpupuli/puppet-hiera/pull/64) ([tosbourn](https://github.com/tosbourn))

## [1.2.0](https://github.com/voxpupuli/puppet-hiera/tree/1.2.0) (2015-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.1.1...1.2.0)

**Closed issues:**

- restart required when changing hiera.yaml [\#55](https://github.com/voxpupuli/puppet-hiera/issues/55)
- Installing hiera-eyaml on a system that uses Ruby 1.8 results in failure [\#53](https://github.com/voxpupuli/puppet-hiera/issues/53)
- Add support for puppet 3.7 \(puppetserver\) [\#46](https://github.com/voxpupuli/puppet-hiera/issues/46)
- Using hiera to manage hiera [\#17](https://github.com/voxpupuli/puppet-hiera/issues/17)

**Merged pull requests:**

- Add eyaml gem version param [\#60](https://github.com/voxpupuli/puppet-hiera/pull/60) ([hunner](https://github.com/hunner))
- Release 1.2.0 [\#59](https://github.com/voxpupuli/puppet-hiera/pull/59) ([hunner](https://github.com/hunner))
- Terrimonster fix 37 prov [\#58](https://github.com/voxpupuli/puppet-hiera/pull/58) ([hunner](https://github.com/hunner))
- Reformat parameters in README to be more readable [\#57](https://github.com/voxpupuli/puppet-hiera/pull/57) ([elyscape](https://github.com/elyscape))
- Restructure/reformat change log [\#56](https://github.com/voxpupuli/puppet-hiera/pull/56) ([elyscape](https://github.com/elyscape))
- Updates needed for new release. [\#52](https://github.com/voxpupuli/puppet-hiera/pull/52) ([dansajner](https://github.com/dansajner))
- Validate the values of $merge\_behavior [\#51](https://github.com/voxpupuli/puppet-hiera/pull/51) ([tampakrap](https://github.com/tampakrap))
- move unconditional defaults from params to init [\#50](https://github.com/voxpupuli/puppet-hiera/pull/50) ([tampakrap](https://github.com/tampakrap))
- Add gitignore [\#49](https://github.com/voxpupuli/puppet-hiera/pull/49) ([tampakrap](https://github.com/tampakrap))
- Added gem\_source param to allow a custom Gem source used for eyaml [\#44](https://github.com/voxpupuli/puppet-hiera/pull/44) ([acjohnson](https://github.com/acjohnson))
- Adding an option to disable creating keys when enabling hiera-eyaml and [\#42](https://github.com/voxpupuli/puppet-hiera/pull/42) ([mattkirby](https://github.com/mattkirby))

## [1.1.1](https://github.com/voxpupuli/puppet-hiera/tree/1.1.1) (2014-11-21)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.1.0...1.1.1)

**Closed issues:**

- Path to eyaml gem binary is wrong [\#31](https://github.com/voxpupuli/puppet-hiera/issues/31)
- pe\_gem is not listed as a module dependency [\#23](https://github.com/voxpupuli/puppet-hiera/issues/23)

**Merged pull requests:**

- Release 1.1.1 [\#41](https://github.com/voxpupuli/puppet-hiera/pull/41) ([hunner](https://github.com/hunner))
- Make hiera::eyaml defaults come from base class [\#40](https://github.com/voxpupuli/puppet-hiera/pull/40) ([hunner](https://github.com/hunner))
- Adds puppet forge link to readme [\#39](https://github.com/voxpupuli/puppet-hiera/pull/39) ([spuder](https://github.com/spuder))
- Fix key generation [\#37](https://github.com/voxpupuli/puppet-hiera/pull/37) ([emning](https://github.com/emning))
- Add 'managed by puppet' comment to hiera.yaml [\#35](https://github.com/voxpupuli/puppet-hiera/pull/35) ([emning](https://github.com/emning))
- Fix eyaml key permissions [\#34](https://github.com/voxpupuli/puppet-hiera/pull/34) ([emning](https://github.com/emning))
- Update access to $cmdpath [\#32](https://github.com/voxpupuli/puppet-hiera/pull/32) ([benjamink](https://github.com/benjamink))
- Update opensource cmdpath [\#30](https://github.com/voxpupuli/puppet-hiera/pull/30) ([matthm](https://github.com/matthm))

## [1.1.0](https://github.com/voxpupuli/puppet-hiera/tree/1.1.0) (2014-10-15)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.0.2...1.1.0)

**Closed issues:**

- Using a hash for the template [\#21](https://github.com/voxpupuli/puppet-hiera/issues/21)
- manage gems for backends [\#19](https://github.com/voxpupuli/puppet-hiera/issues/19)

**Merged pull requests:**

- We want eyaml to come before yaml by default [\#29](https://github.com/voxpupuli/puppet-hiera/pull/29) ([hunner](https://github.com/hunner))
- Release 1.1.0 [\#28](https://github.com/voxpupuli/puppet-hiera/pull/28) ([hunner](https://github.com/hunner))
- Patch eyaml [\#27](https://github.com/voxpupuli/puppet-hiera/pull/27) ([hunner](https://github.com/hunner))
- Add the ability to configure the eyaml file extension [\#25](https://github.com/voxpupuli/puppet-hiera/pull/25) ([awaxa](https://github.com/awaxa))
- Extend template configuration options \(logger and merge\_behavior\) [\#22](https://github.com/voxpupuli/puppet-hiera/pull/22) ([pjfoley](https://github.com/pjfoley))
- thoroughly tested changes to support hiera-eyaml [\#18](https://github.com/voxpupuli/puppet-hiera/pull/18) ([terrimonster](https://github.com/terrimonster))
- Fix invalid interval warning [\#16](https://github.com/voxpupuli/puppet-hiera/pull/16) ([danieldreier](https://github.com/danieldreier))

## [1.0.2](https://github.com/voxpupuli/puppet-hiera/tree/1.0.2) (2014-05-01)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.0.1...1.0.2)

## [1.0.1](https://github.com/voxpupuli/puppet-hiera/tree/1.0.1) (2014-03-25)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/1.0.0...1.0.1)

**Merged pull requests:**

- Release 1.0.1 [\#14](https://github.com/voxpupuli/puppet-hiera/pull/14) ([hunner](https://github.com/hunner))
- fixed the README [\#12](https://github.com/voxpupuli/puppet-hiera/pull/12) ([dhgwilliam](https://github.com/dhgwilliam))
- Stop Puppet 3 from squawking about variable access [\#11](https://github.com/voxpupuli/puppet-hiera/pull/11) ([hakamadare](https://github.com/hakamadare))

## [1.0.0](https://github.com/voxpupuli/puppet-hiera/tree/1.0.0) (2014-02-27)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.3.1...1.0.0)

**Merged pull requests:**

- Allow arbitrary YAML config [\#6](https://github.com/voxpupuli/puppet-hiera/pull/6) ([dgoodlad](https://github.com/dgoodlad))
- Make backends configurable [\#5](https://github.com/voxpupuli/puppet-hiera/pull/5) ([dgoodlad](https://github.com/dgoodlad))

## [0.3.1](https://github.com/voxpupuli/puppet-hiera/tree/0.3.1) (2013-06-17)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.3.0...0.3.1)

**Merged pull requests:**

- Update the pretty pretty documents. [\#3](https://github.com/voxpupuli/puppet-hiera/pull/3) ([razorsedge](https://github.com/razorsedge))

## [0.3.0](https://github.com/voxpupuli/puppet-hiera/tree/0.3.0) (2013-06-17)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.2.1...0.3.0)

**Merged pull requests:**

- Release 0.3.0 [\#4](https://github.com/voxpupuli/puppet-hiera/pull/4) ([hunner](https://github.com/hunner))
- Add autodetect support for Puppet Open Source as well as Puppet Enterprise. [\#2](https://github.com/voxpupuli/puppet-hiera/pull/2) ([razorsedge](https://github.com/razorsedge))
- Create $datadir only if there are no variables [\#1](https://github.com/voxpupuli/puppet-hiera/pull/1) ([vholer](https://github.com/vholer))

## [0.2.1](https://github.com/voxpupuli/puppet-hiera/tree/0.2.1) (2012-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.2.0...0.2.1)

## [0.2.0](https://github.com/voxpupuli/puppet-hiera/tree/0.2.0) (2012-08-15)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.1.2...0.2.0)

## [0.1.2](https://github.com/voxpupuli/puppet-hiera/tree/0.1.2) (2012-08-14)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.1.1...0.1.2)

## [0.1.1](https://github.com/voxpupuli/puppet-hiera/tree/0.1.1) (2012-08-14)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/0.1.0...0.1.1)

## [0.1.0](https://github.com/voxpupuli/puppet-hiera/tree/0.1.0) (2012-08-14)

[Full Changelog](https://github.com/voxpupuli/puppet-hiera/compare/bb0d846ba7525b64754fa614b75de50e4ad35dbd...0.1.0)



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*