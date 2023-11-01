# syntax=docker/dockerfile:1

FROM contextgarden/context:current

RUN --mount=type=cache,target=/var/cache/apt \
    apt update \
    && apt install -y \
      make \
      pandoc

RUN mtxrun --generate

COPY actions/entrypoint.sh /entrypoint.sh

WORKDIR /data
ENTRYPOINT [ "make" ]
