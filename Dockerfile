FROM ruby:2.4

RUN apt-get update -qq && apt-get install -y build-essential ImageMagick graphicsmagick-libmagick-dev-compat mysql-client

# Create the run user and group
RUN groupadd -r webservice && useradd -r -g webservice webservice && mkdir /home/webservice

# set the timezone appropriatly
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set the locale correctly
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN chmod 777 -R /tmp && chmod o+t -R /tmp
ENV APP_HOME /cover_images
ENV RAILS_ENV production
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install

ADD . $APP_HOME

RUN RAILS_ENV=production SECRET_KEY_BASE=x rake assets:precompile

# Update permissions
RUN chown -R webservice $APP_HOME /home/webservice && chgrp -R webservice $APP_HOME /home/webservice

