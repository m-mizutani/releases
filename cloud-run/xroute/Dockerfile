FROM ghcr.io/m-mizutani/xroute:4b738e0f13c0b9cc72b0aac780a360463bbd4547

COPY policy /policy

ENV XROUTE_POLICY=/policy
ENV XROUTE_ADDR=0.0.0.0:8080
ENV XROUTE_LOG_FORMAT=json
ENV XROUTE_LOG_LEVEL=debug

EXPOSE 8080

ENTRYPOINT ["/xroute", "serve"]
