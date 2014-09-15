# Hiera Puppet

## Description
This module configures [Hiera](https://github.com/puppetlabs/hiera) for Puppet.

## Usage
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

## Optional configuration
This module will also allow you to configure different options for logger and merge_behaviour.  The default behaviour is to set logger to console and merge behaviour to native.

For details and valid options [Configuring Hiera][https://docs.puppetlabs.com/hiera/1/configuring.html#global-settings].

Note: For merge_behavior if you set deep or deeper you need to ensure the deep_merge Ruby gem is installed.

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

