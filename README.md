# Hiera Puppet
[![Puppet Forge](http://img.shields.io/puppetforge/v/hunner/hiera.svg)](https://forge.puppetlabs.com/hunner/hiera)
####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hiera](#setup)
    * [What hiera affects](#what-hiera-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hiera](#beginning-with-hiera)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description
This module configures [Hiera](https://github.com/puppetlabs/hiera) for Puppet.

## Setup

### What hiera affects
- Hiera yaml file
- Hiera datadir
- hiera-eyaml package
- keys/ directory for eyaml
- /etc/hiera.yaml for symlink

### Setup requirements
If you are using Puppet Enterprise and the eyaml backend, you will need the [puppetlabs-pe_gem](https://forge.puppetlabs.com/puppetlabs/pe_gem) module to install the eyaml gem using PE's gem command. If you are using a PE version with puppetserver (3.7 and later) you will also need the [puppetlabs-pe_puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/pe_puppetserver_gem) module.

Otherwise you just need puppet.

### Beginning with hiera

Declaring the class with a given hierarchy is a pretty good starting point:

This class will write out a hiera.yaml file in either /etc/puppetlabs/puppet/hiera.yaml or /etc/puppet/hiera.yaml (depending on if the node is running Puppet Enterprise or not).

```puppet
class { 'hiera':
  hierarchy => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
}
```

The resulting output in /etc/puppet/hiera.yaml:
```yaml
---
:backends: 
  - yaml
:logger: console
:hierarchy:
  - "%{environment}/%{calling_class}"
  - "%{environment}"
  - common

:yaml:
   :datadir: /etc/puppet/hieradata
```

## Usage

## Reference
This module will also allow you to configure different options for logger and merge_behaviour.  The default behaviour is to set logger to console and merge behaviour to native.

For details and valid options see [Configuring Hiera](https://docs.puppetlabs.com/hiera/1/configuring.html#global-settings).

Note: For `merge_behavior` if you set deep or deeper you need to ensure the deep_merge Ruby gem is installed.

```puppet
class { 'hiera':
  hierarchy => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
  logger    => 'console',
  merge_behavior => 'deep'
}
```

The resulting output in /etc/puppet/hiera.yaml:
```yaml
---
:backends:
  - yaml
:logger: console
:hierarchy:
  - "%{environment}/%{calling_class}"
  - "%{environment}"
  - common

:yaml:
   :datadir: /etc/puppet/hieradata
:merge_behavior: deep
```

### Classes

#### Public Classes
- hiera: Main class to configure hiera

#### Private Classes
- hiera::params: Handles variable conditionals
- hiera::eyaml: Handles eyaml configuration

### Parameters

The following parameters are available for the hiera class:

* `hierarchy`  
  The hiera hierarchy.  
  Default: `[]`
* `backends`  
  The list of backends.  
  Default: `['yaml']`
* `hiera_yaml`  
  The path to the hiera config file.  
  Default:
    * `'/etc/puppet/hiera.yaml'` for Puppet Open Source
    * `'/etc/puppetlabs/puppet/hiera.yaml'` for Puppet Enterprise
* `datadir`  
  The path to the directory where hiera will look for databases.  
  Default:
    * `'/etc/puppet/hieradata'` for Puppet Open Source
    * `'/etc/puppetlabs/puppet/hieradata'` for Puppet Enterprise
* `datadir_manage`  
  Whether to create and manage the datadir as a file resource.  
  Default: `true`
* `owner`  
  The owner of managed files and directories.  
  Default:
    * `'puppet'` for Puppet Open Source
    * `'pe-puppet'` for Puppet Enterprise
* `group`  
  The group owner of managed files and directories.  
  Default:
    * `'puppet'` for Puppet Open Source
    * `'pe-puppet'` for Puppet Enterprise
* `eyaml`  
  Whether to install, configure, and enable [the eyaml backend][eyaml].  
  Default: `false`
* `eyaml_datadir`  
  The path to the directory where hiera will look for databases with the eyaml backend.  
  Default: same as `datadir`
* `eyaml_extension`  
  The file extension for the eyaml backend.  
  Default: `undef`, backend defaults to `'.eyaml'`
* `eyaml_version`  
  The version of hiera-eyaml to install. Accepts 'installed', 'latest', '2.0.7', etc  
  Default: `undef`
* `confdir`  
  The path to Puppet's confdir.  
  Default:
    * `'/etc/puppet'` for Puppet Open Source
    * `'/etc/puppetlabs/puppet'` for Puppet Enterprise
* `logger`  
  Which hiera logger to use.  
  **Note**: You need to manage any package/gem dependencies yourself.  
  Default: `undef`, hiera defaults to `'console'`
* `cmdpath`  
  Search paths for command binaries, like the `eyaml` command.  
  The default should cover most cases.  
  Default: `['/opt/puppet/bin', '/usr/bin', '/usr/local/bin']`
* `create_keys`  
  Whether to create pkcs7 keys and manage key files for hiera-eyaml.  
  This is useful if you need to distribute a pkcs7 key pair.  
  Default: `true`
* `gem_source`  
  An alternate gem source for installing hiera-eyaml.  
  Default: `undef`, uses gem backend default
* `merge_behavior`  
  Which hiera merge behavior to use.  
  **Note**: You need to manage any package/gem dependencies yourself.  
  Default: `undef`, hiera defaults to `'native'`
* `extra_config`  
  Arbitrary YAML content to append to the end of the hiera.yaml config file.  
  This is useful for configuring backend-specific parameters.  
  Default: `''`

[eyaml]: https://github.com/TomPoulton/hiera-eyaml

## Limitations

The pe-puppetserver service must be restarted after hiera-eyaml is installed; this module will not do it for you. The `eyaml_version` parameter does not currently modify the eyaml version of the command-line gem on pe-puppetserver.

## Development

Pull requests on github! If someone wrote spec tests, that would be awesome.
