Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-1310-x64-virtualbox-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box"

  config.vm.hostname = "puppet-test"
  config.vm.network "public_network"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "spec/fixtures/manifests"
    puppet.module_path = "../"
    puppet.manifest_file = "site.pp"
    puppet.options = "--verbose"
  end
end
