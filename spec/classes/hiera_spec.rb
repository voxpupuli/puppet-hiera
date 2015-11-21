require 'spec_helper'

describe 'hiera' do
  context "foss" do
    context "puppet 3" do
      let(:facts) do
        { :puppetversion => '3.7.1', }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'eyaml param' do
        let(:params) { { :eyaml => true }}
        it { should contain_class("hiera::eyaml") }
      end
    end
    context "puppet 4" do
      let(:facts) do
        { :puppetversion => '4.2.0', }
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
  context "pe" do
    context "puppet 3" do
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
    context "puppet 4" do
      let(:facts) do
        {
          :puppetversion => 'Puppet Enterprise 4.0.0',
          :is_pe         => true,
          :pe_version    => '4.0.0',
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
    context "puppet 2015.2" do
      let(:facts) do
        {
          :puppetversion     => '4.2.1',
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
