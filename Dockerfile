FROM elixir:1.11.2

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG MIX_ENV=prod
ARG APP_USER=user

ENV MIX_ENV=${MIX_ENV}
ENV APP_USER=$APP_USER
ENV MIX_HOME=/opt/cache/mix
ENV HEX_HOME=/opt/cache/hex
ENV BUILD_PATH=/opt/cache/_build
ENV REBAR_CACHE_DIR=/opt/cache/rebar

RUN apt-get update && apt-get install -y \
  bash \
  git

RUN mkdir /opt/cache

WORKDIR /opt/app

RUN addgroup --gid $GROUP_ID user
RUN useradd -m --uid $USER_ID --gid $GROUP_ID user

RUN chown -R user /opt/cache
RUN chown -R user /opt/app

USER user

RUN mix local.hex --force --sha512 && \
  mix local.rebar --force --sha512

CMD ["bash"]
