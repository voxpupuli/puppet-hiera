Testing
-------

This module comes with everything you need to develop infrastructure code with
Puppet and feel confident about it. The provided testing facilities allow you to
iterate quickly on cookbook changes.

After installing Vagrant and the required Ruby gems, most of the testing can be
done through convenient Rake tasks.

### Bundler

Apart from Vagrant, which is described later on, all tools you need for module
development and testing are installed as Ruby gems using [Bundler]. This gives
you a lot of control over the software stack ensuring that the testing
environment matches your production environment.

First, make sure you have Bundler (which is itself a gem):

    $ gem install bundler

Then let Bundler install the required gems (as defined in `Gemfile`):

    $ bundle install

If you like to install the gems locally inside the module, do this instead:

    $ bundle install --path vendor/gems

Now you can use `bundle exec` to execute a command from the gemset, for example:

    $ bundle exec rake test

(You should keep `Gemfile.lock` checked in.)

### Rake

The module provides a couple of helpful [Rake] tasks (specified in `Rakefile`):

    $ rake -T
    rake clean                      # Remove any temporary products.
    rake clobber                    # Remove any generated file.
    rake env                        # Display information about the environment
    rake test:all                   # Run test:lint, test:spec, and test:integration
    rake test:integration           # Run serverspec integration tests with Vagrant
    rake test:integration_teardown  # Tear down VM used for integration tests
    rake test:lint                  # Check manifests with puppet-lint
    rake test:spec                  # Run RSpec examples
    rake test:travis                # Run test:lint and test:spec
    rake vagrant:destroy            # Destroy the VM
    rake vagrant:halt               # Shutdown the VM
    rake vagrant:provision          # Provision the VM using Puppet
    rake vagrant:ssh                # SSH into the VM

As mentioned above, use `bundle exec` to start a Rake task:

    $ bundle exec rake test

The `test` task is an alias for `test:all` and also happens to be the default
when no task is given. All test-related tasks are described in more detail
below.

### puppet-lint

The Rake task `test:lint` will use [puppet-lint] to run lint checks on the
module.

### puppet-rspec

The Rake task `test:spec` will run all RSpec examples in the `spec` directory.
The specs utilize [rspec-puppet].

### serverspec

The Rake task `test:integration` will run [serverspec] integration tests against
a VM managed by Vagrant. The manifest `test/integration/site.pp` is the entry
point for integration testing, while `spec/integration/**/*_spec.rb` are the
actual test files that are run at the end of the provisioning process by ssh'ing
into the VM. For each VM you want to test, there must be a folder with specs in
`spec/integration/` (the default node specs are in `spec/integration/default`).

In case the VM is powered off, `rake test:integration` will boot it up first.
When you no longer need the VM for integration testing, `rake
test:integration_teardown` will shut it down. If you rather want to provision
from scratch, set `INTEGRATION_TEARDOWN` accordingly. For example:

    $ export INTEGRATION_TEARDOWN='vagrant:destroy'
    $ rake test:integration_teardown
    $ rake test:integration

### Vagrant

With [Vagrant], you can spin up a virtual machine and run your module inside it
via Puppet Apply. The test setup requires to install **Vagrant 1.1.x** from the
[Vagrant downloads page].

When everything is in place, this command will boot and provision the VM as
specified in the `Vagrantfile`, using the manifest `test/integration/site.pp` as
the entry point for integration testing:

    $ rake vagrant:provision

Finally, if you no longer need the VM, you can destroy it:

    $ rake vagrant:destroy

See Rake section above for a complete list of all Vagrant-specific tasks.

### Travis CI

The module includes a configuration for [Travis CI] that will run `rake
test:travis` each time changes are pushed to GitHub. Simply enable Travis for
your GitHub repository to get free continuous integration.

Implementing CI with other systems should be as simple as running the commands
in `.travis.yml`.


[Bundler]: http://gembundler.com
[Rake]: http://rake.rubyforge.org
[Travis CI]: https://travis-ci.org
[Vagrant downloads page]: http://downloads.vagrantup.com/
[Vagrant]: http://vagrantup.com
[puppet-lint]: http://puppet-lint.com/
[rspec-puppet]: http://rspec-puppet.com/
[serverspec]: http://serverspec.org/
