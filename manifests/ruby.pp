# == Class: rbenv::ruby
#
# A Puppet module for installing and configuring Ruby with Rbenv.
#
#
define rbenv::ruby(
    $version    = '2.0.0-p247',
    $user       = 'root',
    $group      = $user,
    $systemwide = false
  ) {

  $user_home = user_home($user)

  $rbenv_root = $systemwide ? {
    true    => '/opt/rbenv',
    default => "${user_home}/.rbenv"
  }

  $rcfile = $systemwide ? {
    true    => '/etc/profile.d/rbenv.sh',
    default => "${user_home}/.profile"
  }

  $level = $systemwide ? {
    true    => "systemwide_${version}",
    default => "${user}_${version}"
  }

  require rbenv::dependencies

  exec {"rbenv_download_${level}":
    command => "git clone git://github.com/sstephenson/rbenv.git ${rbenv_root}",
    user    => $user,
    group   => $group,
    creates => $rbenv_root
  }->
  exec {"rbenv_path_${level}":
    command => "echo 'export PATH=\"${rbenv_root}/bin:\$PATH\"' >> ${rcfile}",
    user    => $user,
    group   => $group,
    unless  => "cat ${rcfile} | grep \"${rbenv_root}/bin\""
  }->
  exec {"rbenv_root_${level}":
    command => "echo 'export RBENV_ROOT=${rbenv_root}' >> ${rcfile}",
    user    => $user,
    group   => $group,
    unless  => "cat ${rcfile} | grep RBENV_ROOT"
  }->
  exec {"rbenv_init_${level}":
    command     => "echo 'eval \"\$(rbenv init -)\"' >> ${rcfile}",
    user        => $user,
    group       => $group,
    unless      => "cat ${rcfile} | grep \'rbenv init\'"
  }->
  exec {"ruby-build_${level}":
    command => "git clone https://github.com/sstephenson/ruby-build.git ${rbenv_root}/plugins/ruby-build",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/ruby-build",
  }->
  exec {"rbenv-bundler_${level}":
    command => "git clone https://github.com/carsomyr/rbenv-bundler.git ${rbenv_root}/plugins/rbenv-bundler",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/rbenv-bundler"
  }->
  exec {"rbenv-gemset_${level}":
    command => "git clone https://github.com/jamis/rbenv-gemset.git ${rbenv_root}/plugins/rbenv-gemset",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/rbenv-gemset"
  }->
  exec {"rbenv-vars_${level}":
    command => "git clone https://github.com/sstephenson/rbenv-vars.git ${rbenv_root}/plugins/rbenv-vars",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/rbenv-vars",
  }->
  exec {"rbenv-gem-rehash_${level}":
    command => "git clone https://github.com/sstephenson/rbenv-gem-rehash.git ${rbenv_root}/plugins/rbenv-gem-rehash",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/rbenv-gem-rehash"
  }->
  exec {"rbenv-default-gems_${level}":
    command => "git clone https://github.com/sstephenson/rbenv-default-gems.git ${rbenv_root}/plugins/rbenv-default-gems",
    user    => $user,
    group   => $group,
    creates => "${rbenv_root}/plugins/rbenv-default-gems"
  }->
  file {"default-gems_${level}":
    ensure  => file,
    owner   => $user,
    group   => $group,
    mode    => '0644',
    path    => "${rbenv_root}/default-gems",
    content => 'bundler'
  }->
  exec {"ruby-install_${level}":
    environment => "RBENV_ROOT=${rbenv_root}",
    path        => "${rbenv_root}/bin:${::path}",
    command     => "rbenv install ${version}",
    user        => $user,
    group       => $group,
    timeout     => 0,
    creates     => "${rbenv_root}/versions/${version}"
  }->
  exec {"ruby-global_${level}":
    environment => "RBENV_ROOT=${rbenv_root}",
    path        => "${rbenv_root}/bin:${::path}",
    command     => "rbenv global ${version}",
    user        => $user,
    group       => $group,
    unless      => "${rbenv_root}/bin/rbenv versions | grep '* ${version}'"
  }
}
