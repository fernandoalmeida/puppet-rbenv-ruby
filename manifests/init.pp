# == Class: rbenv-ruby
#
# A Puppet module for installing and configuring Ruby with Rbenv.
#
# === Examples
#
#  class {"rbenv-ruby":
#    user    => "fernando",
#    version => "2.0.0-p247"
#  }
#
#  or
#
#  class {"rbenv-ruby":
#    user    => "root",
#    version => "2.0.0-p247",
#    install_dir => "/root"
#  }
#
# === Author
#
# Fernando Almeida <fernando@fernandoalmeida.net>
# 
# === Copyleft
# 
# (ɔ) Copyleft 2013 Fernando Almeida
#
class rbenv-ruby(
    $user,
    $version,
    $install_dir = "/home/${user}",
    $config_file = "${install_dir}/.profile"
  ) {

  $packages = [
               "zlib1g",
               "zlib1g-dev",
               "libssl-dev",
               "libreadline6",
               "libreadline6-dev",
               "libyaml-dev",
               "libxml2-dev",
               "libxslt-dev",
               "build-essential",
               "git-core",
               "curl",
               "openssl",
               ]

  package { $packages:
    ensure => installed,
  }->
  exec {"rbenv_download":
    command => "git clone git://github.com/sstephenson/rbenv.git ${install_dir}/.rbenv",
    creates => "${install_dir}/.rbenv",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv_path":
    command => "echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ${config_file}",
    user    => $user,
    group   => $user,
    unless  => "cat ${config_file} | grep rbenv",
  }->
  exec {"rbenv_root":
    command => "echo 'export RBENV_ROOT=\"\$HOME/.rbenv\"' >> ${config_file}",
    user    => $user,
    group   => $user,
    unless  => "cat ${config_file} | grep RBENV_ROOT",
  }->
  exec {"rbenv_init":
    environment => "RBENV_ROOT=${install_dir}/.rbenv",
    path        => "${install_dir}/.rbenv/bin:$path",
    command     => "rbenv init - >> ${config_file}",
    user        => $user,
    group       => $user,
    unless      => "cat ${config_file} | grep \'rbenv()\'",
  }->
  exec {"ruby-build":
    command => "git clone https://github.com/sstephenson/ruby-build.git ${install_dir}/.rbenv/plugins/ruby-build",
    creates => "${install_dir}/.rbenv/plugins/ruby-build",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv-bundler":
    command => "git clone https://github.com/carsomyr/rbenv-bundler.git ${install_dir}/.rbenv/plugins/rbenv-bundler",
    creates => "${install_dir}/.rbenv/plugins/rbenv-bundler",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv-gemset":
    command => "git clone https://github.com/jamis/rbenv-gemset.git ${install_dir}/.rbenv/plugins/rbenv-gemset",
    creates => "${install_dir}/.rbenv/plugins/rbenv-gemset",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv-vars":
    command => "git clone https://github.com/sstephenson/rbenv-vars.git ${install_dir}/.rbenv/plugins/rbenv-vars",
    creates => "${install_dir}/.rbenv/plugins/rbenv-vars",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv-gem-rehash":
    command => "git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${install_dir}/.rbenv/plugins/rbenv-gem-rehash",
    creates => "${install_dir}/.rbenv/plugins/rbenv-gem-rehash",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv-default-gems":
    command => "git clone https://github.com/sstephenson/rbenv-default-gems.git ${install_dir}/.rbenv/plugins/rbenv-default-gems",
    creates => "${install_dir}/.rbenv/plugins/rbenv-default-gems",
    user    => $user,
    group   => $user,
  }->
  file {'default-gems':
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => "0644",
    path    => "${install_dir}/.rbenv/default-gems",
    content => "
    bundler
    ",
  }->
  exec {"ruby-install":
    environment => "RBENV_ROOT=${install_dir}/.rbenv",
    path        => "${install_dir}/.rbenv/bin:$path",
    command => "rbenv install ${version}",
    user    => $user,
    group   => $user,
    creates => "${install_dir}/.rbenv/versions/${version}",
    timeout => 0,
  }->
  exec {"ruby-global":
    environment => "RBENV_ROOT=${install_dir}/.rbenv",
    path        => "${install_dir}/.rbenv/bin:$path",
    command => "rbenv global ${version}",
    user    => $user,
    group   => $user,
    unless  => "${install_dir}/.rbenv/bin/rbenv versions | grep '* ${version}'",
  }
  
}
