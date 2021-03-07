require 'spec_helper_acceptance'

describe 'puppetserver - default settings', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  let(:pp) do
    <<-MANIFEST
      include ::puppetmaster::puppetserver
    MANIFEST
  end

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  #describe file("/etc/feature.conf") do
  #  it { is_expected.to be_file }
  #  its(:content) { is_expected.to match %r{key = default value} }
  #end

  describe port(8140) do
    it { is_expected.to be_listening }
  end
end
