FROM victoriametrics/vmagent:v1.96.0

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8429

ENTRYPOINT ["/entrypoint.sh"]

