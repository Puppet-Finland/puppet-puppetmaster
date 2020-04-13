# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "packager" do |box|
    box.vm.box = "ubuntu/bionic64"
    box.vm.box_version = "20200402.0.0"
    box.vm.hostname = "packager.local"
    box.vm.network "private_network", ip: "192.168.221.200"
    box.vm.synced_folder ".", "/vagrant", type: "rsync", disabled: true
    box.vm.synced_folder ".", "/home/ubuntu/puppetmaster-installer", type: "virtualbox"
    box.vm.provision "shell", path: "vagrant/prepare_packager.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 1024
    end
  end

  config.vm.define "puppetserver-buster" do |box|
    box.vm.box = "debian/contrib-buster64"
    box.vm.box_version = "10.3.0"
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
    box.vm.provision "shell", path: "vagrant/install_keys.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end

  config.vm.define "puppetserver-centos7" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "1905.1"
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
    box.vm.provision "shell", path: "vagrant/install_keys.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end

  config.vm.define "puppetserver-proxy" do |box|
    box.vm.box = "centos/7"
    box.vm.box_version = "2020.01"
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
    box.vm.box_version = "20200402.0.0"
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
    box.vm.provision "shell", path: "vagrant/install_keys.sh"
    box.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.memory = 4096
    end
  end

  config.vm.define "puppetserver-bionic-aws" do |box|
    # Create an empty file to keep vagrant-aws happy
    dummy_keypair_path = "/tmp/.puppetserver-bionic-aws-dummy-keypair"
    dummy_keypair = File.new(dummy_keypair_path, "w")
    dummy_keypair.close

    # Set dummy values to allow this Vagrantfile to work even if these are unset
    aws_ami = ENV['AWS_AMI'] ? ENV['AWS_AMI'] : "invalid"
    aws_keypair_name = ENV['AWS_KEYPAIR_NAME'] ? ENV['AWS_KEYPAIR_NAME'] : "invalid"
    aws_region = ENV['AWS_DEFAULT_REGION'] ? ENV['AWS_DEFAULT_REGION'] : "us-east-1"
    ssh_private_key_path = ENV['SSH_PRIVATE_KEY_PATH'] ? ENV['SSH_PRIVATE_KEY_PATH'] : dummy_keypair_path

    box.vm.box = "dummy"
    box.vm.hostname = "puppet.local"
    box.vm.provider :aws do |aws, override|
      aws.ami = aws_ami
      aws.keypair_name = aws_keypair_name
      aws.region = aws_region
      aws.tags = { 'Name' => 'puppetmaster-bionic-aws' }
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = ssh_private_key_path
    end
    # Copy files required by installer tests
    if ENV['RUN_INSTALLER']
      abort "ERROR: environment variable ANSWER_FILE must be set! Point it to the basename of the answer file on the Vagrant host." unless ENV['ANSWER_FILE']
      abort "ERROR: environment variable SCENARIO must be set! It must be a valid scenario name." unless ENV['SCENARIO']

      installer_dir="/usr/share/puppetmaster-installer"
      scenarios_dir="#{installer_dir}/config/installer-scenarios.d"

      box.vm.provision "file", source: File.join(File.dirname(__FILE__), "vagrant/test/#{ENV['ANSWER_FILE']}"), destination: "/tmp/#{ENV['ANSWER_FILE']}"
      box.vm.provision "shell", inline: "rm -f #{scenarios_dir}/last_scenario.yaml"
      box.vm.provision "shell", inline: "cp /tmp/#{ENV['ANSWER_FILE']} #{scenarios_dir}/#{ENV['SCENARIO']}-answers.yaml"
      box.vm.provision "shell", inline: "ln -s #{scenarios_dir}/#{ENV['SCENARIO']}.yaml #{scenarios_dir}/last_scenario.yaml"

      # Copy r10k key over for setups that need it
      if ENV['R10K_KEY']
        box.vm.provision "file", source: ENV['R10K_KEY'], destination: "/tmp/r10k_key"
        box.vm.provision "shell", inline: "mv /tmp/r10k_key #{installer_dir}/"
      end

      # We need to wait until systemd apt timers have ran or running the installer will fail mysteriously
      #
      # <https://unix.stackexchange.com/questions/315502/how-to-disable-apt-daily-service-on-ubuntu-cloud-vm-image>
      # <https://github.com/Puppet-Finland/scripts/blob/master/bootstrap/linux/install-puppet.sh>
      #
      box.vm.provision "shell", path: File.join(File.dirname(__FILE__), "vagrant/wait_for_apt.sh")
      box.vm.provision "shell", inline: "/bin/systemctl stop puppet"
      box.vm.provision "shell", inline: "#{installer_dir}/bin/puppetmaster-installer --scenario #{ENV['SCENARIO']} --dont-save-answers "
      box.vm.provision "shell", inline: "/opt/puppetlabs/puppet/bin/r10k deploy environment production -vp" if ENV['RUN_R10K'] == 'true'
      box.vm.provision "shell", inline: "/opt/puppetlabs/bin/puppet agent -t"
    end
  end
end
