require 'spec_helper'

describe 'puppetmaster::puppetdb' do
  extra_facts = { :ipv4_lo_addrs  => '127.0.0.1',
                  :ipv6_lo_addrs  => '::1',
                  :ipv4_pri_addrs => '10.50.0.1',
                  :ipv6_pri_addrs => '::1' }

  let(:node) { 'puppet.example.org' }
  let(:params) do
    {
      'timezone'                   => 'Etc/UTC',
      'control_repo'               => true,
      'puppetdb_database_password' => 'foobar'
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
end
