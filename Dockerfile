FROM ruby:3.0.1

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app
ADD Gemfile.lock /app

RUN gem install bundler && bundle install

ADD . /app/

ENTRYPOINT ["./scripts/start_zendesk_search.rb"]