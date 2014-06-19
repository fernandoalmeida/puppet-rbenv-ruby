# == Class: rbenv
#
# A Puppet module for installing and configuring Ruby with Rbenv.
#
#
class rbenv(
    $user = $title,
    $group = $user,
    $ruby = '2.0.0-p247',
    $install = '',
    $config = ''
  ) {

  $dir = $install ? { '' => "/home/${user}", default => $install }
  $cfg = $config ? { '' => "${dir}/.rbenv", default => $config }

  $packages = [
    'zlib1g',
    'zlib1g-dev',
    'libssl-dev',
    'libreadline6',
    'libreadline6-dev',
    'libyaml-dev',
    'libxml2-dev',
    'libxslt-dev',
    'build-essential',
    'git-core',
    'curl',
    'openssl'
  ]

  package { $packages:
    ensure => installed
  }->
  exec {'rbenv_download':
    command => "git clone git://github.com/sstephenson/rbenv.git ${dir}/.rbenv",
    creates => "${dir}/.rbenv",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv_path':
    command => "echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> ${config}",
    user    => $user,
    group   => $user,
    unless  => "cat ${config} | grep rbenv"
  }->
  exec {'rbenv_root':
    command => "echo 'export RBENV_ROOT=\"\$HOME/.rbenv\"' >> ${config}",
    user    => $user,
    group   => $user,
    unless  => "cat ${config} | grep RBENV_ROOT"
  }->
  exec {'rbenv_init':
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv init - >> ${config}",
    user        => $user,
    group       => $user,
    unless      => "cat ${config} | grep \'rbenv()\'"
  }->
  exec {'ruby-build':
    command => "git clone
      https://github.com/sstephenson/ruby-build.git
      ${dir}/.rbenv/plugins/ruby-build",
    creates => "${dir}/.rbenv/plugins/ruby-build",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv-bundler':
    command => "git clone
      https://github.com/carsomyr/rbenv-bundler.git
      ${dir}/.rbenv/plugins/rbenv-bundler",
    creates => "${dir}/.rbenv/plugins/rbenv-bundler",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv-gemset':
    command => "git clone
      https://github.com/jamis/rbenv-gemset.git
      ${dir}/.rbenv/plugins/rbenv-gemset",
    creates => "${dir}/.rbenv/plugins/rbenv-gemset",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv-vars':
    command => "git clone
      https://github.com/sstephenson/rbenv-vars.git
      ${dir}/.rbenv/plugins/rbenv-vars",
    creates => "${dir}/.rbenv/plugins/rbenv-vars",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv-gem-rehash':
    command => "git clone
      https://github.com/sstephenson/rbenv-gem-rehash.git
      ${dir}/.rbenv/plugins/rbenv-gem-rehash",
    creates => "${dir}/.rbenv/plugins/rbenv-gem-rehash",
    user    => $user,
    group   => $user
  }->
  exec {'rbenv-default-gems':
    command => "git clone
      https://github.com/sstephenson/rbenv-default-gems.git
      ${dir}/.rbenv/plugins/rbenv-default-gems",
    creates => "${dir}/.rbenv/plugins/rbenv-default-gems",
    user    => $user,
    group   => $user
  }->
  file {'default-gems':
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => '0644',
    path    => "${dir}/.rbenv/default-gems",
    content => '
    bundler
    '
  }->
  exec {'ruby-install':
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv install ${ruby}",
    user        => $user,
    group       => $user,
    creates     => "${dir}/.rbenv/versions/${ruby}",
    timeout     => 0
  }->
  exec {'ruby-global':
    environment => "RBENV_ROOT=${dir}/.rbenv",
    path        => "${dir}/.rbenv/bin:${::path}",
    command     => "rbenv global ${ruby}",
    user        => $user,
    group       => $user,
    unless      => "${dir}/.rbenv/bin/rbenv versions | grep '* ${ruby}'"
  }
}
