# syntax=docker/dockerfile:1

FROM pandoc/latex:2-ubuntu AS pandoc
FROM contextgarden/context:lmtx

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update \
  && apt-get install -y \
  make \
  liblua5.3-0 \
  lua-lpeg

COPY --from=pandoc /usr/local/bin/pandoc /usr/local/bin/pandoc

RUN mtxrun --generate

COPY actions/entrypoint.sh /entrypoint.sh

WORKDIR /data
ENTRYPOINT [ "make" ]
