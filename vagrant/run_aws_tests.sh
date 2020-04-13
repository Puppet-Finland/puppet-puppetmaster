#!/bin/sh
#
# run_aws_tests.sh
#
# Run a battery of tests against an AWS instance that has puppetmaster-installer
# installed from a package

# Ensure that working directory is correct
if ! [ -r "./run_aws_tests.sh" ]; then
    echo "ERROR: this script must be run from <installer-basedir>/vagrant"
    exit 1
fi

# Ensure that we have an AWS_AMI. Otherwise we can't continue.
if [ "$AWS_AMI" = "" ]; then
    echo "ERROR: AWS_AMI environment parameter is missing, can't continue!"
    exit 1
fi

run_test() {
    VM=$1
    SCENARIO=$2
    ANSWER_FILE=$3
    if [ "$4" = "true" ]; then
      RUN_R10K=true
    else
      RUN_R10K=false
    fi

    LOGFILE="test/logs/${VM}-${AWS_AMI}-${SCENARIO}-${ANSWER_FILE}-${TIMESTAMP}.log"

    echo >> $LOGFILE 2>&1
    echo "TEST CASE: VM=$VM AWS_AMI=$AWS_AMI SCENARIO=$SCENARIO ANSWER_FILE=$ANSWER_FILE" >> $LOGFILE 2>&1
    echo >> $LOGFILE 2>&1

    AWS_AMI=$AWS_AMI vagrant up $VM >> $LOGFILE 2>&1
    RUN_R10K=$RUN_R10K RUN_INSTALLER=true SCENARIO=$SCENARIO ANSWER_FILE=$ANSWER_FILE vagrant provision $VM >> $LOGFILE 2>&1
    vagrant destroy -f $VM >> $LOGFILE 2>&1
}

# Main program
mkdir -p test/logs

TIMESTAMP=$(date +'%s')
COMMIT=$(git rev-parse --short HEAD)

run_test puppetserver-bionic-aws puppetserver-with-puppetboard puppetserver-with-puppetboard-answers.yaml_default false
run_test puppetserver-bionic-aws puppetserver-with-puppetdb puppetserver-with-puppetdb-answers.yaml_default false
run_test puppetserver-bionic-aws puppetserver puppetserver-answers.yaml_gitlab true
