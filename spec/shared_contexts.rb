# optional, this should be the path to where the hiera data config file is in this repo
# You must update this if your actual hiera data lives inside your module.
# I only assume you have a separate repository for hieradata and its include in your .fixtures
hiera_config_file = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures','modules','hieradata', 'hiera.yaml'))

# hiera_config and hiera_data are mutually exclusive contexts.

shared_context :global_hiera_data do
  let(:hiera_data) do
     {
       #"hiera::backends" => '',
       #"hiera::cmdpath" => '',
       #"hiera::confdir" => '/etc/puppetlabs/puppet',
       #"hiera::create_keys" => '',
       #"hiera::datadir" => '',
       #"hiera::datadir_manage" => '',
       #"hiera::extra_config" => '',
       #"hiera::eyaml" => '',
       #"hiera::eyaml::cmdpath" => '',
       #"hiera::eyaml::confdir" => '',
       #"hiera::eyaml::create_keys" => '',
       #"hiera::eyaml::eyaml_version" => '',
       #"hiera::eyaml::gem_source" => '',
       #"hiera::eyaml::group" => '',
       #"hiera::eyaml::owner" => '',
       #"hiera::eyaml::provider" => '',
       #"hiera::eyaml_datadir" => '',
       #"hiera::eyaml_extension" => '',
       #"hiera::eyaml_version" => '',
       #"hiera::gem_source" => '',
       #"hiera::group" => '',
       #"hiera::hiera_yaml" => '',
       #"hiera::hierarchy" => '',
       #"hiera::logger" => '',
       #"hiera::merge_behavior" => '',
       #"hiera::owner" => '',
     
     }
  end
end

shared_context :hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

shared_context :linux_hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

# In case you want a more specific set of mocked hiera data for windows
shared_context :windows_hiera do
    # example only,
    let(:hiera_data) do
        {:some_key => "some_value" }
    end
end

# you cannot use this in addition to any of the hiera_data contexts above
shared_context :real_hiera_data do
    let(:hiera_config) do
       hiera_config_file
    end
end
