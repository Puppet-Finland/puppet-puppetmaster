require 'spec_helper'

describe 'puppetmaster::puppetserver' do
  it { is_expected.to contain_class('puppetmaster::common') }
end
