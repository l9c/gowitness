FROM golang:1 as build

LABEL maintainer="Leon Jacobs <leonja511@gmail.com>"

COPY . /src

WORKDIR /src
RUN make generate docker

# final image
# https://github.com/chromedp/docker-headless-shell#using-as-a-base-image
FROM chromedp/headless-shell:latest

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    fonts-noto \
    fonts-noto-cjk \
    dumb-init \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

COPY --from=build /src/gowitness /usr/local/bin

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["dumb-init", "--"]
