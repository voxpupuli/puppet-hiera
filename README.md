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
If you are using Puppet Enterprise and the eyaml backend, you will need the [puppetlabs-pe_gem](https://forge.puppetlabs.com/puppetlabs/pe_gem) module to install the eyaml gem using PE's gem command.

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

For details and valid options [Configuring Hiera][https://docs.puppetlabs.com/hiera/1/configuring.html#global-settings].

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

#### `hierarchy`
Configures the hiera hierarchy. Default is []
#### `backends`
Configures the list of backends. Default is ['yaml']
#### `hiera_yaml`
Configures the path to hiera.yaml
#### `datadir`
Configures the path to the hieradata directory.
#### `datadir_manage`
Enables/disables the datadir file resource
#### `owner`
Sets the owner of the managed files and directories.
#### `group`
Sets the group of the managed files and directories.
#### `eyaml`
Enables/disables the eyaml backend. Default true
#### `eyaml_datadir`
Configures the eyaml data directory. Default is the same as datadir
#### `eyaml_extension`
Configures the eyaml file extension. No default
#### `confdir`
Configures the directory for puppet's confdir.
#### `logger`
Configures the hiera logger. Default is 'console'
#### `merge_behavior`
Configures the hiera merge behavior (e.g. for deep merges). No default
#### `create_keys`
Enables/disables generating pkcs7 keys for use with hiera-eyaml
#### `extra_config`
Accepts arbitrary content to add to the end of hiera.yaml
#### `gem_source`
Configures the Gem source to use for installing hiera-eyaml.

## Limitations

Unknown.

## Development

Pull requests on github! If someone wrote spec tests, that would be awesome.
