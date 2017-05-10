require 'spec_helper_acceptance'

describe 'hiera' do
  version = on(master, puppet('--version')).stdout
  case version
  when %r{Puppet Enterprise 3}
    confdir = '/etc/puppetlabs/puppet'
    datadir = "#{confdir}/hieradata"
    actualdir = datadir
    manifestsdir = "#{confdir}/environments/production/manifests"
  when %r{^3}
    confdir = '/etc/puppet'
    datadir = "#{confdir}/hieradata"
    actualdir = datadir
    manifestsdir = "#{confdir}/manifests"
  when %r{^4}
    confdir = '/etc/puppetlabs/puppet'
    datadir = '/etc/puppetlabs/code/environments/%{::environment}/hieradata'
    actualdir = '/etc/puppetlabs/code/environments/production/hieradata'
    manifestsdir = '/etc/puppetlabs/code/environments/production/manifests'
  else
    raise "Unknown puppet version #{version}"
  end
  hierayaml = "#{confdir}/hiera.yaml"

  describe 'puppet apply' do
    it 'creates a hiera.yaml' do
      pp = <<-EOS
      class { 'hiera':
        eyaml              => true,
        merge_behavior     => 'deep',
        puppet_conf_manage => true,
        hierarchy          => [
          'virtual/%{::virtual}',
          'nodes/%{::trusted.certname}',
          'common',
        ],
      }
      EOS
      apply_manifest_on(master, pp, catch_failures: true)
      apply_manifest_on(master, pp, catch_changes: true)
    end
  end
  describe file(hierayaml), node: master do
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

:yaml:
  :datadir: #{datadir}

:eyaml:
  :datadir: #{datadir}
  :pkcs7_private_key: #{confdir}/keys/private_key.pkcs7.pem
  :pkcs7_public_key:  #{confdir}/keys/public_key.pkcs7.pem
EOS
    end
  end
  describe 'querying hiera' do
    before :all do
      on master, "mkdir -p #{actualdir}/production"
      on master, "echo myclass::value: 'found output' > #{actualdir}/common.yaml"
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
      expect(on(master, 'hiera myclass::value environment=production').stdout.strip).to eq('found output')
    end
    it 'finds it in puppet apply' do
      expect(apply_manifest_on(master, pp, catch_failures: true).stdout.strip).to match(%r{found output})
    end
    it 'finds it in puppet agent', if: (master.is_pe? || master[:roles].include?('aio')) do
      make_site_pp(pp, manifestsdir)
      expect(on(master, puppet('agent', '-t', '--server', '$(hostname -f)'), acceptable_exit_codes: [0, 2]).stdout.strip).to match(%r{found output})
    end
  end
end
