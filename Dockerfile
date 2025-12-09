FROM --platform=$BUILDPLATFORM golang:1.22.1 AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

WORKDIR /mysrc
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -ldflags "-w -s" -o webhookbot

FROM scratch
WORKDIR /app
COPY --from=builder /mysrc/webhookbot .
ADD https://curl.se/ca/cacert.pem /etc/ssl/certs/

ENTRYPOINT ["/app/webhookbot"]
CMD ["--config", "/app/webhookbot.yaml"]
