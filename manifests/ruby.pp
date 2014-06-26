# == Class: rbenv::ruby
#
# A Puppet module for installing and configuring Ruby with Rbenv.
#
#
define rbenv::ruby(
    $user = $title,
    $group = $user,
    $version = '2.0.0-p247',
    $install_dir = '',
    $config_file = ''
  ) {

  $dir = $install_dir ? {
    '' => "/home/${user}",
    default => $install_dir
  }
  $cfg = $config_file ? {
    '' => "${dir}/.profile",
    default => $config_file
  }

  require rbenv::dependencies

  exec {"rbenv_download_${user}_${version}":
    command => "git clone git://github.com/sstephenson/rbenv.git ${dir}/.rbenv",
    creates => "${dir}/.rbenv",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv_path_${user}_${version}":
    command => "echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ${cfg}",
    user    => $user,
    group   => $user,
    unless  => "cat ${cfg} | grep rbenv"
  }->
  exec {"rbenv_root_${user}_${version}":
    command => "echo 'export RBENV_ROOT=\"\$HOME/.rbenv\"' >> ${cfg}",
    user    => $user,
    group   => $user,
    unless  => "cat ${cfg} | grep RBENV_ROOT"
  }->
  exec {"rbenv_init_${user}_${version}":
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv init - >> ${cfg}",
    user        => $user,
    group       => $user,
    unless      => "cat ${cfg} | grep \'rbenv()\'"
  }->
  exec {"ruby-build_${user}_${version}":
    command => "git clone https://github.com/sstephenson/ruby-build.git ${dir}/.rbenv/plugins/ruby-build",
    creates => "${dir}/.rbenv/plugins/ruby-build",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv-bundler_${user}_${version}":
    command => "git clone https://github.com/carsomyr/rbenv-bundler.git ${dir}/.rbenv/plugins/rbenv-bundler",
    creates => "${dir}/.rbenv/plugins/rbenv-bundler",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv-gemset_${user}_${version}":
    command => "git clone https://github.com/jamis/rbenv-gemset.git ${dir}/.rbenv/plugins/rbenv-gemset",
    creates => "${dir}/.rbenv/plugins/rbenv-gemset",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv-vars_${user}_${version}":
    command => "git clone https://github.com/sstephenson/rbenv-vars.git ${dir}/.rbenv/plugins/rbenv-vars",
    creates => "${dir}/.rbenv/plugins/rbenv-vars",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv-gem-rehash_${user}_${version}":
    command => "git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${dir}/.rbenv/plugins/rbenv-gem-rehash",
    creates => "${dir}/.rbenv/plugins/rbenv-gem-rehash",
    user    => $user,
    group   => $user
  }->
  exec {"rbenv-default-gems_${user}_${version}":
    command => "git clone https://github.com/sstephenson/rbenv-default-gems.git ${dir}/.rbenv/plugins/rbenv-default-gems",
    creates => "${dir}/.rbenv/plugins/rbenv-default-gems",
    user    => $user,
    group   => $user
  }->
  file {"default-gems_${user}_${version}":
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    path    => "${dir}/.rbenv/default-gems",
    content => 'bundler'
  }->
  exec {"ruby-install_${user}_${version}":
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv install ${version}",
    user        => $user,
    group       => $user,
    creates     => "${dir}/.rbenv/versions/${version}",
    timeout     => 0
  }->
  exec {"ruby-global_${user}_${version}":
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv global ${version}",
    user        => $user,
    group       => $user,
    unless      => "${dir}/.rbenv/bin/rbenv versions | grep '* ${version}'"
  }
}
