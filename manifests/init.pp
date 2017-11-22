#
# == Class: puppetmaster
#
# A simple wrapper class for setting up puppetmasters. Primarily aimed for use
# in Kafo installers.
#
# == Parameters
#
# $puppetserver::	Setup puppetserver
#
class puppetmaster
(
    Boolean $puppetserver = true
)
{
    if $puppetserver {
        class { 'puppetserver::repository': }
        class { 'puppetserver': }
    }
}
