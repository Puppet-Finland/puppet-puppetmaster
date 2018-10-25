# Puppet status codes say 0 for unchanged, 2 for changed succesfully
if [0, 2].include? @kafo.exit_code
  say "\n" + "<%= color('Puppetserver is now listening for agent connections on TCP port 8140', :good) %>"
  begin
    if module_enabled? 'puppetmaster_puppetboard'
      say "<%= color('Puppetboard can be reached from https://<instance-ip>/puppetboard', :good) %>"
      if param('puppetmaster_puppetboard', 'puppetboard_require_auth').value == true
        say "<%= color('Puppetboard username: #{param('puppetmaster_puppetboard', 'puppetboard_username').value}', :good) %>"
        say "<%= color('Puppetboard password: #{param('puppetmaster_puppetboard', 'puppetboard_password').value}', :good) %>"
      end
    end
  rescue NoMethodError
  end
  say "\n" + 'Please ensure that your firewall is not blocking access to the configured Puppet services'
else
  say "\n" + "<%= color('Something went wrong!', :bad) %> Check the logs in /var/log/kafo for ERROR-level output"
end
