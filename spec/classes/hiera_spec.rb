require 'spec_helper'

describe 'hiera' do
  let (:facts) {{ :operatingsystem => 'debian' }}

  context 'with puppet enterprise and default parameters' do
    let (:facts) {{ :puppetversion => 'Puppet Enterprise' }}
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppetlabs/puppet/hieradata').with({
        'ensure' => 'directory',
        'owner'  => 'pe-puppet',
        'group'  => 'pe-puppet',
        'mode'   => '0644',
      })

      should create_file('/etc/puppetlabs/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppetlabs/puppet/hiera.yaml',
      })
    end
  end

  context 'with puppet community edition and default parameters' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{ }}

    it 'properly sets default parameters when called without parameters' do
      should create_file('/etc/puppet/hieradata').with({
        'ensure' => 'directory',
        'owner'  => 'puppet',
        'group'  => 'puppet',
        'mode'   => '0644',
      })

      should create_file('/etc/puppet/hiera.yaml').with({
        'ensure' => 'present',
      })

      should create_file('/etc/hiera.yaml').with({
        'ensure' => 'symlink',
        'target' => '/etc/puppet/hiera.yaml',
      })
    end

    it 'uses the yaml backend by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{backends:\n  - yaml\nlogger:})
    end

    it 'uses an empty hierarchy by default' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{hierarchy:\n\nyaml:})
    end
  end

  context 'with custom backend configuration' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :backends => [ 'foo', 'bar' ],
    }}

    it 'properly configures the given backends' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{backends:\n  - foo\n  - bar\nlogger:})
    end
  end

  context 'with custom hierarchy configuration' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :hierarchy => [ 'bla', 'sausage' ],
    }}

    it 'properly configures the given backends' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{hierarchy:\n  - bla\n  - sausage\nyaml:})
    end
  end

  context 'with extra config beeing a string' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :extra_config => 'blub',
    }}

    it 'properly writes extra_config to config when string given' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{datadir: /etc/puppet/hieradata\n})
    end
  end

  context 'with extra config beeing a hash' do
    let (:facts) {{ :puppetversion => '2.7.23' }}
    let (:params) {{
      :extra_config => {
        'bla' => {
          'foo' => 'foo',
          'bar' => 'bar',
        }
      }
    }}

    it 'properly writes extra_config to config when hash given' do
      should create_file('/etc/puppet/hiera.yaml') \
        .with_content(%r{datadir: /etc/puppet/hieradata\nbla: \n  bar: bar\n  foo: foo\n})
    end
  end

end
