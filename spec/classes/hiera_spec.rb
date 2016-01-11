require 'spec_helper'

describe 'hiera' do
  if Puppet.version.match(/^(Puppet Enterprise )?3/)
    context "foss puppet 3" do
      let(:facts) do
        { :puppetversion => Puppet.version, }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'eyaml param' do
        let(:params) { { :eyaml => true }}
        it { should contain_class("hiera::eyaml") }
      end
    end
    context "pe puppet 3" do
      let(:facts) do
        {
          :puppetversion => 'Puppet Enterprise 3.8.0',
          :is_pe         => true,
          :pe_version    => '3.8.0',
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'eyaml param' do
        let(:params) { { :eyaml => true }}
        it { should contain_class("hiera::eyaml") }
      end
    end
  elsif Puppet.version.match(/^4/)
    context "foss puppet 4" do
      let(:facts) do
        { :puppetversion => Puppet.version, }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'eyaml param' do
        let(:params) { { :eyaml => true }}
        it { should contain_class("hiera::eyaml") }
      end
    end
    context "pe puppet 2015.2" do
      let(:facts) do
        {
          :puppetversion     => Puppet.version,
          :pe_server_version => '2015.2.1',
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'eyaml param' do
        let(:params) { { :eyaml => true }}
        it { should contain_class("hiera::eyaml") }
      end
    end
  end
end
