# Private define
define hiera::install (
  $gem_name,
  $provider,
  $creates_bin = $name,
  $gem_version = undef,
  $gem_source  = undef,
) {
  $gem_ensure = pick($gem_version, 'installed')
  if $provider == 'pe_puppetserver_gem' {
    Exec {
      path => [
        '/opt/puppetlabs/server/bin',
        '/opt/puppetlabs/puppet/bin',
        '/opt/puppet/bin',
        '/usr/bin',
        '/bin',
      ],
    }
    if $::pe_server_version {
      $vendored_gem_creates = "/opt/puppetlabs/puppet/bin/${creates_bin}"
      $puppetserver_gem_creates = "/opt/puppetlabs/server/data/puppetserver/jruby-gems/bin/${creates_bin}"
    } else {
      $vendored_gem_creates = "/opt/puppet/bin/${creates_bin}"
      $puppetserver_gem_creates = "/var/opt/lib/pe-puppet-server/jruby-gems/bin/${creates_bin}"
    }

    # The puppetserver gem wouldn't install the commandline util, so we do
    # that here (PUP-1073)
    #BUG This can't actually update the gem version if already installed.
    if $gem_version and $gem_version =~ /^\d+\.\d+\.\d+$/ {
      $gem_flag = "--version ${gem_version}"
    } else {
      $gem_flag = undef
    }
    if $gem_source {
      # Use a local source, like the package providers would
      validate_absolute_path($gem_source)
      $source_flag = '--local'
    } else {
      $source_flag = undef
    }

    exec { "install ruby gem ${gem_name}":
      command => "gem install ${source_flag} ${gem_name} ${gem_flag}",
      creates => $vendored_gem_creates,
    }

    exec { "install puppetserver gem ${gem_name}":
      command => "puppetserver gem install ${source_flag} ${gem_name} ${gem_flag}",
      creates => $puppetserver_gem_creates,
    }
    $master_subscribe = Exec["install puppetserver gem ${gem_name}"]
  } elsif $provider == 'puppetserver_gem' {
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
    $hiera_package_depedencies = Package[$gem_name]
    package { $gem_name:
      ensure   => $gem_ensure,
      provider => $provider,
      source   => $gem_source,
    }
    $master_subscribe = Package[$gem_name]
  }
  Service <| title == $hiera::master_service |> {
    subscribe +> $master_subscribe,
  }
}
