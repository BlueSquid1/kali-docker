#!/bin/bash
set -e

pushd .
# start nessus and all it's services
supervisord &
SUPERVISORD_PID=$!
# bit hacky need to wait until configure_scanner has started
sleep 5s
supervisorctl stop configure_scanner

echo "running config script"
python3 /opt/scripts/configure_scanner.py

/opt/nessus/sbin/nessusd -R

supervisorctl stop nessusd

#shutdown all supervisor services
kill $SUPERVISORD_PID
popd