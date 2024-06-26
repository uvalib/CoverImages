#
#
#

FROM public.ecr.aws/docker/library/ruby:2.7.8-slim-bullseye

RUN apt-get update -qq && apt-get install -y build-essential graphicsmagick-libmagick-dev-compat mariadb-client libmariadb-dev git imagemagick yarn python2 nodejs

# Create the run user and group
RUN groupadd --gid 18570 sse && useradd --uid 1984 -g sse docker

# set the timezone appropriatly
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set the locale correctly
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Add necessary gems
RUN gem install bundler -v 2.4.22

# create the work directory
ENV APP_HOME /cover_images
WORKDIR $APP_HOME

# Copy the Gemfile and Gemfile.lock into the image.
ADD Gemfile Gemfile.lock ./
RUN bundle install --jobs=4 --without=["development" "test"] --no-cache

# copy the application
ADD . $APP_HOME

# add the correct configuration files
COPY config/database.docker.yml config/database.yml

# precompile the assets
RUN RAILS_ENV=production SECRET_KEY_BASE=x rake assets:precompile

# Update permissions
RUN mkdir /home/docker && chown -R docker $APP_HOME /home/docker && chgrp -R sse $APP_HOME /home/docker

# Define port and startup script
EXPOSE 8080
CMD scripts/entry.sh

# Move in other assets
COPY package/data/container_bash_profile /home/docker/.profile

# Add the build tag
ARG BUILD_TAG
RUN test -n "$BUILD_TAG" && touch $APP_HOME/buildtag.build-$BUILD_TAG || touch $APP_HOME/buildtag.build-0

# Specify the user
USER docker

#
# end of file
#
