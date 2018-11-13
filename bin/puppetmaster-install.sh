#!/bin/sh
#
# Automatically run the installer with customizable settings. Useful when
# building Vagrant-based development/staging environments for example.

# Ensure this script is run from the correct directory
if ! [ -r "bin/puppetmaster-installer" ]; then
    echo "ERROR: you need to run this script from the root of the repository with bin/puppetmaster-install.sh!"
    exit 1
fi

# Load configuration and fallback to sane defaults if it is missing
CONFIG="config/automated_install.conf"

if [ -r "${CONFIG}" ]; then
    . config/automated_install.conf
fi

VM="${VM:-puppetserver-bionic}"
SCENARIO="${SCENARIO:-puppetserver-with-puppetboard}"
ANSWER_FILE_NAME="${ANSWER_FILE_NAME:-automated_install_answers.yaml}"
ANSWER_FILE_PATH="config/installer-scenarios.d/${ANSWER_FILE_NAME}"
TARGET_ANSWER_FILE_PATH="config/installer-scenarios.d/${SCENARIO}-answers.yaml"

if ! [ -r "${ANSWER_FILE_PATH}" ]; then
    echo "ERROR: answer file ${ANSWER_FILE_PATH} not found!"
    exit 1
fi

if ! [ -r "${TARGET_ANSWER_FILE_PATH}" ]; then
    echo "ERROR: target answer file ${TARGET_ANSWER_FILE_PATH} not found! This probably a typo in scenario name."
    exit 1
fi

# Check for missing passwords. This does not cover the case where answer file
# is the stock one (i.e. it does not contain any answers).
grep -E "_password:[[:space:]]*$" $ANSWER_FILE_PATH > /dev/null
if [ $? -eq 0 ]; then
    echo "ERROR: these passwords are not set in ${ANSWER_FILE_NAME}:"
    echo
    grep -E "_password:[[:space:]]*$" $ANSWER_FILE_PATH
    echo
    echo "You need to define them or installation will fail."
    exit 1
fi

# Ensure that the correct answer file is used
cp $ANSWER_FILE_PATH $TARGET_ANSWER_FILE_PATH

RUN_INSTALLER=true SCENARIO=$SCENARIO vagrant up $VM
