FROM alpine:latest

RUN apk update \
    && apk add curl

WORKDIR /tmp

RUN install -Dd fonts \
    && curl -fsSL https://github.com/trueroad/HaranoAjiFonts/archive/refs/tags/20230610.tar.gz | tar xz -C fonts

# 3-ubuntu は Pandoc 3.10 へ追従するが、現行 pandoc-crossref (<3.10) と不一致になる。
# EPUB の pandoc-crossref 利用のため 3.9 系に固定する。
FROM pandoc/extra:3.9-ubuntu

COPY --from=0 /tmp/fonts/ /usr/local/share/fonts

RUN fc-cache -f

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl fonts-takao fonts-ipafont git xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY install-tlmgr-packages.sh /usr/local/bin/install-tlmgr-packages.sh
RUN chmod +x /usr/local/bin/install-tlmgr-packages.sh \
    && install-tlmgr-packages.sh

COPY install-pandoc-crossref.sh /usr/local/bin/install-pandoc-crossref.sh
RUN chmod +x /usr/local/bin/install-pandoc-crossref.sh \
    && install-pandoc-crossref.sh
