# Puppet status codes say 0 for unchanged, 2 for changed succesfully
if [0, 2].include? @kafo.exit_code
  say "\n" + "<%= color('Puppetserver is now listening for agent connections on TCP port 8140', :good) %>"
  begin
    say "<%= color('Puppetboard can be reached from https://<instance-ip>/puppetboard', :good) %>" if module_enabled? 'puppetmaster_puppetboard'
  rescue NoMethodError
  end
  say "\n" + 'Please ensure that your firewall is not blocking access to the configured Puppet services'
else
  say "\n" + "<%= color('Something went wrong!', :bad) %> Check the logs in /var/log/kafo for ERROR-level output"
end
