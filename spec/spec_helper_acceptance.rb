# frozen_string_literal: true

require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_puppet_module_via_pmt_on(host, 'puppetlabs-puppetserver_gem')
  unless ENV['BEAKER_provision'] == 'no'
    install_package(host, 'puppetserver')
    on host, 'puppet resource service puppetserver ensure=running'
  end
end

def wait_for_puppetserver(host, max_retries)
  1.upto(max_retries) do |retries|
    on(host, "curl -skIL https://#{host.hostname}:8140", acceptable_exit_codes: [0, 1, 7]) do |result|
      return true if result.stdout =~ %r{HTTP/1\.1 4}

      counter = 2**retries
      logger.debug "Unable to reach Puppet Server, #{host.hostname}, Sleeping #{counter} seconds for retry #{retries}..."
      sleep counter
    end
  end
  raise 'Could not connect to Puppet Server.'
end

def make_site_pp(host, pp, path)
  let(:facts)
  on host, "mkdir -p #{path}"
  create_remote_file(host, File.join(path, 'site.pp'), pp)
  if Facter.value('pe_server_version')
    on host, "chown -R root:root #{path}"
  else
    on host, "chown -R puppet:puppet #{path}"
  end
  on host, "chmod -R 0755 #{path}"
  on host, 'service puppetserver restart'
  wait_for_puppetserver(host, 3)
end
