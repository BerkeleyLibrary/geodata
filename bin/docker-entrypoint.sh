#!/bin/sh


set -e

# Remove a potentially pre-existing server.pid for Rails.
echo 'before server is shutdown !!!'

rm  -f   /opt/app/tmp/pids/server.pid
echo 'what server is shutdown !!!'

unset BUNDLE_PATH
unset BUNDLE_BIN

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
