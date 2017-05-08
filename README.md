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

If you are using the eyaml backend on:

* Puppet Enterprise 3.3 or earlier then you will need the [puppetlabs-pe_gem](https://forge.puppetlabs.com/puppetlabs/pe_gem)
  module to install the eyaml gem using PE's gem command.
* Puppet Enterprise 3.7 or 3.8 then you will need the [puppetlabs-pe_puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/pe_puppetserver_gem)
  module.
* Puppet Enterprise 2015.x or FOSS puppetserver then you will need the [puppetlabs-puppetserver_gem](https://forge.puppetlabs.com/puppetlabs/puppetserver_gem)
  module.

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
gpg --batch --homedir /etc/puppetlabs/code-staging/keys/gpg --gen-key /tmp/gpg_answers
```

#### Usage

```puppet
class { 'hiera':
  hierarchy            => [
    'nodes/%{::clientcert}',
    'locations/%{::location}',
    'environments/%{::applicationtier}',
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
  - "nodes/%{::clientcert}"
  - "locations/%{::location}"
  - "environments/%{::applicationtier}"
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

### Parameters

The following parameters are available for the hiera class:

* `hierarchy`
  The hiera hierarchy.
  Default: `[]`
* `backends`
  The list of backends.
  Default: `['yaml']`
  If you supply a additional backend you must also supply the backend data in
  the `backend_options` hash.
* `backend_options`
  An optional hash of backend data for **any** backend.
  Each key in the hash should be the name of the backend as listed in
  the `backends` array.  You can also supply additional settings for the backend
  by passing in a hash.  By default the `yaml` and `eyaml` backend data will be added
  if you enable them via their respective parameters.  Any options you supply
  for `yaml` and `eyaml` backend types will always override other parameters supplied
  to the hiera class for that backend.

  Example hiera data for the backend_options hash:

  ```yaml
  backend_options:
    json:
      datadir: '/etc/puppetlabs/puppet/%{::environment}/jsondata'
    redis:
      password: clearp@ssw0rd        # if your Redis server requires authentication
      port: 6380                     # unless present, defaults to 6379
      db: 1                          # unless present, defaults to 0
      host: db.example.com           # unless present, defaults to localhost
      path: /tmp/redis.sock          # overrides port if unixsocket exists
      soft_connection_failure: true  # bypass exception if Redis server is unavailable; default is false
      separator: /                   # unless present, defaults to :
      deserialize: :json             # Try to deserialize; both :yaml and :json are supported
  ```

  **NOTE:** The backend_options must **not** contain symbols as keys ie `:json:`
  despite the hiera config needing symbols. The template will perform all the
  conversions to symbols in order for hiera to be happy.  Because puppet does
  not use symbols there are minor annoyances when converting back and forth and
  merge data together.
* `hiera_yaml`
  The path to the hiera config file.
  **Note**: Due to a bug, hiera.yaml is not placed in the codedir. Your
  puppet.conf `hiera_config` setting must match the configured value; see also
  `hiera::puppet_conf_manage`
  Default:
    * `'/etc/puppet/hiera.yaml'` for Puppet Open Source
    * `'/etc/puppetlabs/puppet/hiera.yaml'` for Puppet Enterprise
* `create_symlink`
  Whether to create the symlink `/etc/hiera.yaml`
  Default: true
* `datadir`
  The path to the directory where hiera will look for databases.
  Default:
    * `'/etc/puppet/hieradata'` for Puppet Open Source
    * `'/etc/puppetlabs/puppet/hieradata'` for PE Puppet < 4
    * `'/etc/puppetlabs/code/environments/%{::environment}/hieradata'` for Puppet >= 4
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
  Whether to install, configure, and enable [the eyaml backend][eyaml]. Also see
  the provider and master_service parameters.
  Default: `false`
* `eyaml_name`
  The name of the eyaml gem.
  Default: 'hiera-eyaml'
* `eyaml_version`
  The version of hiera-eyaml to install. Accepts 'installed', 'latest', '2.0.7',
  etc
  Default: `undef`
* `eyaml_source`
  An alternate gem source for installing hiera-eyaml.
  Default: `undef`, uses gem backend default
* `eyaml_datadir`
  The path to the directory where hiera will look for databases with the eyaml backend.
  Default: same as `datadir`
* `eyaml_extension`
  The file extension for the eyaml backend.
  Default: `undef`, backend defaults to `'.eyaml'`
* `deep_merge_name`
  The name of the deep_merge gem.
  Default: 'deep\_merge'
* `deep_merge_version`
  The version of deep\_merge to install. Accepts 'installed', 'latest', '2.0.7',
  etc.
  Default: `undef`
* `deep_merge_source`
  An alternate gem source for installing deep_merge.
  Default: `undef`, uses gem backend default
* `deep_merge_options`
  A hash of options to set in hiera.yaml for the deep merge behavior.
  Default: `{}`
* `manage_package`
  A boolean for wether the hiera package should be managed. Defaults to `true` on
  FOSS 3 but `false` otherwise.
* `package_name`
  Specifies the name of the hiera package. Default: 'hiera'
* `package_ensure`
  Specifies the ensure value of the hiera package. Default: 'present'
* `confdir`
  The path to Puppet's confdir.
  Default: `$::settings::confdir` which should be the following:
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
* `merge_behavior`
  Which hiera merge behavior to use. Valid values are 'native', 'deep', and
  'deeper'. Deep and deeper values will install the deep\_merge gem into the
  puppet runtime.
  Default: `undef`, hiera defaults to `'native'`
* `extra_config`
  Arbitrary YAML content to append to the end of the hiera.yaml config file.
  This is useful for configuring backend-specific parameters.
  Default: `''`
* `keysdir`
  Directory for hiera to manage for eyaml keys.
  Default: `$confdir/keys`
  **Note:** If using PE 2013.x+ and code-manager set the keysdir under the
  ```$confdir/code-staging directory``` to allow the code manager to sync the
  keys to all PuppetServers Example:  ```/etc/puppetlabs/code-staging/keys```
* `puppet_conf_manage`
  Whether to manage the puppet.conf `hiera_config` value or not.
  Default: `true`
* `provider`
  Which provider to use to install hiera-eyaml. Can be:
  * `puppetserver_gem` (PE 2015.x or FOSS using puppetserver)
  * `pe_puppetserver_gem` (PE 3.7 or 3.8)
  * `pe_gem` (PE pre-3.7)
  * `puppet_gem` (agent-only gem)
  * `gem` (FOSS using system ruby (ie puppetmaster))
  **Note**: this module cannot detect FOSS puppetserver and you must pass
  `provider => 'puppetserver_gem'` for that to work. See also master_service.
  Default: Depends on puppet version detected as specified above.
* `master_service`
  The service name of the master to restart after package installation or
  hiera.yaml changes.
  **Note**: You must pass `master_service => 'puppetserver'` for FOSS puppetserver
  Default: 'pe-puppetserver' for PE 2015.x, otherwise 'puppetmaster'
* `gem_install_options`
  An array of install options to pass to the gem package resources.  Typically,
  this parameter is used to specify a proxy server. eg
  `gem_install_options => ['--http-proxy', 'http://proxy.example.com:3128']`

[eyaml]: https://github.com/TomPoulton/hiera-eyaml

## Limitations

The `eyaml_version` parameter does not currently modify the eyaml version of the
command-line gem on pe-puppetserver.

## Development

Pull requests on github! If someone wrote spec tests, that would be awesome.
