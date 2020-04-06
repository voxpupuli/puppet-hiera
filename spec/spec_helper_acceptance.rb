require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppetlabs-puppetserver_gem', '>= 0')
  if ENV['PUPPET_INSTALL_TYPE'] == 'agent' && ENV['BEAKER_provision'] != 'no'
    install_package(host, 'puppetserver')
    on host, puppet('resource', 'service', 'puppetserver', 'ensure=running')
  end
end

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
