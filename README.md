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
:backends: - yaml
:logger: console
:hierarchy:
  - "%{environment}/%{calling_class}"
  - "%{environment}"
  - common
:yaml:
   :datadir: /etc/puppet/hieradata
```

## Testing

Everything you need to know about testing this module is explained in
`TESTING.md`.

[![Build Status](https://travis-ci.org/zined/puppet-hiera.png?branch=master)](https://travis-ci.org/zined/puppet-hiera)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
