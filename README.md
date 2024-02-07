# Hiera module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-hiera.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-hiera)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-hiera/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-hiera)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/hiera.svg)](https://forge.puppetlabs.com/puppet/hiera)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/hiera.svg)](https://forge.puppetlabs.com/puppet/hiera)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/hiera.svg)](https://forge.puppetlabs.com/puppet/hiera)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/hiera.svg)](https://forge.puppetlabs.com/puppet/hiera)

#### Table of Contents

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

To use the eyaml backend with the modern puppetserver, you will need the [puppetlabs-puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/puppetserver_gem) module.

### Beginning with hiera

Declaring the class with a given hierarchy is a pretty good starting point:

This class will write out a hiera.yaml file in either
/etc/puppetlabs/puppet/hiera.yaml or /etc/puppet/hiera.yaml (depending on if the
node is running Puppet Enterprise or not).

```puppet
class { 'hiera':
  hierarchy => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
}
```
### For Hiera version 5
```puppet
class { 'hiera':
          hiera_version   =>  '5',
          hiera5_defaults =>  {"datadir" => "data", "data_hash" => "yaml_data"},
          hierarchy       =>  [
                                {"name" =>  "Virtual yaml", "path"  =>  "virtual/%{virtual}.yaml"},
                                {"name" =>  "Nodes yaml", "paths" =>  ['nodes/%{trusted.certname}.yaml', 'nodes/%{osfamily}.yaml']},
                                {"name" =>  "Default yaml file", "path" =>  "common.yaml"},
                              ],
}
```
** Note: For Hiera version 5 when calling the class, please remember to pass '5' to 'hiera_version' as in the example above. **
** Also please note that 'hierarchy' is an array of hash in version 5. **

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
### Resulting output for Hiera 5

```yaml
# hiera.yaml Managed by Puppet
version: 5
defaults:
  datadir: data
  data_hash: yaml_data
hierarchy:

  - name: "Virtual yaml"
    path: "virtual/%{virtual}.yaml"

  - name: "Nodes yaml"
    paths:
      - "nodes/%{trusted.certname}.yaml"
      - "nodes/%{osfamily}.yaml"

  - name: "Default yaml file"
    path: "common.yaml"
```

## Usage

## Reference

This module will also allow you to configure different options for logger and
merge_behavior.  The default behavior is to set logger to console and merge
behavior to native.

For details and valid options see [Configuring Hiera](https://docs.puppetlabs.com/hiera/1/configuring.html#global-settings).

```puppet
class { 'hiera':
  hierarchy      => [
    '%{environment}/%{calling_class}',
    '%{environment}',
    'common',
  ],
  logger         => 'console',
  merge_behavior => 'deeper'
}
```
## For Hiera version 5 please see the example above in beginning with Hiera.

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

:merge_behavior: deeper
```

### Hiera-Eyaml-GPG

The default PKCS#7 encryption scheme used by hiera-eyaml is perfect if only
simple encryption and decryption is needed.

However, if you are in a sizable team it helps to encrypt and decrypt data with
multiple keys. This means that each team member can hold their own private key
and so can the puppetmaster. Equally, each puppet master can have their own key
if desired and when you need to rotate keys for either users or puppet masters,
re-encrypting your files and changing the key everywhere does not need to be
done in lockstep.

#### Requirements

**Note:** This module will create a /gpg sub-directory in the ```$keysdir```.

1. The GPG keyring must be passphraseless on the on the PuppetServer(Master).
1. The GPG keyring must live in the /gpg sub-directory in the ```$keysdir```.
1. The GPG keyring must be owned by the Puppet user. ex: pe-puppet

#### GPG Keyring Creation Tips

##### RNG-TOOLS

When generating a GPG keyring the system requires a good amount of entropy.
To help generate entropy to speed up the process then rng-tools package on RHEL
based systems or equivilent can be used.  Note: Update the ```/etc/sysconfig/rngd```
or equivilent file to set the EXTRAOPTIONS to
```EXTRAOPTIONS="-r /dev/urandom -o /dev/random -t 5"```

##### Keyring Generation

Below is a sample GPG answers file that will assist in generating a
passphraseless key

```bash
cat << EOF >> /tmp/gpg_answers
%echo Generating a Puppet Hiera GPG Key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: ELG-E
Subkey-Length: 4096
Name-Real: Hiera Data
Name-Comment: Hiera Data Encryption
Name-Email: puppet@$(hostname -d)
Expire-Date: 0
%no-ask-passphrase
# Do a commit here, so that we can later print "done" :-)
# %commit
# %echo done
EOF
```

You can then use the GPG answer file to generate your keyring within the
/gpg sub-directory in the ```$keysdir```

```bash
gpg --batch --homedir /etc/puppetlabs/puppet/keys/gpg --gen-key /tmp/gpg_answers
```

#### Usage

```puppet
class { 'hiera':
  hierarchy            => [
    'nodes/%{clientcert}',
    'locations/%{location}',
    'environments/%{applicationtier}',
    'common',
  ],
  eyaml                => true,
  eyaml_gpg            => true,
  eyaml_gpg_recipients => 'sihil@example.com,gtmtech@example.com,tpoulton@example.com',
}
```

The resulting output in /etc/puppet/hiera.yaml:

```yaml
---
:backends:
  - eyaml
  - yaml
:logger: console
:hierarchy:
  - "nodes/%{clientcert}"
  - "locations/%{location}"
  - "environments/%{applicationtier}"
  - common

:yaml:
   :datadir: /etc/puppet/hieradata


:eyaml:
   :datadir: /etc/puppet/hieradata
   :pkcs7_private_key: /etc/puppet/keys/private_key.pkcs7.pem
   :pkcs7_public_key:  /etc/puppet/keys/public_key.pkcs7.pem
   :encrypt_method: "gpg"
   :gpg_gnupghome: "/etc/puppet/keys/gpg"
   :gpg_recipients: "sihil@example.com,gtmtech@example.com,tpoulton@example.com"
```

### Classes

#### Public Classes

- hiera: Main class to configure hiera

#### Private Classes

- hiera::params: Handles variable conditionals
- hiera::eyaml: Handles eyaml configuration

## Limitations

The `eyaml_version` parameter does not currently modify the eyaml version of the
command-line gem on pe-puppetserver.

## Development

Pull requests on github! If someone wrote spec tests, that would be awesome.
