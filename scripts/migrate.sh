#!/usr/bin/env bash
#
# run any necessary migrations
#

# run the migrations
bundle exec rake db:migrate

# return the status
exit $?

#
# end of file
#
