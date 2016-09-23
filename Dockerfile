FROM ruby:2.3.1

RUN apt-get update -qq && apt-get install -y build-essential ImageMagick mysql-client


ENV APP_HOME /cover_images
ENV RAILS_ENV production
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install

ADD . $APP_HOME

RUN rake assets:precompile

VOLUME ["$APP_HOME/public"]

