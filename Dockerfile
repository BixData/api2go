FROM golang:1.9

ARG REFRESHED_AT=2018-01-19
ARG BUILD_VERSION=0.0.0

# ============================================================
# Add sources and install dependencies
# ============================================================

COPY . $GOPATH/src/github.com/BixData/api2go
WORKDIR $GOPATH/src/github.com/BixData/api2go
RUN go get -u github.com/jstemmer/go-junit-report
RUN go get -u github.com/golang/dep/cmd/dep
RUN dep ensure -v

# ============================================================
# Build
# ============================================================

ENV GOOS=linux
ENV CGO_ENABLED=0
RUN mkdir -p /target && \
    go test -v -short -count=1 ./... | tee /dev/stderr | $GOPATH/bin/go-junit-report > /target/test-report.xml
