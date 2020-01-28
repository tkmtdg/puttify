#!/bin/bash
LEN=$1
CNT=$2

if [ -z ${LEN} ] ; then LEN=12 ; fi
if [ -z ${CNT} ] ; then CNT=16 ; fi

cat /dev/urandom | \
LC_CTYPE=C tr -dc '12345678abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ,.+!\-' | \
fold -w ${LEN} | grep -E '[12345678]' | grep -E '[,\.+\-\!]' | \
grep -E '^[12345678abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ]' | \
head -n ${CNT}
