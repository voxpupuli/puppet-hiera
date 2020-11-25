require 'spec_helper_acceptance'

describe 'hiera' do
  confdir = '/etc/puppetlabs/puppet'
  datadir = '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
  actualdir = '/etc/puppetlabs/code/environments/production/hieradata'
  manifestsdir = '/etc/puppetlabs/code/environments/production/manifests'
  hierayaml = "#{confdir}/hiera.yaml"

  describe 'puppet apply' do
    it 'creates a hiera.yaml' do
      pp = <<-EOS
      class { 'hiera':
        eyaml              => true,
        merge_behavior     => 'deep',
        puppet_conf_manage => true,
        mode               => '0640',
        hierarchy          => [
          'virtual/%{::virtual}',
          'nodes/%{::trusted.certname}',
          'common',
        ],
      }
      EOS
      apply_manifest_on(default, pp, catch_failures: true)
      apply_manifest_on(default, pp, catch_changes: true)
    end
  end
  describe file(hierayaml), node: default do
    its(:content) do
      is_expected.to match <<-EOS
# managed by puppet
---
:backends:
- eyaml
- yaml

:logger: console

:hierarchy:
  - "?virtual/%{::virtual}"?
  - "?nodes/%{::trusted.certname}"?
  - common

:eyaml:
  :datadir: "?#{datadir}"?
  :pkcs7_private_key: "?#{confdir}/keys/private_key.pkcs7.pem"?
  :pkcs7_public_key: "?#{confdir}/keys/public_key.pkcs7.pem"?

:yaml:
  :datadir: "?#{datadir}"?

:merge_behavior: deep
EOS
    end
  end
  describe 'querying hiera' do
    before :all do
      on default, "mkdir -p #{actualdir}/production"
      on default, "echo myclass::value: 'found output' > #{actualdir}/common.yaml"
    end
    let(:pp) do
      <<-EOS
      class myclass {
        $value = hiera('myclass::value')
        notify { $value: }
      }
      include myclass
      EOS
    end

    it 'finds it on the command line' do
      expect(on(default, 'hiera myclass::value environment=production').stdout.strip).to eq('found output')
    end
    it 'finds it in puppet apply' do
      expect(apply_manifest_on(default, pp, catch_failures: true).stdout.strip).to match(%r{found output})
    end
    it 'finds it in puppet agent' do
      make_site_pp(default, pp, manifestsdir)
      expect(on(default, puppet('agent', '-t', '--server', '$(hostname -f)'), acceptable_exit_codes: [0, 2]).stdout.strip).to match(%r{found output})
    end
  end
end
