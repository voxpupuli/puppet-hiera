require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
require 'rake/clean'

# These gems aren't always present, for instance
# on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError
end


# Get module name from directory name; strip "puppet-" prefix.
def module_name
  File.basename(File.dirname(__FILE__)).sub(/^[A-Za-z]*?-/, '')
end

# Check for user configuration
MODULE_NAME    = ENV.fetch('MODULE_NAME', module_name)
FIXTURES_PATH  = ENV.fetch('FIXTURES_PATH', 'spec/fixtures')
MODULES_PATH   = File.join(FIXTURES_PATH, 'modules')
MANIFESTS_PATH = File.join(FIXTURES_PATH, 'manifests')
MANIFEST_NAME  = 'site.pp'

# Allow the user to decide what dependancy management framework to use
# Options include r10k, librarian-puppet and standard spec fixtures
DEPENDANCY_MGT = ENV.fetch('DEPENDANCY_MGT', 'fixtures')

if File.exists? 'Puppetfile'
  if not Gem::Specification.find_all_by_name("r10k").empty?
    r10k_bin = Gem::Specification.find_by_name("r10k").gem_dir + "/bin"
  elsif not Gem::Specification.find_all_by_name("librarian-puppet").empty?
    lib_bin = Gem::Specification.find_by_name("librarian-puppet").gem_dir + "/bin"
  end
end

case DEPENDANCY_MGT.downcase
  when 'r10k'
    task :spec_prep => :r10k_spec_prep
  when 'librarian-puppet'
    task :spec_prep => :librarian_spec_prep
  when 'fixtures'
    # Default settings just works with fixtures
end

CLEAN.include(MANIFESTS_PATH, MODULES_PATH, 'doc', 'pkg')
CLOBBER.include('.tmp', '.librarian')


PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true

# use r10k to manage fixtures instead of .fixtures.yml
# offers more possibilities like explict version management, forge
# downloads ...
task :r10k_spec_prep do
  sh 'PUPPETFILE_DIR="./' + MODULES_PATH + '" ' + r10k_bin + '/r10k -v INFO puppetfile install'
  # r10k 1.3.4 does not support using local paths for modules, need to manually create a link
  module_dir = File.join(MODULES_PATH, module_name)
  FileUtils.ln_sf File.dirname(__FILE__), module_dir
end

# use libririan-puppet to manage fixtures instead of .fixtures.yml
# offers more possibilities like explict version management, forge
# downloads ...
task :librarian_spec_prep do
  sh lib_bin + '/librarian-puppet', 'install', '--path', MODULES_PATH, '--destructive'
end

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths

desc "Run syntax, lint, and spec tests."
task :test => [
  :syntax,
  :lint,
  :spec,
]

desc 'Display information about the environment'
task :env do
  {
    :ruby             => 'ruby --version',
    :rubygems         => 'gem --version',
    :bundler          => 'bundle --version',
    :vagrant         => 'vagrant --version',
    :virtualbox       => 'VBoxManage --version',
    :r10k             => 'r10k version',
    :librarian_puppet => 'librarian-puppet version'
  }.each do |key, cmd|
    begin
      result = `#{cmd}`.chomp
    rescue Errno::ENOENT
      result = 'not found'
    end
    puts "  - #{key}: #{result}"
  end
end
