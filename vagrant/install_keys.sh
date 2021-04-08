#!/bin/sh
#
# install_keys.sh
#
# Install eyaml keys and r10k deployment key to the Vagrant Puppetmaster,
# if they exist in the synced folder.
#
# This script also ensures that key permissions are correct. This is enforced
# by the Kafo installer, but in case of automated installs this scripts runs
# afterwards and the key permissions may get messed up.

SOURCE_DIR="/usr/share/puppetmaster-installer/keys"
EYAML_DIR="/etc/puppetlabs/puppet/eyaml/keys"
R10K_DIR="/etc/puppetlabs/r10k/ssh"

# Ensure that the target directories exist, even if the installer has not run yet
mkdir -p $EYAML_DIR $R10K_DIR
chown -R root:root $EYAML_DIR $R10K_DIR
chmod 700 $EYAML_DIR $R10K_DIR

# Copy eyaml keys if they exist
for EYAML_KEY in public_key.pkcs7.pem private_key.pkcs7.pem; do
    if [ -r "${SOURCE_DIR}/${EYAML_KEY}" ]; then
        cp -v "${SOURCE_DIR}/${EYAML_KEY}" $EYAML_DIR
        chmod 600 "${EYAML_DIR}/${EYAML_KEY}"
    else
        echo "NOTICE: Eyaml key ${EYAML_KEY} not found from keys directory, not installing it."
    fi
done

# Copy r10k deployment key if it exists
if [ -r "${SOURCE_DIR}/r10k_key" ]; then
    cp -v "${SOURCE_DIR}/r10k_key" $R10K_DIR
    chmod 600 "${R10K_DIR}/r10k_key"
else
    echo "NOTICE: Deployment key r10k_key not found from keys directory, not installing it."
fi
