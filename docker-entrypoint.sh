#!/usr/bin/env sh
set -ex

# Graceful shutdown
# trap 'pkill -TERM -P1; electron-cash daemon stop; exit 0' SIGTERM

# Set config
electron-cash setconfig rpcuser ${ELECTRUM_USER} ${OPTIONS}
electron-cash setconfig rpcpassword ${ELECTRUM_PASSWORD} ${OPTIONS}
electron-cash setconfig rpchost 0.0.0.0 ${OPTIONS}
electron-cash setconfig rpcport 7000 ${OPTIONS}

# XXX: Check load wallet or create

# Run application
electron-cash daemon ${OPTIONS} start

# Wait forever
while true; do
  tail -f /dev/null & wait ${!}
done
