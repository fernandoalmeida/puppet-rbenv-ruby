Exec {
  path => $path
}

rbenv::ruby {'ruby2-vagrant':
  user => 'vagrant',
  version => '2.0.0-p247'
}
