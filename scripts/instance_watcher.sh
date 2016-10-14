#!/bin/bash

# This script observes the state of a commandline specified instance and starts it. It can be run in a loop or one off, and will only exit 0 if the specified instance was in the string matched state "ACTIVE".

# Openstack ENV variables must be sourced outside of the scope of this script

# requires system packaged nova / openstack client tools

USAGE="RTFM"

while [ "$1" != "" ]; do
    case $1 in
        -l | --loop )           LOOP=true
                                ;;
        -i | --instance )       INSTANCE=$2
                                ;;
        -m | --mail )           MAIL=$2
    esac
    shift
done

if [ -z "$INSTANCE" ]; then
    echo "--instance is required"
    exit 1
fi

# TODO need bash run fucntion wrapper for date + logging
DATE=$(date +%s)

echo "$DATE: starting instance state check for $INSTANCE"

function check_instance_state () {
    instance=$1
    STATE=$(nova show --minimal $instance \
    | grep status | awk '{print$(NF-1)}')
    echo $STATE
}

function validate_instance_state () {
    instance=$1
    instance_state=$2
    DATE=$(date +%s)
    INSTANCE_STATE=$(check_instance_state $INSTANCE)
    echo "$DATE: $INSTANCE instance stace is $INSTANCE_STATE"

    if [ "$INSTANCE_STATE" != "ACTIVE" ]; then
        DATE=$(date +%s)
        echo "$DATE: $INSTANCE_STATE"
        echo "$DATE: $INSTANCE was found in a not ACTIVE state, rechecking"
        sleep 2

# TODO the number of rechecks and sleeps should be configured by args

        INSTANCE_STATE_2=$(check_instance_state $INSTANCE)
        if [ "$INSTANCE_STATE_2" != "ACTIVE" ]; then
            DATE=$(date +%s)
            echo "$DATE: instance found in a non ACTIVE \
                state for a second time"
            echo "$DATE: issuing start command on $INSTANCE"
            instance_start $INSTANCE 
        fi
    fi
}

INSTANCE_STATE=$(check_instance_state $INSTANCE)
function instance_start () {
    DATE=$(date +%s)
    instance=$1
    echo "$DATE: starting instance $instance"
    nova start $instance
    if [ $? != 0 ]; then
        echo "$DATE: error starting instance"
    fi
}

INSTANCE_STATE=$(check_instance_state $INSTANCE)

echo "$DATE: $INSTANCE instance stace is $INSTANCE_STATE"

# TODO the number of rechecks and sleeps should be configured by args

if [ "$INSTANCE_STATE" != "ACTIVE" ]; then
    DATE=$(date +%s)
    echo "$DATE: $INSTANCE_STATE"
    echo "$DATE: $INSTANCE was found in a not ACTIVE state, rechecking"
    sleep 2
    INSTANCE_STATE_2=$(check_instance_state $INSTANCE)
    if [ "$INSTANCE_STATE_2" != "ACTIVE" ]; then
        DATE=$(date +%s)
        echo "$DATE: instance found in a non ACTIVE state for a second time"
        echo "$DATE: issuing start command on $INSTANCE"
        instance_start $INSTANCE 
    fi
fi


DATE=$(date +%s)
echo "$DATE: work done, exiting 0"
exit 0
