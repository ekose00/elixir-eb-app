FROM elixir:1.11.4-alpine

# install build dependencies
RUN apk add --no-cache build-base npm git python3 inotify-tools

ENV WORKDIR /app

RUN mkdir $WORKDIR

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config config

# prepare build dir

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force
    
# set build ENV
ENV MIX_ENV=dev
ENV DATABASE_URL=ecto://postgres:postgres@database-1.cfuckujyf4qj.us-east-1.rds.amazonaws.com/postgres
ENV SECRET_KEY_BASE=teste
ENV PORT=4000
    
# install mix dependencies
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release

ENV HOME=/app

# Exposes this port from the docker container to the host machine
EXPOSE 4000

# The command to run when this image starts up
CMD ["_build/dev/rel/hello/bin/hello", "start"]