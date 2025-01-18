FROM ghcr.io/m-mizutani/xroute:3d5d5a9a20c2f1ee315af9bd44ff4e204b0b92c4

COPY policy /policy

ENV XROUTE_POLICY=/policy
ENV XROUTE_ADDR=0.0.0.0:8080
ENV XROUTE_LOG_FORMAT=json
ENV XROUTE_LOG_LEVEL=debug

EXPOSE 8080

ENTRYPOINT ["/xroute", "serve"]
