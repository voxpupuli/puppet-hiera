require 'spec_helper'

describe 'hiera' do
  let(:facts) do
    { :puppet_version => '3.7.1', }
  end
  describe 'default params' do
    it { should compile.with_all_deps }
  end
  describe 'eyaml param' do
    let(:params) { { :eyaml => true }}
    it { should contain_class("hiera::eyaml") }
  end
  describe 'eyaml param without create_keys' do
    let(:params) { { :eyaml => true, :create_keys => false }}
    it { should contain_class("hiera::eyaml") }
    it { should contain_file("/etc/puppet/keys") }
    it { should contain_file("/etc/puppet/keys/private_key.pkcs7.pem") }
    it { should contain_file("/etc/puppet/keys/public_key.pkcs7.pem") }
  end
end
