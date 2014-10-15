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
end
