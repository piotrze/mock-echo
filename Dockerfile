FROM ruby:3.3-alpine

RUN apk add bash build-base

ADD . /app
WORKDIR /app
RUN bundle install

EXPOSE 3000

# CMD ["bundle", "exec", "rerun", "--", "rackup", "--host", "0.0.0.0", "-p", "3000"]
