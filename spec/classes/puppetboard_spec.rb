require 'spec_helper'

describe 'puppetmaster::puppetboard' do
  extra_facts = { ipv4_lo_addrs:  '127.0.0.1',
                  ipv6_lo_addrs:   '::1',
                  ipv4_pri_addrs: '10.50.0.1',
                  ipv6_pri_addrs: '::1' }

  let(:node) { 'puppet.example.org' }
  let(:params) do
    {
      timezone:                   'Etc/UTC',
      control_repo:               true,
      puppetboard_password:       'foobar',
      puppetdb_database_password: 'foobar',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "minimal settings on #{os}" do
      let(:params) do
        super()
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to compile }
    end
  end

  # Run the following tests on only one platform. Details of the syntax are here:
  #
  # <https://github.com/mcanevet/rspec-puppet-facts>
  #
  bionic = { supported_os: [{ 'operatingsystem' => 'Ubuntu', 'operatingsystemrelease' => ['18.04'] }] }

  on_supported_os(bionic).each do |_os, os_facts|
    context 'with bitbucket provider' do
      let(:params) do
        super().merge(provider: 'bitbucket', repo_url: 'git@bitbucket.org:myorg/control-repo.git')
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to contain_sshkey('bitbucket.org') }
    end

    context 'with gitlab provider' do
      let(:params) do
        super().merge(provider: 'gitlab', repo_url: 'git@gitlab.com:myorg/control-repo.git')
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to contain_sshkey('gitlab.com') }
    end

    context 'with custom provider without repo_host' do
      let(:params) do
        super().merge(provider: 'myorg', repo_url: 'git@gitlab.example.org:myorg/control-repo.git')
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to compile.and_raise_error(%r{ERROR}) }
    end

    context 'with puppetboard auth' do
      let(:params) do
        super().merge(puppetboard_require_auth: true)
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to contain_file('/etc/apache2/conf-enabled/puppetboard-basic-auth.conf').with_ensure('present') }
    end

    context 'without puppetboard auth' do
      let(:params) do
        super().merge(puppetboard_require_auth: false)
      end

      let(:facts) { os_facts.merge(extra_facts) }

      it { is_expected.to contain_file('/etc/apache2/conf-enabled/puppetboard-basic-auth.conf').with_ensure('absent') }
    end
  end
end
