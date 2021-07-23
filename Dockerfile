FROM amazonlinux:2 AS build

# https://gist.github.com/techgaun/335ef6f6abb5a254c66d73ac6b390262
RUN yum -y groupinstall "Development Tools" && \
    yum -y install openssl-devel ncurses-devel

# Install Erlang
ARG OTP_VERSION
WORKDIR /tmp
RUN mkdir -p otp && \
    curl -LS "http://erlang.org/download/otp_src_24.0.tar.gz" --output otp.tar.gz && \
    tar xfz otp.tar.gz -C otp --strip-components=1
WORKDIR otp/
RUN ./configure && make && make install

# Install Elixir
ARG ELIXIR_VERSION
ENV LC_ALL en_US.UTF-8
WORKDIR /tmp
RUN mkdir -p elixir && \
    curl -LS "https://github.com/elixir-lang/elixir/archive/v1.12.2.tar.gz" --output elixir.tar.gz && \
    tar xfz elixir.tar.gz -C elixir --strip-components=1
WORKDIR elixir/
RUN make install -e PATH="${PATH}:/usr/local/bin"

# Install node
RUN curl -sL https://rpm.nodesource.com/setup_14.x | bash - && \
    yum install nodejs -y


# Compile app
RUN mkdir /app
WORKDIR /app

# Install Elixir Deps
ADD mix.* ./

# install hex + rebar
RUN MIX_ENV=prod mix local.rebar
RUN MIX_ENV=prod mix local.hex --force
RUN MIX_ENV=prod mix deps.get

# Install app
ADD . .

# build assets
COPY assets/package.json assets/package-lock.json assets/
RUN MIX_ENV=prod mix deps.get
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error
RUN MIX_ENV=prod mix phoenix.digest
RUN MIX_ENV=prod mix compile

# Exposes this port from the docker container to the host machine
EXPOSE 4000

# The command to run when this image starts up
CMD MIX_ENV=prod mix ecto.migrate && \
    MIX_ENV=prod mix phoenix.server