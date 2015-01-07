require 'spec_helper'

describe 'rbenv::dependencies' do
  it { should contain_package('zlib1g') }
  it { should contain_package('zlib1g-dev') }
  it { should contain_package('libssl-dev') }
  it { should contain_package('libreadline6') }
  it { should contain_package('libreadline6-dev') }
  it { should contain_package('libyaml-dev') }
  it { should contain_package('libxml2-dev') }
  it { should contain_package('libxslt-dev') }
  it { should contain_package('build-essential') }
  it { should contain_package('git-core') }
  it { should contain_package('curl') }
  it { should contain_package('openssl') }
end
