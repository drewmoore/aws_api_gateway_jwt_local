FROM ruby:3.2.1-alpine3.16

RUN apk update
RUN adduser -D docker
# Otherwise error extconf.rb failed
RUN apk add build-base

WORKDIR /home/docker/app

USER docker

COPY --chown=docker:docker Gemfile /home/docker/app/Gemfile
COPY --chown=docker:docker Gemfile.lock /home/docker/app/Gemfile.lock

RUN gem install bundler:2.4.6
# Allow gem groups to be included, production-only by default
ENV BUNDLE_WITH test
RUN bundle install

COPY --chown=docker:docker entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
