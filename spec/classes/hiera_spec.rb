require 'spec_helper'
require 'shared_contexts'

describe 'hiera' do
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
    {:is_pe => true}
  end
  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      #:hierarchy => [],
      #:backends => ["yaml"],
      #:hiera_yaml => $hiera::params::hiera_yaml,
      #:datadir => $hiera::params::datadir,
      #:datadir_manage => true,
      #:owner => $hiera::params::owner,
      #:group => $hiera::params::group,
      #:eyaml => false,
      #:eyaml_datadir => undef,
      #:eyaml_extension => undef,
      #:confdir => $hiera::params::confdir,
      #:logger => "console",
      #:cmdpath => $hiera::params::cmdpath,
      #:create_keys => true,
      #:gem_source => undef,
      #:eyaml_version => undef,
      #:merge_behavior => undef,
      #:extra_config => "",
    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode
  # Puppet::Util::Log.level = :debug
  # Puppet::Util::Log.newdestination(:console)
  it do
    is_expected.to contain_file('/etc/puppetlabs/puppet/hiera.yaml').
             with({"ensure"=>"present",
                   "content"=>/backends/})
  end
  it do
    is_expected.to contain_file('/etc/hiera.yaml').
             with({"ensure"=>"symlink",
                   "target"=>"/etc/puppetlabs/puppet/hiera.yaml"})
  end
  it do
    is_expected.to contain_file('/etc/puppetlabs/puppet/hieradata').
             with({"ensure"=>"directory"})
  end

  describe 'include eyaml' do
    let(:facts) do
      {:is_pe => true}
    end
    # below is a list of the resource parameters that you can override.
    # By default all non-required parameters are commented out,
    # while all required parameters will require you to add a value
    let(:params) do
      {
          :confdir => '/etc/puppetlabs/puppet',
          :eyaml => true,
      }
    end
    it do
      is_expected.to contain_file('/etc/puppetlabs/puppet/hiera.yaml').
                         with({"ensure"=>"present",
                               "content"=>/eyaml/})
    end
    it do
      is_expected.to contain_file('/etc/puppetlabs/puppet/hiera.yaml').
                         with({"ensure"=>"present",
                               "content"=>/pkcs7_private_key: \/etc\/puppetlabs\/puppet\/keys\/private_key.pkcs7.pem/})
    end
    it do
      is_expected.to contain_file('/etc/puppetlabs/puppet/hiera.yaml').
                         with({"ensure"=>"present",
                               "content"=>/pkcs7_public_key:  \/etc\/puppetlabs\/puppet\/keys\/public_key.pkcs7.pem/})
    end
    it do
      is_expected.to contain_file('/etc/puppetlabs/puppet/hiera.yaml').
                         with({"ensure"=>"present",
                               "content"=>/datadir: \/etc\/puppetlabs\/puppet\/hieradata/})
    end
  end
end
