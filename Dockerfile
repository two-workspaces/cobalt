FROM ghcr.io/imputnet/cobalt:11.7.1

COPY --chmod=755 railway-entrypoint.sh /railway-entrypoint.sh

CMD ["/railway-entrypoint.sh"]
