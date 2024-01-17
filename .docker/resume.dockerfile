# syntax=docker/dockerfile:1

FROM contextgarden/context:current

RUN --mount=type=cache,target=/var/cache/apt \
    apt update \
    && apt install -y \
      make \
      liblua5.3-0 \
      lua-lpeg

COPY --from=pandoc/latex:2.18-ubuntu /usr/local/bin/pandoc /usr/local/bin/pandoc

RUN mtxrun --generate

COPY actions/entrypoint.sh /entrypoint.sh

WORKDIR /data
ENTRYPOINT [ "make" ]
