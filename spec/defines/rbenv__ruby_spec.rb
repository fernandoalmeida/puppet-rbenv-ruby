require 'spec_helper'

describe 'rbenv::ruby', type: :define do
  let(:user) { 'root' }
  let(:version) { '2.0.0-p247' }
  let(:level) { "#{user}_#{version}" }
  let(:title) { level }
  let(:user_home) { "/root" }

  it 'install dependencies' do
    should contain_class('rbenv::dependencies')
  end

  it 'install rbenv' do
    should contain_exec("rbenv_download_#{level}")
             .with_command("git clone git://github.com/sstephenson/rbenv.git #{user_home}/.rbenv")
  end

  it 'configures the rc file' do
    should contain_exec("rbenv_path_#{level}")
             .with_command("echo 'export PATH=\"#{user_home}/.rbenv/bin:\$PATH\"' >> #{user_home}/.profile")
    should contain_exec("rbenv_root_#{level}")
             .with_command("echo 'export RBENV_ROOT=#{user_home}/.rbenv' >> #{user_home}/.profile")
    should contain_exec("rbenv_init_#{level}")
             .with_command("echo 'eval \"$(rbenv init -)\"' >> #{user_home}/.profile")
  end

  it 'install rbenv plugins' do
    should contain_exec("ruby-build_#{level}")
             .with_command("git clone https://github.com/sstephenson/ruby-build.git #{user_home}/.rbenv/plugins/ruby-build")
    should contain_exec("rbenv-bundler_#{level}")
             .with_command("git clone https://github.com/carsomyr/rbenv-bundler.git #{user_home}/.rbenv/plugins/rbenv-bundler")
    should contain_exec("rbenv-gemset_#{level}")
             .with_command("git clone https://github.com/jamis/rbenv-gemset.git #{user_home}/.rbenv/plugins/rbenv-gemset")
    should contain_exec("rbenv-vars_#{level}")
             .with_command("git clone https://github.com/sstephenson/rbenv-vars.git #{user_home}/.rbenv/plugins/rbenv-vars")
    should contain_exec("rbenv-gem-rehash_#{level}")
             .with_command("git clone https://github.com/sstephenson/rbenv-gem-rehash.git #{user_home}/.rbenv/plugins/rbenv-gem-rehash")
    should contain_exec("rbenv-default-gems_#{level}")
            .with_command("git clone https://github.com/sstephenson/rbenv-default-gems.git #{user_home}/.rbenv/plugins/rbenv-default-gems")
  end

  it 'configure default gems' do
    should contain_file("default-gems_#{level}")
             .with_content('bundler')
  end

  it 'install ruby' do
    should contain_exec("ruby-install_#{level}")
            .with_command("rbenv install 2.0.0-p247")
  end

  it 'defines global ruby' do
    should contain_exec("ruby-global_#{level}")
             .with_command("rbenv global 2.0.0-p247")
  end
end
