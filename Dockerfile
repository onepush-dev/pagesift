# PageSift on Railway: the official image (YOLOW92/pagesift 1.2.1, AGPL-3.0),
# unmodified, with a tiny start script:
#   - Railway mounts volumes root-owned, so it hands /data to the image's
#     unprivileged `pagesift` user (uid 10001) and then drops to it;
#   - listens on [::]:$PORT (dual-stack) so Railway's healthcheck and the
#     private network (IPv6) reach it, not just IPv4.
# PAGESIFT_API_KEYS (generated per deploy) is required on every API call.
FROM ghcr.io/yolow92/pagesift:1.2.1@sha256:7625437cf08550692c0bace4fc713bc5e675b1a826fa9b8bf27bc77dfc8c551b
USER root
COPY railway/start.sh /usr/local/bin/pagesift-railway-start
RUN chmod 755 /usr/local/bin/pagesift-railway-start
ENV PORT=8080 \
    PAGESIFT_HOST=::
EXPOSE 8080
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/pagesift-railway-start"]
