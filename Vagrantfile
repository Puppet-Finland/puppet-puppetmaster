# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "puppetserver-xenial" do |box|
    box.vm.box = "ubuntu/xenial64"
    box.vm.box_version = "20171118.0.0"
    box.vm.hostname = "puppetserver-xenial.local"
    box.vm.network "private_network", ip: "192.168.221.201"
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-f", "debian", "-o", "xenial", "-b", "/home/ubuntu"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/ubuntu/modules /vagrant/vagrant/xenial.pp"
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/ubuntu/modules /vagrant/vagrant/default.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
end
