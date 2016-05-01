require 'beaker-rspec'
require 'beaker/puppet_install_helper'

def wait_for_master(max_retries)
  1.upto(max_retries) do |retries|
    on(master, "curl -skIL https://#{master.hostname}:8140", acceptable_exit_codes: [0, 1, 7]) do |result|
      return true if result.stdout =~ %r{HTTP/1\.1 4}

      counter = 2**retries
      logger.debug "Unable to reach Puppet Master, #{master.hostname}, Sleeping #{counter} seconds for retry #{retries}..."
      sleep counter
    end
  end
  raise 'Could not connect to Puppet Master.'
end

def make_site_pp(pp, path = File.join(master['puppetpath'], 'manifests'))
  on master, "mkdir -p #{path}"
  create_remote_file(master, File.join(path, 'site.pp'), pp)
  on master, "chown -R #{puppet_user(master)}:#{puppet_group(master)} #{path}"
  on master, "chmod -R 0755 #{path}"
  on master, "service #{(master['puppetservice'] || 'puppetserver')} restart"
  wait_for_master(3)
end
# rubocop:enable AbcSize

run_puppet_install_helper
unless ENV['RS_PROVISION'] == 'no' || ENV['BEAKER_provision'] == 'no'
  if ENV['PUPPET_INSTALL_TYPE'] == 'agent'
    pp = <<-EOS
    package { 'puppetserver': ensure => present, }
    service { 'puppetserver': ensure => running, }
    EOS
    apply_manifest_on(master, pp)
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(source: proj_root, module_name: 'hiera')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-inifile'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppetlabs-puppetserver_gem'), acceptable_exit_codes: [0, 1]
    end
  end
end
