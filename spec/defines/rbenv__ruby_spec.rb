require 'spec_helper'

describe 'rbenv::ruby', type: :define do
  let(:title) { 'test' }
  let(:user) { 'test' }
  let(:version) { '2.0.0-p247' }

  it 'install rbenv' do
    should contain_exec("rbenv_download_test_2.0.0-p247")
             .with_command("git clone git://github.com/sstephenson/rbenv.git /home/test/.rbenv")
  end

  it 'configures the rc file' do
    should contain_exec("rbenv_path_test_2.0.0-p247")
             .with_command("echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> /home/test/.profile")
    should contain_exec("rbenv_root_test_2.0.0-p247")
             .with_command("echo 'export RBENV_ROOT=\"\$HOME/.rbenv\"' >> /home/test/.profile")
    should contain_exec("rbenv_init_test_2.0.0-p247")
             .with_command("rbenv init - >> /home/test/.profile")
  end

  it 'install rbenv plugins' do
    should contain_exec("ruby-build_test_2.0.0-p247")
             .with_command("git clone https://github.com/sstephenson/ruby-build.git /home/test/.rbenv/plugins/ruby-build")
    should contain_exec("rbenv-bundler_test_2.0.0-p247")
             .with_command("git clone https://github.com/carsomyr/rbenv-bundler.git /home/test/.rbenv/plugins/rbenv-bundler")
    should contain_exec("rbenv-gemset_test_2.0.0-p247")
             .with_command("git clone https://github.com/jamis/rbenv-gemset.git /home/test/.rbenv/plugins/rbenv-gemset")
    should contain_exec("rbenv-vars_test_2.0.0-p247")
             .with_command("git clone https://github.com/sstephenson/rbenv-vars.git /home/test/.rbenv/plugins/rbenv-vars")
    should contain_exec("rbenv-gem-rehash_test_2.0.0-p247")
             .with_command("git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/test/.rbenv/plugins/rbenv-gem-rehash")
    should contain_exec("rbenv-default-gems_test_2.0.0-p247")
            .with_command("git clone https://github.com/sstephenson/rbenv-default-gems.git /home/test/.rbenv/plugins/rbenv-default-gems")
  end

  it 'configure default gems' do
    should contain_file("default-gems_test_2.0.0-p247")
             .with_content('bundler')
  end

  it 'install ruby' do
    should contain_exec("ruby-install_test_2.0.0-p247")
            .with_command("rbenv install 2.0.0-p247")
  end

  it 'defines global ruby' do
    should contain_exec("ruby-global_test_2.0.0-p247")
             .with_command("rbenv global 2.0.0-p247")
  end
end
