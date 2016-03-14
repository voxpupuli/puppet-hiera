require 'spec_helper'

describe 'hiera' do
  if Puppet.version =~ /(Puppet Enterprise 3|^3)/
    context "foss puppet 3" do
      let(:facts) do
        { :puppetversion => "3.8.5", }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) { {
          :eyaml          => true,
          :merge_behavior => 'deeper',
        } }
        it { should contain_class("hiera::eyaml") }
        it { should contain_class("hiera::deep_merge") }
        it { should contain_package("hiera") }
      end
    end
    context "pe puppet 3" do
      let(:facts) do
        {
          :puppetversion => '3.8.5 (Puppet Enterprise 3.8.0)',
          :is_pe         => true,
          :pe_version    => '3.8.0',
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) { {
          :eyaml          => true,
          :merge_behavior => 'deeper',
        } }
        it { should contain_class("hiera::eyaml") }
        it { should contain_class("hiera::deep_merge") }
      end
    end
  elsif Puppet.version =~ /^4/
    context "foss puppet 4" do
      let(:facts) do
        { :puppetversion => Puppet.version, }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) { {
          :eyaml          => true,
          :merge_behavior => 'deeper',
        } }
        it { should contain_class("hiera::eyaml") }
        it { should contain_class("hiera::deep_merge") }
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
      describe 'other params' do
        let(:params) { {
          :eyaml          => true,
          :merge_behavior => 'deeper',
        } }
        it { should contain_class("hiera::eyaml") }
        it { should contain_class("hiera::deep_merge") }
      end
    end
  end
end
