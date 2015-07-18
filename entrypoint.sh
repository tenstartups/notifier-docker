#!/bin/bash

case "$1" in
  /usr/local/bin/notify | notify | info | warn | error | success ) "$@" ;;
  *                                                              ) notify "$@" ;;
esac
