# Do sanity checking on control repo configuration
err = false

['puppetmaster_puppetserver', 'puppetmaster_puppetdb', 'puppetmaster_puppetboard'].each do |module_name|
  if module_enabled? module_name # rubocop:disable Style/Next

    # Check that all required parameters are present
    if param(module_name, 'control_repo').value
      ['provider', 'repo_url', 'key_path'].each do |p|
        unless param(module_name, p).value
          say "<%= color('ERROR: Must set \"#{p}\" when control_repo = true.', :bad) %>"
          err = true
        end
      end

      # Check that repo_host is defined when not using a preconfigured Git provider
      provider = param(module_name, 'provider').value
      unless ['gitlab', 'bitbucket'].include? provider
        unless param(module_name, 'repo_host').value
          say "<%= color('ERROR: Must set \"repo_host\" when control_repo = true and you are not using a preconfigured provider such as \"gitlab\" or \"bitbucket\".', :bad) %>"
          err = true
        end
      end

      # Check that r10k deployment key is actually present
      r10k_key = '/usr/share/puppetmaster-installer/keys/r10k_key'

      unless File.file?(r10k_key)
        say "<%= color('ERROR: #{r10k_key} not found! Please copy your control repo deployment key to that location!', :bad) %>"
        err = true
      end
    end
  end
end

if err
  say "<%= color('\nPlease launch the installer again fix the above errors.', :bad) %>"
  exit(1)
end
