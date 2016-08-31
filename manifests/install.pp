# Private define
define hiera::install (
  $gem_name,
  $provider,
  $gem_version = undef,
  $gem_source  = undef,
) {
  $gem_ensure = pick($gem_version, 'installed')
  if $provider == 'pe_puppetserver_gem' or $provider == 'puppetserver_gem' {
    if $::puppetversion and versioncmp($::puppetversion, '4.0.0') >= 0 {
      package { "puppetserver ${gem_name}":
        ensure   => $gem_ensure,
        name     => $gem_name,
        provider => $provider,
        source   => $gem_source,
      }
      package { $gem_name:
        ensure   => $gem_ensure,
        provider => 'puppet_gem',
        source   => $gem_source,
      }
      $master_subscribe = [
        Package[$gem_name],
        Package["puppetserver ${gem_name}"],
      ]
    } else {
      Exec {
        path => [
          '/opt/puppetlabs/server/bin',
          '/opt/puppetlabs/puppet/bin',
          '/opt/puppet/bin',
          '/usr/bin',
          '/bin',
        ],
      }
      if $provider == 'puppetserver_gem' {
        $gem_provider = 'gem'
        $puppetserver_gem_dir = '/var/lib/puppet/jruby-gems/gems/'
      } else {
        $gem_provider = 'pe_gem'
        $puppetserver_gem_dir = '/var/opt/lib/pe-puppet-server/jruby-gems/gems/'
      }
      # The puppetserver gem wouldn't install the commandline util, so we do
      # that here (PUP-1073)
      package { $gem_name:
        ensure   => $gem_ensure,
        provider => $gem_provider,
        source   => $gem_source,
      }
      #BUG This can't actually update the gem version if already installed.
      if $gem_version and $gem_version =~ /^\d+\.\d+\.\d+$/ {
        $gem_flag = "--version ${gem_version}"
      } else {
        $gem_flag = undef
      }
      if $gem_source and $gem_source =~ /^http/ {
        # Do not attempt to validate_absolute_path if $gem_source is an URL
        $source_flag = "--local --source ${gem_source}"
      }
      elsif $gem_source {
        # Use a local source, like the package providers would
        validate_absolute_path($gem_source)
        $source_flag = '--local'
      } else {
        $source_flag = undef
      }
      exec { "install puppetserver gem ${gem_name}":
        command => "puppetserver gem install ${source_flag} ${gem_name} ${gem_flag}",
        unless  => "find ${puppetserver_gem_dir} -mindepth 1 -maxdepth 1 -type d -exec basename {} \\; | egrep -q '^${gem_name}-([0-9].?)+$'",
        #unless  => "puppetserver gem list -i '^${name}$'", # Suuuuper slow
      }
      $master_subscribe = Exec["install puppetserver gem ${gem_name}"]
    }
  } else {
    $hiera_package_depedencies = Package[$gem_name]
    package { $gem_name:
      ensure   => $gem_ensure,
      provider => $provider,
      source   => $gem_source,
    }
    $master_subscribe = Package[$gem_name]
  }
  Service <| title == $::hiera::master_service |> {
    subscribe +> $master_subscribe,
  }
}
