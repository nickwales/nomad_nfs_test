Vagrant.configure("2") do |config|

 config.vm.define "nfs" do |nfs|
   nfs.vm.box = "ubuntu/bionic64"
   nfs.vm.hostname = "nfs"
   nfs.vm.network "private_network", ip: "192.168.1.10"
   nfs.vm.provision "shell", path: "bootstrap_nfs.sh"   
 end

  config.vm.define "nomad" do |nomad|
    nomad.vm.box = "ubuntu/bionic64"
    nomad.vm.hostname = "nomad"
    nomad.vm.network "private_network", ip: "192.168.1.11"
    nomad.vm.provision "shell", path: "bootstrap_nomad.sh"
  end
end

