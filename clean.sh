#!/bin/bash
set -eu

function confirm {
  message=$1
  while :
  do
    echo -n "${message} [y/N]: "
    read answer
    case ${answer} in
    "Y" | "y" | "yes" | "Yes" | "YES" ) return 0 ;;
    * ) return 1 ;;
    esac
  done
}

confirm 'sure?'

rm -rf ./data/*
