require 'spec_helper_acceptance'

describe 'hiera' do
  version = on(master, puppet('--version')).stdout
  case version
  when /Puppet Enterprise 3/
    confdir = '/etc/puppetlabs/puppet'
    manifestsdir = "#{confdir}/manifests"
  when /^3/
    confdir = '/etc/puppet'
    manifestsdir = "#{confdir}/manifests"
  when /^4/
    confdir = '/etc/puppetlabs/code'
    manifestsdir = "#{confdir}/environments/production/manifests"
  else
    fail "Unknown puppet version #{version}"
  end
  hierayaml = "#{confdir}/hiera.yaml"
  datadir = "#{confdir}/hieradata"
  sitepp = File.join(manifestsdir, 'site.pp')

  describe 'puppet apply' do
    it 'creates a hiera.yaml' do
      pp = <<-EOS
      class { 'hiera':
        eyaml     => true,
        hierarchy => [
          '%{environment}/%{calling_class}',
          '%{environment}',
          'common',
        ],
      }
      EOS
      apply_manifest_on(master, pp, :catch_failures => true)
      apply_manifest_on(master, pp, :catch_changes => true)
    end
  end
  describe file(hierayaml), :node => master do
    its(:content) do should eq(<<-EOS
# managed by puppet
---
:backends:
  - eyaml
  - yaml

:logger: console

:hierarchy:
  - "%{environment}/%{calling_class}"
  - "%{environment}"
  - common

:yaml:
  :datadir: #{datadir}

:eyaml:
  :datadir: #{datadir}
  :pkcs7_private_key: #{confdir}/keys/private_key.pkcs7.pem
  :pkcs7_public_key:  #{confdir}/keys/public_key.pkcs7.pem
EOS
      )
    end
  end
  describe 'querying hiera' do
    let(:pp) do
      <<-EOS
      class myclass {
        notify { hiera('myclass::value'): }
      }
      include myclass
      EOS
    end
    before :all do
      on master, "mkdir -p #{datadir}/production"
      on master, "echo myclass::value: 'found output' > #{datadir}/production/myclass.eyaml"
    end
    it 'finds it on the command line' do
      expect(on(master, 'hiera myclass::value environment=production calling_class=myclass').stdout.strip).to eq('found output')
    end
    it 'finds it in puppet apply' do
      expect(apply_manifest_on(master, pp, :catch_failures => true).stdout.strip).to match(%r{found output})
    end
    it 'finds it in puppet agent', :if => (master.is_pe? || master[:roles].include?('aio')) do
      on master, "mkdir -p #{manifestsdir}"
      create_remote_file(master, sitepp, pp)
      sleep(5)
      expect(on(master, puppet('agent', '-t', '--server', '$(hostname -f)'), :acceptable_exit_codes => [0,2]).stdout.strip).to match(%r{found output})
    end
  end
end
