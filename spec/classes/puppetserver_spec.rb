require 'spec_helper'

describe 'puppetmaster::puppetserver' do
  extra_facts = { :fqdn           => 'puppet.example.org',
                  :hostname       => 'puppet',
                  :ipv4_lo_addrs  => '127.0.0.1',
                  :ipv6_lo_addrs  => '::1',
                  :ipv4_pri_addrs => '10.50.0.1',
                  :ipv6_pri_addrs => '::1' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) do
        {
          'timezone'     => 'UTC',
          'control_repo' => true
        }
      end

      let(:facts) { os_facts.merge(extra_facts) }
      it { is_expected.to compile }
    end
  end
end
