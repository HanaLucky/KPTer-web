FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev graphviz
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install
