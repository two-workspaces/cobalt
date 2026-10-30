FROM ghcr.io/imputnet/cobalt:11.7.1

# Cobalt POSTs to the PO token server with no body, and bgutil 2.x answers that with 415
# (it requires a JSON content type). Send an empty JSON object; the build fails if upstream moves.
USER root
RUN f=/app/src/processing/helpers/youtube-session.js \
 && grep -q "{ method: 'POST', dispatcher: defaultAgent }" "$f" \
 && sed -i "s|{ method: 'POST', dispatcher: defaultAgent }|{ method: 'POST', headers: { 'content-type': 'application/json' }, body: '{}', dispatcher: defaultAgent }|" "$f"
COPY --chmod=755 railway-entrypoint.sh /railway-entrypoint.sh
USER node

CMD ["/railway-entrypoint.sh"]
