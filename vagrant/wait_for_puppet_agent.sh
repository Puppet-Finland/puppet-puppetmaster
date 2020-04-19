#!/bin/sh
#
# Wait until Puppet Agent run has finished. This resolves some test failures.
# This check is not completely reliable: at the start of a Puppet run there's a
# short period when the lockfile is not yet present.
#
puppet_lockfile="/opt/puppetlabs/puppet/cache/state/agent_catalog_run.lock"
puppet="/opt/puppetlabs/bin/puppet"

lock=1
while [ $lock -eq 1 ]; do
    test -f $puppet_lockfile && sleep 1 || lock=0
    if [ $lock -eq 1 ]; then
        echo "Waiting for Puppet run to finish..."
    fi
done
