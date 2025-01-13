FROM ghcr.io/m-mizutani/xroute:5925dca6bb1295cb7da4d65bcd2ce418d16f1b9f

COPY policy /policy

ENV XROUTE_POLICY=/policy
ENV XROUTE_ADDR=0.0.0.0:8080
ENV XROUTE_LOG_FORMAT=json
ENV XROUTE_LOG_LEVEL=debug

EXPOSE 8080

ENTRYPOINT ["/xroute", "serve"]
