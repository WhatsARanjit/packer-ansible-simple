Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provision 'file', source: Dir.getwd, destination: '~/'
end
