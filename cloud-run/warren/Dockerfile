FROM ghcr.io/secmon-lab/warren:c03518b0bee1229f086df7d6e36fae4c63d963ad

COPY policy /policy

ENV WARREN_ADDR="0.0.0.0:8080"
ENV WARREN_LOG_FORMAT="json"
ENV WARREN_LOG_LEVEL=debug
ENV WARREN_POLICY=/policy
ENV WARREN_SLACK_CHANNEL_NAME="alert"
ENV WARREN_FIRESTORE_PROJECT_ID="mztn-compute"
ENV WARREN_FIRESTORE_DATABASE_ID="warren-v0"
ENV WARREN_GEMINI_PROJECT_ID="mztn-compute"

EXPOSE 8080
