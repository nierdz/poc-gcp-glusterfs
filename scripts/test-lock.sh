#!/usr/bin/env bash

LOCK=/mnt/test.lock

trap 'rm -f $LOCK' INT QUIT TERM EXIT

exec 666>"$LOCK"
flock --timeout 300 666
echo "I have $LOCK"

sleep 20
echo "Lock released, exited"
