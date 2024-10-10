FROM alpine:latest

RUN apk update \
    && apk add curl

WORKDIR /tmp

RUN install -Dd fonts \
    && curl -fsSL https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20230610.tar.gz | tar xz -C fonts

FROM pandoc/extra:edge-ubuntu

COPY --from=0 /tmp/fonts/ /usr/local/share/fonts

RUN fc-cache -f

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y fonts-takao fonts-ipafont \
    && rm -rf /var/lib/apt/lists/*

RUN tlmgr update --self --all \
    && tlmgr install collection-langjapanese tocloft
