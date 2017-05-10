require 'spec_helper'

describe 'hiera::install' do
  let :pre_condition do
    [
      'include ::hiera'
    ]
  end

  describe 'installing hiera-eyaml' do
    let :title do
      'hiera-eyaml'
    end
    let(:params) do
      {
        'gem_name' => 'hiera-eyaml',
        'provider' => 'puppetserver_gem'
      }
    end

    it { is_expected.to contain_package('hiera-eyaml').with_name('hiera-eyaml') }
    it { is_expected.to contain_package('hiera-eyaml').without_install_options  }

    context 'with gem_install_options' do
      let :pre_condition do
        [
          'class { "hiera": gem_install_options => ["--http_proxy","http://proxy.example.com:3128"]}'
        ]
      end

      it do
        is_expected.to contain_package('hiera-eyaml').with(
          'name'            => 'hiera-eyaml',
          'install_options' => ['--http_proxy', 'http://proxy.example.com:3128']
        )
      end
    end
  end
end
