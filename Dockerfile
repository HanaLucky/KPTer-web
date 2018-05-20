FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
ENV APP_ROOT /KPTer-web
WORKDIR $APP_ROOT
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install
ADD . $APP_ROOT

