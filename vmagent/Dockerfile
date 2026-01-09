FROM victoriametrics/vmagent:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8429

ENTRYPOINT ["/entrypoint.sh"]

