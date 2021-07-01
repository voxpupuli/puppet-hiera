# frozen_string_literal: true

require 'spec_helper'
require 'puppet'

describe 'hiera::eyaml_gpg' do
  context 'default params' do
    let(:pre_condition) do
      'class { "hiera": eyaml_gpg  => true, keysdir => "/dev/null/keys" }'
    end

    it { is_expected.to compile }
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/dev/null/keys') }
    it do
      is_expected.to contain_file('/dev/null/keys/gpg').with(
        'ensure'  => 'directory',
        'ignore'  => 'S.gpg-agent*',
        'recurse' => true,
        'purge'   => false,
        'mode'    => '0600'
      )
    end
    it { is_expected.to contain_package('hiera-eyaml-gpg') }
    it { is_expected.to contain_package('ruby_gpg') }
  end
  context 'eyaml_gpg_gnupghome_recurse is false' do
    let(:pre_condition) do
      'class { "hiera": eyaml_gpg  => true, keysdir => "/dev/null/keys", eyaml_gpg_gnupghome_recurse => false}'
    end

    it do
      is_expected.to contain_file('/dev/null/keys/gpg').with(
        'recurse' => false
      )
    end
  end
end
