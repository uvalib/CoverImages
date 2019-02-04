FROM ruby:2.4.5

RUN apt-get update -qq && apt-get install -y build-essential graphicsmagick-libmagick-dev-compat mysql-client

# Create the run user and group
RUN groupadd --gid 18570 sse && useradd --uid 1984 -g sse docker

# set the timezone appropriatly
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set the locale correctly
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install bundler
RUN gem install bundler

#RUN chmod 777 -R /tmp && chmod o+t -R /tmp

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# create the work directory
ENV APP_HOME /cover_images
WORKDIR $APP_HOME

# copy the application
ADD . $APP_HOME

# add the correct configuration files
COPY config/database.docker.yml config/database.yml

# precompile the assets
RUN RAILS_ENV=production SECRET_KEY_BASE=x rake assets:precompile

# Update permissions
RUN mkdir /home/docker && chown -R docker $APP_HOME /home/docker && chgrp -R sse $APP_HOME /home/docker

# Specify the user
USER docker

# Define port and startup script
EXPOSE 3000
CMD scripts/entry.sh

# Move in other assets
COPY data/container_bash_profile /home/docker/.profile

#
# end of file
#
