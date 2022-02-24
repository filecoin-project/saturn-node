#!/bin/bash

# Start the first process
node index.js &

# Start the second process
nginx -g "daemon off;" &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
