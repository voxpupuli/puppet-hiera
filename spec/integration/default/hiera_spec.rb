require File.expand_path('../../spec_helper', __FILE__)

describe 'default node' do
  it 'installs sample package' do
    expect(package 'tree').to be_installed
  end

  it 'does something' do
    pending 'Replace this with meaningful tests'
  end
end
