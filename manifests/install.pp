# Private define
define hiera::install (
  $gem_name,
  $provider,
  $gem_version         = undef,
  $gem_source          = undef,
  $gem_install_options = $hiera::gem_install_options,
) {
  # $gem_install_options is typically used for specifying a proxy
  Package {
    install_options => $gem_install_options,
  }

  $gem_ensure = pick($gem_version, 'installed')
  if $provider == 'pe_puppetserver_gem' or $provider == 'puppetserver_gem' {
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
