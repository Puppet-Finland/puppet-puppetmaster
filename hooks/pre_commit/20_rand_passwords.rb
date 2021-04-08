require 'securerandom'

# Dynamically set (PuppetDB) password in the matching scenario if it
# has not already been set
def randomize_parameter(mod, param)
  return unless param(mod, param).value.nil?
  pass = SecureRandom.random_number(36**16).to_s(36).rjust(16, '0')
  param(mod, param).value = pass
  puts "NOTICE: #{param} was set to a random string"
end

# Iterate over all scenarios/modules where PuppetDB password may be missing
['puppetmaster_puppetdb', 'puppetmaster_puppetboard'].each do |mod|
  begin
    randomize_parameter mod, 'puppetdb_database_password' if module_enabled? mod
  rescue NoMethodError
    # We get here every time this hook gets called, because only one of the
    # modules/scenarios will be active at a time.
    nil
  end
end

# Randomize Puppetboard password if it is not explicitly set. We do this even
# when puppetboard_require_auth is disabled, because otherwise we would have to
# define an empty string as the default parameter value.
begin
  randomize_parameter 'puppetmaster_puppetboard', 'puppetboard_password' if module_enabled? 'puppetmaster_puppetboard'
rescue NoMethodError
  nil
end
