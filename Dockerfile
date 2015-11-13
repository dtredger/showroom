# https://hub.docker.com/_/rails/
# FROM rails:onbuild
FROM ruby:2.0.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get install -y libxml2-dev libxslt1-dev
RUN apt-get install -y nodejs
RUN apt-get upgrade -y
ENV APP_HOME /myapp

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
