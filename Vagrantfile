# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "packager" do |box|
    box.vm.box = "ubuntu/xenial64"
    box.vm.box_version = "20171118.0.0"
    box.vm.hostname = "packager.local"
    box.vm.network "private_network", ip: "192.168.221.200"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/ubuntu/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/home/ubuntu/puppetmaster-installer", "-m"]
    end
    box.vm.provision "shell", path: "vagrant/prepare_packager.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
    end
  end

  config.vm.define "puppetserver-xenial" do |box|
    box.vm.box = "ubuntu/xenial64"
    box.vm.box_version = "20171118.0.0"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.201"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/usr/share/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/usr/share/puppetmaster-installer", "-m"]
      s.env = {"RUN_INSTALLER" => ENV['RUN_INSTALLER'],
               "SCENARIO"      => ENV['SCENARIO'] }
    end
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
    box.vm.synced_folder ".", "/usr/share/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/usr/share/puppetmaster-installer", "-m"]
      s.env = {"RUN_INSTALLER" => ENV['RUN_INSTALLER'],
               "SCENARIO"      => ENV['SCENARIO'] }
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end

  config.vm.define "puppetserver-centos7" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1804.02"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.203"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/usr/share/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/usr/share/puppetmaster-installer", "-m"]
      s.env = {"RUN_INSTALLER" => ENV['RUN_INSTALLER'],
               "SCENARIO"      => ENV['SCENARIO'] }
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end

  config.vm.define "puppetserver-proxy" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1801.02"
    box.vm.hostname = "proxy2.local"
    box.vm.network "private_network", ip: "192.168.221.205"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/puppetmaster", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/home/puppetmaster", "-m"]
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 2048
    end
  end

  config.vm.define "puppetserver-bionic" do |box|
    box.vm.box = "ubuntu/bionic64"
    box.vm.box_version = "20180919.0.0"
    box.vm.hostname = "puppet.local"
    box.vm.network "private_network", ip: "192.168.221.206"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/usr/share/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell" do |s|
      s.path = "vagrant/prepare.sh"
      s.args = ["-b", "/usr/share/puppetmaster-installer", "-m"]
      s.env = {"RUN_INSTALLER" => ENV['RUN_INSTALLER'],
               "SCENARIO"      => ENV['SCENARIO'] }
    end
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end
end
