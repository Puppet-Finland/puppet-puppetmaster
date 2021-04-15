# puppet-puppetmaster

This is a Puppet module and [Kafo](https://github.com/theforeman/kafo) installer for setting up:

* Puppetserver
* Puppetserver with PuppetDB
* Puppetserver with PuppetDB and [Puppetboard](https://github.com/voxpupuli/puppetboard)

Each of the above is a separate Kafo installer scenario. This installer should
work on CentOS 7, Debian 9, Ubuntu 18.04 and Ubuntu 20.04.

Note that files related to Kafo installer and Vagrant are only available in the
[GitHub project](https://github.com/Puppet-Finland/puppet-puppetmaster), not in
the version published on Puppet Forge.

# Setup outside of Vagrant

You can run the installer outside of Vagrant quite easily.  First remove any
old Puppet packages you might have installed. For example:

    $ apt-get remove puppet-agent puppet5-release

Then do what Vagrant does to prepare the installer:

    $ apt-get update && apt-get install git
    $ cd /usr/share
    $ git clone https://github.com/Puppet-Finland/puppet-puppetmaster puppetmaster-installer
    $ cd puppetmaster-installer
    $ vagrant/prepare.sh -b /usr/share/puppetmaster-installer -m

If you are going to use r10k and/or eyaml create a directory for their keys:

    $ mkdir /usr/share/puppetmaster-installer/keys

Then copy your eyaml keys and your r10k private key there, naming them
*private_key.pkcs7.pem*, *public_key.pkcs7.pem* and *r10k_key*. You need to
configure control repo settings within the installer as well.

As the final preparatory step set the hostname, e.g.

    $ hostnamectl set-hostname puppet.example.org

Now restart your shell session to refresh your PATH and Ruby environment. After
this you can run the installer.

# Interactive usage

To run the installer just

    $ sudo -i
    $ puppetmaster-installer -i

The "-i" switch to sudo ensures that the environment is root's environment,
which is particularly important on Ubuntu and Debian. The -i switch to the
installer makes it run in interactive mode, which is probably what you want to
do.

# Automatic installs

You can run the installer automatically like this:

    $ sudo -i
    $ /usr/share/puppetmaster-installer/bin/puppetmaster-installer\
     --scenario puppetserver-with-puppetboard\
     --puppetmaster-puppetboard-puppetdb-database-password='pass'\
     --puppetmaster-puppetboard-timezone='Europe/Helsinki'

When using Vagrant you can automate puppetserver setup during provisioning as
well. To do this you need to modify two config files:

* config/automated_install.conf (basic settings)
* config/installer-scenarios.d/automated_install_answers.yaml (installer settings)

Make sure that you change the default passwords in the answer file.

If you change the scenario from the default (puppetserver-with-puppetboard) make
sure that your answer file matches the scenario. You can create a matching
answer file by removing config/installer-scenarios.d/last_scenario.yaml (if
present), launching the installer interactively in a Vagrant VM, selecting the
desired scenario, setting the parameters and launching the installer. Once the
installer is running, the contents of that scenario's answer file will match
what you selected. You can then copy that answer file to
automated_install_answers.yaml. Alternatively you can use "Display current
config" output as the content of the answer file. However, you then need to
replace the first underscore ("\_") with "::" because the kafo installer does
module mapping. In either case make sure you have defined the passwords in the
answer file or installation will fail immediately.

Then, in the root of the repository, run

    $ sudo -i
    $ bin/puppetmaster-install.sh

Vagrant will automatically copy your r10k deployment key and eyaml keys to
correct locations if they are placed under keys directory in the repository
root:

 * keys/private_key.pkcs7.pem (eyaml private key)
 * keys/public_key.pkcs7.pem (eyaml public key)
 * keys/r10k_key (r10k deployment key)

# Development

## Testing with PDK

This module has basic rspec tests that help ensure that catalog compilation
works across all supported platforms. To run the unit tests do

```
$ pdk test unit
```

To validate code run

```
$ ./pdk-validate.sh
```

You cannot run "pdk validate" directly as it would scan through all the
dependency modules multiple times (r10k modules, fixtures, build directories)
and give tons of false positives and be really slow in general. If you
interrupt that script you can just run it again to restore the offending
directories to their original places.

## Testing with Vagrant

This repository makes heavy use of Vagrant and Virtualbox for testing. You will
need to use a fairly up-to-date Vagrant or you will run into networking issue
with the Ubuntu boxes. We recommend using Vagrant 2.1.5 or later.

It is possible to run installer at the end of provisioning. This feature is
primarily designed for Vagrant-based testing. To automatically setup a
puppetserver with your desired answers first copy your answer file to
config/installer-scenarios.d and run the installer like this:

    RUN_INSTALLER=true SCENARIO=puppetserver vagrant up puppetserver-bionic

The answer file needs to match the scenario you chose. See [vagrant/run_vagrant_tests.sh](vagrant/run_vagrant_tests.sh)
to see how this feature is utilized to automate regression testing.

Alternatively you can use installer's command-line parameters to define your
answers.

## Testing AWS AMI images created with packer

We use [vagrant-aws](https://github.com/mitchellh/vagrant-aws) Vagrant plugin
to ease testing of packer-generated puppetmaster AMI images. First you need to
setup vagrant-aws as per documentation:

    $ vagrant plugin install vagrant-aws
    $ vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

Then make sure that the following standard AWS environment variables are set:

* AWS_SECRET_ACCESS_KEY
* AWS_ACCESS_KEY_ID

Optionally you can also set

* AWS_DEFAULT_REGION: define which region Vagrant creates the instance to

There are a few non-standard environment variables you need to set as well:

* AWS_AMI: the AMI ID that has puppetmaster-installer preconfigured
* AWS_KEY_PAIR_NAME: the name of the SSH keypair at the AWS end
* SSH_PRIVATE_KEY_PATH: path to the SSH private key matching the SSH keypair name, above

Once all these are set, you can use create, connect to and destroy the AWS instances as needed:

    $ vagrant up puppetserver-bionic-aws
    $ vagrant ssh puppetserver-bionic-aws
    $ vagrant destroy puppetserver-bionic-aws

To run automated tests against an AWS instance use:

    $ cd vagrant
    $ AWS_AMI=<ami-id> ./run_aws_tests.sh

The log files are written to vagrant/test/logs.

## Creating deb/rpm packages

Creating Debian and RPM packages is straightforward with the Debian 9 -based packager VM:

    $ vagrant up packager
    $ vagrant ssh packager
    $ cd /home/ubuntu/puppetmaster-installer/packaging
    $ ./package.sh

When upgrading package to new version the following Git spell will show which
files have been added, modified or deleted since the last release:

    $ git show --pretty="" --name-status <start-commit>...HEAD|sort|uniq

This helps avoid leaving critical files out of the packages.

## Living with changes Kafo makes to versioned answer files

Kafo installers have a nasty habit of modifying answer files which are versioned 
by Git. To prevent these local answer file modifications from getting committed 
by accident you can use a command like this:

    $ find config -name "*-answers.yaml"|xargs git update-index --assume-unchanged

# Known issues

* The installer will fail miserably if something else is locking dpkg/apt. This happens easily with Ubuntu Cloud images as they are configured (with systemd timers) to upgrade system packages on every boot. You should let the package upgrade process finish before trying to run the installer.

# LICENSE

This project uses the two-clause BSD license. See [LICENSE](LICENSE) for details.
