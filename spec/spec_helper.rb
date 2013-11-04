require 'rspec-puppet'

fixtures_path = File.expand_path('../../fixtures', __FILE__)

RSpec.configure do |c|
  c.module_path  = File.join(fixtures_path, 'modules')
  c.manifest_dir = File.join(fixtures_path, 'manifests-rspec')
end
