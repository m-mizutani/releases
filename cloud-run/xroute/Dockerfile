FROM ghcr.io/m-mizutani/xroute:1ac733cefcad4968e7a4d5a3ca57ba01c4303951

COPY policy /policy

ENV XROUTE_POLICY=/policy
ENV XROUTE_ADDR=0.0.0.0:8080
ENV XROUTE_LOG_FORMAT=json
ENV XROUTE_LOG_LEVEL=debug

EXPOSE 8080

ENTRYPOINT ["/xroute", "serve"]
