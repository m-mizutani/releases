FROM ghcr.io/m-mizutani/xroute:365254519a1db6d7bfee7911bb7f6ce1f669bf8d

COPY policy /policy

ENV XROUTE_POLICY=/policy
ENV XROUTE_ADDR=0.0.0.0:8080
ENV XROUTE_LOG_FORMAT=json
ENV XROUTE_LOG_LEVEL=debug

EXPOSE 8080

ENTRYPOINT ["/xroute", "serve"]
