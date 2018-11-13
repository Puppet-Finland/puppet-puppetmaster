#!/bin/sh
#
# run_vagrant_tests.sh
#
# Run all installer scenario variants to detect regressions early
#

usage() {
  echo "Usage: run_vagrant_tests.sh"
}

if ! [ -r "./run_vagrant_tests.sh" ]; then
    echo "ERROR: this script must be run from <installer-basedir>/vagrant"
    exit 1
fi

# Run an individual Vagrant test
run_test() {

    VM=$1
    SCENARIO=$2
    ANSWER_FILE_NAME="$3"
    TARGET_ANSWER_FILE_NAME="$(echo $ANSWER_FILE_NAME|cut -d "_" -f 1)"
    TARGET_ANSWER_FILE_PATH="../config/installer-scenarios.d/${TARGET_ANSWER_FILE_NAME}"
    LOGFILE="test/logs/${VM}-${SCENARIO}-${ANSWER_FILE_NAME}-${TIMESTAMP}-${COMMIT}.log"

    echo >> $LOGFILE 2>&1
    echo "TEST CASE: VM=$VM SCENARIO=$SCENARIO ANSWER_FILE_NAME=$ANSWER_FILE_NAME" >> $LOGFILE 2>&1
    echo >> $LOGFILE 2>&1

    cp "test/$ANSWER_FILE_NAME" $TARGET_ANSWER_FILE_PATH

    RUN_INSTALLER=true SCENARIO=$SCENARIO vagrant up $VM >> $LOGFILE 2>&1


    vagrant destroy -f $VM >> $LOGFILE 2>&1

    git checkout -- $TARGET_ANSWER_FILE_PATH
}


# Prepare for the tests
mkdir -p test/logs

TIMESTAMP=$(date +'%s')
COMMIT=$(git rev-parse --short HEAD)

# Puppetserver with default settings
run_test puppetserver-bionic puppetserver puppetserver-answers.yaml_default
run_test puppetserver-stretch puppetserver puppetserver-answers.yaml_default
run_test puppetserver-centos7 puppetserver puppetserver-answers.yaml_default

# Puppetserver + PuppetDB with default settings
run_test puppetserver-bionic puppetserver-with-puppetdb puppetserver-with-puppetdb-answers.yaml_default
run_test puppetserver-stretch puppetserver-with-puppetdb puppetserver-with-puppetdb-answers.yaml_default
run_test puppetserver-centos7 puppetserver-with-puppetdb puppetserver-with-puppetdb-answers.yaml_default

# Puppetserver + PuppetDB + Puppetboard with default settings
run_test puppetserver-bionic puppetserver-with-puppetboard puppetserver-with-puppetboard-answers.yaml_default
run_test puppetserver-stretch puppetserver-with-puppetboard puppetserver-with-puppetboard-answers.yaml_default
run_test puppetserver-centos7 puppetserver-with-puppetboard puppetserver-with-puppetboard-answers.yaml_default


