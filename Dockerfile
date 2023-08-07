ARG BUILDER=golang:1.20.6-alpine3.17
ARG PROD=alpine:3.17
ARG CLOAK_VER=v2.7.0

FROM $BUILDER as builder
RUN apk add make git

# Build
RUN --mount=type=cache,target=/go/pkg \
	set -ex \
    && cd /go/src \
    && git clone https://github.com/cbeuw/Cloak \
    && cd Cloak \
    && git checkout $CLOAK_VER \
    && go get ./... \
    && make \
    && pwd \
    && ls ./build


FROM $PROD as prod

# Copy bins and config
COPY --from=builder /go/src/Cloak/build/ck-server /opt/cloak/

WORKDIR /opt/cloak

ENTRYPOINT ["/opt/cloak/ck-server"]