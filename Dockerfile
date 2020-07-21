FROM elixir:1.10.3-alpine AS build

ENV MIX_ENV=prod
WORKDIR /app
RUN apk add --no-cache build-base make
RUN mix local.hex --force && \
    mix local.rebar --force
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile
COPY lib lib
RUN mix do compile, release

FROM alpine:3.9 AS app

WORKDIR /app
ENV HOME=/app
ENV MIX_ENV=prod
RUN apk add --no-cache openssl ncurses-libs
RUN chown nobody:nobody /app
USER nobody:nobody
COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/chismoso ./
CMD ["bin/chismoso", "start"]
