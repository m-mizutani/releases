FROM golang:1.22 AS build-go
ENV CGO_ENABLED=0
ARG BUILD_VERSION

WORKDIR /app
RUN go env -w GOMODCACHE=/root/.cache/go-build

COPY go.mod go.sum ./
RUN --mount=type=cache,target=/root/.cache/go-build go mod download

COPY . /app
RUN --mount=type=cache,target=/root/.cache/go-build go build -o server

FROM gcr.io/distroless/base:nonroot
USER nonroot
COPY --from=build-go /app/server /server

WORKDIR /
ENV NOUNIFY_ADDR="0.0.0.0:8000"
EXPOSE 8000

ENTRYPOINT ["/server"]
