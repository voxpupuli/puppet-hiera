require 'spec_helper'
require 'shared_contexts'

describe 'hiera::eyaml' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera


  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {:is_pe => true, :puppetversion => '3.8.1', :pe_version => '3.8.1'}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:provider => $hiera::params::provider,
      :owner => 'pe-puppet',
      :group => 'pe-puppet',
      :cmdpath => '/opt/puppet/bin',
      :confdir => '/etc/puppetlabs/puppet',
      :create_keys => true,
      #:eyaml_version => $hiera::eyaml_version,
      #:gem_source => $hiera::gem_source,
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_package('hiera-eyaml').
             with({"ensure"=>"installed",
                   "provider"=>"pe_puppetserver_gem",
                   "source"=>nil})
  end
  it do
    is_expected.to contain_file('/etc/puppetlabs/puppet/keys').
             with({"ensure"=>"directory"})
  end
  it do
    is_expected.to contain_exec('install pe_gem').
             with({"command"=>"/opt/puppet/bin/gem install hiera-eyaml ",
                   "creates"=>"/opt/puppet/bin/eyaml"})
  end
  it do
    is_expected.to contain_exec('eyaml_createkeys').
             with({"user"=>"pe-puppet",
                   "cwd"=>"/etc/puppetlabs/puppet",
                   "command"=>"eyaml createkeys",
                   "path"=>"/opt/puppet/bin",
                   "creates"=>"/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem",
                   "require"=>['Package[hiera-eyaml]', 'File[/etc/puppetlabs/puppet/keys]']})
  end
  it do
    is_expected.to contain_file('/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem').
             with({"ensure"=>"file",
                   "mode"=>"0600",
                   "require"=>"Exec[eyaml_createkeys]"})
  end
  it do
    is_expected.to contain_file('/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem').
             with({"ensure"=>"file",
                   "mode"=>"0644",
                   "require"=>"Exec[eyaml_createkeys]"})
  end
end
