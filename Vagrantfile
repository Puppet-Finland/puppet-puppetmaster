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
      s.args = ["-n", "puppetmaster", "-b", "/home/ubuntu"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/ubuntu/modules /vagrant/vagrant/xenial.pp"
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/ubuntu/modules /vagrant/vagrant/default.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
  config.vm.define "puppetserver-strech" do |box|
    box.vm.box = "debian/stretch64"
    box.vm.box_version = "9.3.0"
    box.vm.hostname = "puppetserver-stretch.local"
    box.vm.network "private_network", ip: "192.168.221.202"
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-b", "/home/debian"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/debian/modules /vagrant/vagrant/default.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
  config.vm.define "puppetserver-centos7" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1801.02"
    box.vm.hostname = "puppetserver-centos7.local"
    box.vm.network "private_network", ip: "192.168.221.203"
    box.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-b", "/home/centos"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/centos/modules /vagrant/vagrant/default.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end


end
