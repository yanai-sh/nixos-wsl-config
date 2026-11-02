#!/bin/sh
if [ -z "${__NIXOS_SET_ENVIRONMENT_DONE:-}" ]; then
  # shellcheck source=/dev/null
  . /etc/set-environment
fi
exec /run/current-system/sw/bin/bash "$@"
