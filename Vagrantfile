# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "puppetserver-xenial" do |box|
    box.vm.box = "ubuntu/xenial64"
    box.vm.box_version = "20171118.0.0"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.201"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/puppetmaster", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-b", "/home/puppetmaster"]
    end
    box.vm.provision "shell", inline: "puppet apply --modulepath /home/puppetmaster/modules /home/puppetmaster/vagrant/xenial.pp"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
  config.vm.define "puppetserver-stretch" do |box|
    box.vm.box = "debian/stretch64"
    box.vm.box_version = "9.4.0"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.202"
    # Disable default rsync shared folder. Some boxes like debian/stretch64
    # require this or the vboxsf mount will fail.
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/puppetmaster", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-b", "/home/puppetmaster"]
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
  config.vm.define "puppetserver-centos7" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1801.02"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.203"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/puppetmaster", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-n", "puppetmaster", "-b", "/home/puppetmaster"]
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
end
