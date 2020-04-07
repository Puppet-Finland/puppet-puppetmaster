fqdn = `/opt/puppetlabs/bin/facter fqdn`.chomp

if fqdn =~ %r{ip-\d{1,3}.*/}
  say "<%= color('Suggestion: change the hostname from \"#{fqdn}\" to \"puppet.mydomain.com\" or similar before running this installer. You can use \"hostnamectl set-hostname <hostname>\" to do that.\n', :bad) %>" # rubocop:disable Metrics/LineLength
end
