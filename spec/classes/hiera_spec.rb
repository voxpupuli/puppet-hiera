require 'spec_helper'

describe 'hiera' do
  if Puppet.version =~ %r{(Puppet Enterprise 3|^3)}
    context 'foss puppet 3' do
      let(:facts) do
        {
          puppetversion: '3.8.6',
          is_pe: false,
          pe_version: '0.0.0',
          pe_server_version: '0.0.0'
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end
        it { should contain_class('hiera::eyaml') }
        it { should contain_class('hiera::deep_merge') }
        it { should contain_package('hiera') }
      end
      describe 'hiera.yaml template' do
        describe ':hierarchy: section' do
          let(:params) do
            {
              hierarchy: [
                '%{environment}/%{calling_class}',
                '%{environment}',
                'common'
              ]
            }
          end
          it 'renders correctly' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            hierarchy_section  = %(:hierarchy:\n)
            hierarchy_section += %(  - "%{environment}/%{calling_class}"\n)
            hierarchy_section += %(  - "%{environment}"\n)
            hierarchy_section += %(  - common\n)
            expect(content).to include(hierarchy_section)
          end
        end
        context 'when eyaml = false' do
          it 'does not contain :eyaml: section' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).not_to include(':eyaml:')
          end
          it do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).not_to include('pkcs7_private_key')
          end
          it do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).not_to include('pkcs7_public_key')
          end
        end
        context 'when eyaml = true' do
          let(:params) { { eyaml: true } }
          it 'contains an :eyaml: section' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).to include(':eyaml:')
          end
          context 'when eyaml_pkcs7_private_key not set (default)' do
            it do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{:pkcs7_private_key: /etc/puppet/keys/private_key\.pkcs7\.pem})
            end
          end
          context 'when eyaml_pkcs7_private_key set' do
            let(:params) do
              {
                eyaml:                   true,
                eyaml_pkcs7_private_key: '/path/to/private.key'
              }
            end
            it 'uses the provided private key path' do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{:pkcs7_private_key: /path/to/private\.key})
            end
          end
          context 'when eyaml_pkcs7_public_key not set (default)' do
            it do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{:pkcs7_public_key:  /etc/puppet/keys/public_key\.pkcs7\.pem})
            end
          end
          context 'when eyaml_pkcs7_public_key set' do
            let(:params) do
              {
                eyaml:                  true,
                eyaml_pkcs7_public_key: '/path/to/public.key'
              }
            end
            it 'uses the provided public key path' do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{:pkcs7_public_key:  /path/to/public\.key})
            end
          end
        end
      end
    end
    context 'pe puppet 3' do
      let(:facts) do
        {
          puppetversion: '3.8.6 (Puppet Enterprise 3.8.0)',
          is_pe: true,
          pe_version: '3.8.0',
          pe_server_version: '0.0.0'
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end
        it { should contain_class('hiera::eyaml') }
        it { should contain_class('hiera::deep_merge') }
      end
    end
  elsif Puppet.version =~ %r{^4}
    context 'foss puppet 4' do
      let(:facts) do
        {
          puppetversion: Puppet.version,
          is_pe: false,
          pe_version: '0.0.0',
          pe_server_version: '0.0.0'
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end
        it { should contain_class('hiera::eyaml') }
        it { should contain_class('hiera::deep_merge') }
      end
      describe 'hiera.yaml template' do
        describe ':hierarchy: section' do
          let(:params) do
            {
              hierarchy: [
                '%{environment}/%{calling_class}',
                '%{environment}',
                'common'
              ]
            }
          end
          it 'renders correctly' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            hierarchy_section  = %(:hierarchy:\n)
            hierarchy_section += %(  - "%{environment}/%{calling_class}"\n)
            hierarchy_section += %(  - "%{environment}"\n)
            hierarchy_section += %(  - common\n)
            expect(content).to include(hierarchy_section)
          end
        end
      end
    end
    context 'pe puppet 2015.2' do
      let(:facts) do
        {
          puppetversion: Puppet.version,
          pe_server_version: '2015.2.1',
          is_pe: true,
          pe_version: '0.0.0'
        }
      end
      describe 'default params' do
        it { should compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end
        it { should contain_class('hiera::eyaml') }
        it { should contain_class('hiera::deep_merge') }
      end
    end
  end
end
