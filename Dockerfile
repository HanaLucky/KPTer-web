FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
ENV APP_ROOT /kpter-web
WORKDIR $APP_ROOT
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install
ADD . $APP_ROOT
RUN mkdir -p tmp/sockets

# for nginx
VOLUME /kpter-web/public
VOLUME /kpter-web/tmp
