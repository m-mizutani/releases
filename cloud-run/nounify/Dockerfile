FROM ghcr.io/m-mizutani/nounify:65d72faba6bab1c05a0a2138c1f2c2fad7f7b80f

COPY policy /policy

ENV NOUNIFY_POLICY_FILE=/policy
ENV NOUNIFY_ADDR=0.0.0.0:8080
ENV NOUNIFY_LOG_FORMAT=json
ENV NOUNIFY_LOG_LEVEL=debug
EXPOSE 8080

ENTRYPOINT ["/nounify", "serve"]

