Puppet::Parser::Functions::newfunction(:user_home, :type => :rvalue, :doc => "Returns the user $HOME") do |args|
  Etc.getpwnam(args[0]).dir rescue nil
end
