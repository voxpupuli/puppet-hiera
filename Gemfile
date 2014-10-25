# Content based on https://github.com/puppetlabs/puppetlabs-stdlib/blob/master/Gemfile

source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place, fake_version = nil)
  if place =~ /^(git[:@][^#]*)#(.*)/
    [fake_version, { :git => $1, :branch => $2, :require => false }].compact
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

group :development, :test do
  gem 'rake',                    :require => false
  gem 'rspec-puppet', '>=1.0.0', :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'puppet-syntax',           :require => false
  gem 'pry',                     :require => false
  gem 'simplecov',               :require => false
  gem 'beaker-rspec',            :require => false
end

group :development do
  gem 'puppet-blacksmith',       :require => false
end

ENV['GEM_FACTER_VERSION'] ||= ENV['FACTER_GEM_VERSION']
facterversion = ENV['GEM_FACTER_VERSION']
if facterversion
    gem 'facter', *location_for(facterversion)
else
    gem 'facter', :require => false
end

ENV['GEM_PUPPET_VERSION'] ||= ENV['PUPPET_GEM_VERSION']
puppetversion = ENV['GEM_PUPPET_VERSION']
if puppetversion
    gem 'puppet', *location_for(puppetversion)
else
    gem 'puppet', :require => false
end
