FROM golang:1.22 AS build-go
ENV CGO_ENABLED=0
ARG BUILD_VERSION

WORKDIR /app
RUN go env -w GOMODCACHE=/root/.cache/go-build

COPY go.mod go.sum ./
RUN go mod download

COPY . /app
RUN go build -o server

FROM gcr.io/distroless/base:nonroot
USER nonroot
COPY --from=build-go /app/server /server

WORKDIR /
ENV ADDR="0.0.0.0:8000"
ENV CLOUD_STORAGE_BUCKET=mztn-seccamp2024-common
ENV CLOUD_STORAGE_OBJECT=test.logs
EXPOSE 8000

ENTRYPOINT ["/server"]
