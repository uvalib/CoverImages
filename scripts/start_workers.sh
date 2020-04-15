#!/usr/bin/env bash
#
# Start the worker pool
#

# source the helper...
#DIR=$(dirname $0)
#. $DIR/common.sh

bundle exec sidekiq -C config/sidekiq.yml -e production

# never get here...
exit 0

#
# end of file
#
