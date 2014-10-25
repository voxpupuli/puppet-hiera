def proj_dir
  File.absolute_path File.join File.dirname(__FILE__), '..'
end

$LOAD_PATH.unshift File.join(proj_dir, 'lib')

require 'puppet'
require 'rspec-puppet'
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.before :each do
    Puppet::Util::Log.level = :warning
    Facter::Util::Loader.any_instance.stubs(:load_all)
    Facter.clear
    Facter.clear_messages
  end
end
