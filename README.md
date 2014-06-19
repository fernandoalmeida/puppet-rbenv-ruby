puppet-rbenv
==============

A Puppet module for installing and configuring Ruby with Rbenv

Usage
--------------

    class {"rbenv":
      user => "fernando",
      ruby => "2.0.0-p247",
    }
    
    # or
    
    class {"rbenv-ruby":
      user    => "root",
      ruby    => "2.0.0-p247",
      install => "/root"
    }

License
--------------

Apache License, Version 2.0

Contact
--------------

Fernando Almeida <fernando@fernandoalmeida.net>

Support
--------------

Please log tickets and issues at the (https://github.com/fernandoalmeida/puppet-rbenv/issues)
