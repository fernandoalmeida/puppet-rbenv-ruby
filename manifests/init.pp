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
# === Authors
#
# Fernando Almeida <fernando@fernandoalmeida.net>
# 
# === Copyright
# 
# Copyright 2013 Fernando Almeida, unless otherwise noted.
#
class rbenv-ruby($user, $version) {
  
  exec {"rbenv_download":
    command => "git clone git://github.com/sstephenson/rbenv.git /home/${user}/.rbenv",
    creates => "/home/${user}/.rbenv",
    user    => $user,
    group   => $user,
  }->
  exec {"rbenv_path":
    command => "echo 'export PATH=\"\$HOME/.rbenv/bin:\$PATH\"' >> /home/${user}/.profile && exec \$SHELL -l",
    user    => $user,
    group   => $user,
    unless  => "cat /home/${user}/.profile | grep rbenv",
  }->
  exec {"rbenv_root":
    command => "echo 'export RBENV_ROOT=\"\$HOME/.rbenv\"' >> /home/${user}/.profile && exec \$SHELL -l",
    user    => $user,
    group   => $user,
    unless  => "cat /home/${user}/.profile | grep RBENV_ROOT",
  }->
  exec {"rbenv_init":
    command     => "/home/${user}/.rbenv/bin/rbenv init - >> /home/${user}/.profile && exec \$SHELL -l",
    user        => $user,
    group       => $user,
    unless      => "cat /home/${user}/.profile | grep 'rbenv()'",
  }->
  exec {"ruby-build":
    command => "git clone https://github.com/sstephenson/ruby-build.git /home/${user}/.rbenv/plugins/ruby-build",
    creates => "/home/${user}/.rbenv/plugins/ruby-build",
    user        => $user,
    group       => $user,
    require     => [ Exec["rbenv_init"] ],
  }->
  exec {"rbenv-gemset":
    command => "git clone https://github.com/jamis/rbenv-gemset.git /home/${user}/.rbenv/plugins/rbenv-gemset",
    creates => "/home/${user}/.rbenv/plugins/rbenv-gemset",
    user        => $user,
    group       => $user,
  }->
  exec {"rbenv-vars":
    command => "git clone https://github.com/sstephenson/rbenv-vars.git /home/${user}/.rbenv/plugins/rbenv-vars",
    creates => "/home/${user}/.rbenv/plugins/rbenv-vars",
    user        => $user,
    group       => $user,
  }->
  exec {"rbenv-gem-rehash":
    command => "git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/${user}/.rbenv/plugins/rbenv-gem-rehash",
    creates => "/home/${user}/.rbenv/plugins/rbenv-gem-rehash",
    user        => $user,
    group       => $user,
  }->
  exec {"rbenv-default-gems":
    command => "git clone https://github.com/sstephenson/rbenv-default-gems.git /home/${user}/.rbenv/plugins/rbenv-default-gems",
    creates => "/home/${user}/.rbenv/plugins/rbenv-default-gems",
    user        => $user,
    group       => $user,
  }->
  file {'default-gems':
    ensure  => file,
    owner   => $user,
    group   => $user,
    mode    => "0644",
    path    => "/home/${user}/.rbenv/default-gems",
    content => "
    bundler
    ",
  }->
  exec {"ruby-install":
    command => "/home/${user}/.rbenv/bin/rbenv install ${version}",
    user    => $user,
    group   => $user,
    creates => "/home/${user}/.rbenv/versions/${version}",
    timeout => 0,
  }->
  exec {"ruby-global":
    command => "/home/${user}/.rbenv/bin/rbenv global ${version}",
    user    => $user,
    group   => $user,
    unless  => "/home/${user}/.rbenv/bin/rbenv versions | grep '* ${version}'",
  }
  
}
