# syntax=docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# OS Level Dependencies
RUN --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq \
  && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    git \
    libpq-dev \
    postgresql-client \
    libvips \
    curl

ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Sets the path where the app is going to be installed
ENV RAILS_ROOT /var/www/

# Creates the directory and all the parents (if they don't exist)
RUN mkdir -p $RAILS_ROOT

# This is given by the Ruby Image.
# This will be the de-facto directory that 
# all the contents are going to be stored. 
WORKDIR $RAILS_ROOT
  
# We are copying the Gemfile first, so we can install 
# all the dependencies without any issues
# Rails will be installed once you load it from the Gemfile
# This will also ensure that gems are cached and only updated when 
# they change.
COPY Gemfile ./
COPY Gemfile.lock ./

# Installs the Gem File.
RUN bundle install

# We copy all the files from the current directory to our
# /app directory
# Pay close attention to the dot (.)
# The first one will select ALL The files of the current directory, 
# The second dot will copy it to the WORKDIR!
COPY . .

ENTRYPOINT ["./bin/docker-entrypoint-development"]

CMD ["rails", "s", "-p", "4000", "-b", "0.0.0.0"]