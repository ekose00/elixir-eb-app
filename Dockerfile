FROM elixir:1.9.0-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git python

ENV WORKDIR /app
RUN mkdir $WORKDIR

COPY  . $WORKDIR

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force
    
# install mix dependencies
RUN mix deps.get

# build assets
RUN cd assets && npm install && node node_modules/webpack/bin/webpack.js --mode development

RUN mix deps.compile

# Exposes this port from the docker container to the host machine
EXPOSE 4000

# The command to run when this image starts up
CMD mix ecto.create && mix phx.server