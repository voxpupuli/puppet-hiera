require 'spec_helper'

describe 'hiera' do
  if Puppet.version =~ %r{(Puppet Enterprise 3|^3)}
    context 'foss puppet 3' do
      let(:facts) do
        {
          puppetversion: '3.8.6',
          is_pe: false,
          pe_version: '0.0.0'
        }
      end

      describe 'default params' do
        it { is_expected.to compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end

        it { is_expected.to contain_class('hiera::eyaml') }
        it { is_expected.to contain_class('hiera::deep_merge') }
        it { is_expected.to contain_package('hiera') }
      end
      describe 'param manage_package => false' do
        let(:params) do
          {
            eyaml: true,
            eyaml_gpg: true,
            manage_package: false,
            keysdir: '/etc/keys'
          }
        end

        it { is_expected.to compile }
        it { is_expected.not_to contain_hiera__install('eyaml') }
        it { is_expected.not_to contain_hiera__install('ruby_gpg') }
        it { is_expected.not_to contain_hiera__install('hiera-eyaml-gpg') }
        it { is_expected.to contain_exec('createkeys').that_requires('File[/etc/keys]') }
      end
      describe 'param manage_package => true and create_keys => true' do
        let(:params) do
          {
            eyaml: true,
            manage_package: true,
            keysdir: '/etc/keys'
          }
        end

        it { is_expected.to contain_exec('createkeys').that_requires('Hiera::Install[eyaml]').that_requires('File[/etc/keys]') }
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
          it 'does not contain eyaml: section' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).not_to include('eyaml:')
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

          it 'contains an eyaml: section' do
            content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
            expect(content).to include('eyaml:')
          end
          context 'when eyaml_pkcs7_private_key not set (default)' do
            it do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{pkcs7_private_key: /etc/puppet/keys/private_key\.pkcs7\.pem})
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
              expect(content).to match(%r{pkcs7_private_key: /path/to/private\.key})
            end
          end
          context 'when eyaml_pkcs7_public_key not set (default)' do
            it do
              content = catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
              expect(content).to match(%r{pkcs7_public_key: /etc/puppet/keys/public_key\.pkcs7\.pem})
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
              expect(content).to match(%r{pkcs7_public_key: /path/to/public\.key})
            end
          end
        end
      end
      describe 'other_backends' do
        let(:params) do
          {
            merge_behavior: 'deeper',
            eyaml: true,
            datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
            backends: %w[yaml eyaml json yamll],
            'backend_options' => {
              'json' => {
                'datadir' => '/etc/puppet/json_data/data'
              },
              'yamll' => {
                'datadir' => '/etc/puppet/yamll_data/data'
              }
            }
          }
        end
        let(:content) do
          catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
        end

        it 'encoding to not have ruby/sym' do
          expect(content).not_to include('!ruby/sym')
        end

        it 'include backends' do
          backends = YAML.load(content)[:backends]
          expect(backends).to eq(%w[eyaml yaml json yamll])
        end
        it 'include json backend' do
          backend = YAML.load(content)[:json]
          expect(backend[:datadir]).to eq('/etc/puppet/json_data/data')
        end
        it 'include yamll backend' do
          backend = YAML.load(content)[:yamll]
          expect(backend[:datadir]).to eq('/etc/puppet/yamll_data/data')
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'include eyaml backend' do
          eyaml_backend = YAML.load(content)[:eyaml]
          expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
          expect(eyaml_backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
          expect(eyaml_backend[:pkcs7_public_key]).to eq('/etc/puppet/keys/public_key.pkcs7.pem')
          expect(eyaml_backend.keys).not_to include(:encrypt_method)
          expect(eyaml_backend.keys).not_to include(:gpg_gnupghome)
          expect(eyaml_backend.keys).not_to include(:gpg_recipients)
          expect(eyaml_backend.keys).not_to include(:extension)
        end
        context 'include gpg' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              eyaml_gpg: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml eyaml json yamll],
              'backend_options' => {
                'json' => {
                  'datadir' => '/etc/puppet/json_data/data'
                },
                'yamll' => {
                  'datadir' => '/etc/puppet/yamll_data/data'
                }
              }
            }
          end

          it 'include eyaml-gpg backend' do
            eyaml_backend = YAML.load(content)[:eyaml]
            expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
            expect(eyaml_backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
            expect(eyaml_backend[:pkcs7_public_key]).to eq('/etc/puppet/keys/public_key.pkcs7.pem')
            expect(eyaml_backend[:encrypt_method]).to eq('gpg')
            expect(eyaml_backend[:gpg_gnupghome]).to eq('/etc/puppet/keys/gpg')
            expect(eyaml_backend[:gpg_recipients]).to eq(nil)
            expect(eyaml_backend[:extension]).to eq(nil)
          end
        end
        context 'include gpg with eyaml unspecified' do
          let(:params) do
            {
              eyaml_gpg: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml]
            }
          end

          it 'include eyaml-gpg backend with eyaml unspecified' do
            backends = YAML.load(content)[:backends]
            expect(backends).to eq(%w[eyaml yaml])
            eyaml_backend = YAML.load(content)[:eyaml]
            expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
            expect(eyaml_backend[:encrypt_method]).to eq('gpg')
            expect(eyaml_backend[:gpg_gnupghome]).to eq('/etc/puppet/keys/gpg')
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
        context 'bad data' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml yamlll],
              'backend_options' => {
                'yaml' => {
                  'datadir' => '/etc/puppet/yaml_data/data'
                },
                'yamll' => {
                  'datadir' => '/etc/puppet/yamll_data/data'
                }
              }
            }
          end

          it 'throws error' do
            is_expected.to raise_error(Puppet::Error, %r{The\ supplied\ backends:\ \[?yamlll\]?.*})
          end
        end
        context 'override_yaml_data' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              backends: ['yaml'],
              'backend_options' => {
                'yaml' => {
                  'datadir' => '/etc/puppet/yaml_data/data'
                },
                'eyaml' => {
                  'datadir' => '/etc/puppet/eyaml_data/data'
                }
              }
            }
          end

          it 'include yaml backend' do
            backend = YAML.load(content)[:yaml]
            expect(backend[:datadir]).to eq('/etc/puppet/yaml_data/data')
          end
          it 'merge correctly' do
            backend = YAML.load(content)[:eyaml]
            expect(backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
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
        it { is_expected.to compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end

        it { is_expected.to contain_class('hiera::eyaml') }
        it { is_expected.to contain_class('hiera::deep_merge') }
      end
    end
  elsif Puppet.version =~ %r{^4}
    context 'foss puppet 4' do
      let(:facts) do
        {
          puppetversion: Puppet.version,
          is_pe: false,
          pe_version: '0.0.0'
        }
      end

      describe 'default params' do
        it { is_expected.to compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end

        it { is_expected.to contain_class('hiera::eyaml') }
        it { is_expected.to contain_class('hiera::deep_merge') }
      end
      describe 'param manage_package => false' do
        let(:params) do
          {
            eyaml: true,
            eyaml_gpg: true,
            manage_package: false,
            keysdir: '/etc/keys'
          }
        end

        it { is_expected.to compile }
        it { is_expected.not_to contain_hiera__install('eyaml') }
        it { is_expected.not_to contain_hiera__install('ruby_gpg') }
        it { is_expected.not_to contain_hiera__install('hiera-eyaml-gpg') }
        it { is_expected.to contain_exec('createkeys').that_requires('File[/etc/keys]') }
      end
      describe 'param manage_package => true and create_keys => true' do
        let(:params) do
          {
            eyaml: true,
            manage_package: true,
            keysdir: '/etc/keys'
          }
        end

        it { is_expected.to contain_exec('createkeys').that_requires('Hiera::Install[eyaml]').that_requires('File[/etc/keys]') }
      end
      describe 'other_backends' do
        let(:params) do
          {
            merge_behavior: 'deeper',
            eyaml: true,
            datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
            backends: %w[yaml eyaml json yamll],
            'backend_options' => {
              'json' => {
                'datadir' => '/etc/puppet/json_data/data'
              },
              'yamll' => {
                'datadir' => '/etc/puppet/yamll_data/data'
              }
            }
          }
        end
        let(:content) do
          catalogue.resource('file', '/etc/puppet/hiera.yaml').send(:parameters)[:content]
        end

        it 'encoding to not have ruby/sym' do
          expect(content).not_to include('!ruby/sym')
        end

        it 'include backends' do
          backends = YAML.load(content)[:backends]
          expect(backends).to eq(%w[eyaml yaml json yamll])
        end
        it 'include json backend' do
          backend = YAML.load(content)[:json]
          expect(backend[:datadir]).to eq('/etc/puppet/json_data/data')
        end
        it 'include yamll backend' do
          backend = YAML.load(content)[:yamll]
          expect(backend[:datadir]).to eq('/etc/puppet/yamll_data/data')
        end
        # rubocop:disable RSpec/MultipleExpectations
        it 'include eyaml backend' do
          eyaml_backend = YAML.load(content)[:eyaml]
          expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
          expect(eyaml_backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
          expect(eyaml_backend[:pkcs7_public_key]).to eq('/etc/puppet/keys/public_key.pkcs7.pem')
          expect(eyaml_backend.keys).not_to include(:encrypt_method)
          expect(eyaml_backend.keys).not_to include(:gpg_gnupghome)
          expect(eyaml_backend.keys).not_to include(:gpg_recipients)
          expect(eyaml_backend.keys).not_to include(:extension)
        end
        context 'include gpg' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              eyaml_gpg: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml eyaml json yamll],
              'backend_options' => {
                'json' => {
                  'datadir' => '/etc/puppet/json_data/data'
                },
                'yamll' => {
                  'datadir' => '/etc/puppet/yamll_data/data'
                }
              }
            }
          end

          it 'include eyaml-gpg backend' do
            eyaml_backend = YAML.load(content)[:eyaml]
            expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
            expect(eyaml_backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
            expect(eyaml_backend[:pkcs7_public_key]).to eq('/etc/puppet/keys/public_key.pkcs7.pem')
            expect(eyaml_backend[:encrypt_method]).to eq('gpg')
            expect(eyaml_backend[:gpg_gnupghome]).to eq('/etc/puppet/keys/gpg')
            expect(eyaml_backend[:gpg_recipients]).to eq(nil)
            expect(eyaml_backend[:extension]).to eq(nil)
          end
        end
        context 'include gpg with eyaml unspecified' do
          let(:params) do
            {
              eyaml_gpg: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml]
            }
          end

          it 'include eyaml-gpg backend with eyaml unspecified' do
            backends = YAML.load(content)[:backends]
            expect(backends).to eq(%w[eyaml yaml])
            eyaml_backend = YAML.load(content)[:eyaml]
            expect(eyaml_backend[:datadir]).to eq('/etc/puppetlabs/code/environments/%{::environment}/hieradata')
            expect(eyaml_backend[:encrypt_method]).to eq('gpg')
            expect(eyaml_backend[:gpg_gnupghome]).to eq('/etc/puppet/keys/gpg')
          end
        end
        # rubocop:enable RSpec/MultipleExpectations
        context 'bad data' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              datadir: '/etc/puppetlabs/code/environments/%{::environment}/hieradata',
              backends: %w[yaml yamlll],
              'backend_options' => {
                'yaml' => {
                  'datadir' => '/etc/puppet/yaml_data/data'
                },
                'yamll' => {
                  'datadir' => '/etc/puppet/yamll_data/data'
                }
              }
            }
          end

          it 'throws error' do
            is_expected.to raise_error(Puppet::Error, %r{The\ supplied\ backends:\ \[yamlll\].*})
          end
        end
        context 'override_yaml_data' do
          let(:params) do
            {
              merge_behavior: 'deeper',
              eyaml: true,
              backends: ['yaml'],
              'backend_options' => {
                'yaml' => {
                  'datadir' => '/etc/puppet/yaml_data/data'
                },
                'eyaml' => {
                  'datadir' => '/etc/puppet/eyaml_data/data'
                }
              }
            }
          end

          it 'include yaml backend' do
            backend = YAML.load(content)[:yaml]
            expect(backend[:datadir]).to eq('/etc/puppet/yaml_data/data')
          end
          it 'merge correctly' do
            backend = YAML.load(content)[:eyaml]
            expect(backend[:pkcs7_private_key]).to eq('/etc/puppet/keys/private_key.pkcs7.pem')
          end
        end
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
        it { is_expected.to compile.with_all_deps }
      end
      describe 'other params' do
        let(:params) do
          {
            eyaml: true,
            merge_behavior: 'deeper'
          }
        end

        it { is_expected.to contain_class('hiera::eyaml') }
        it { is_expected.to contain_class('hiera::deep_merge') }
      end
    end
  end
end
