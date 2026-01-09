FROM caddy:2.7-alpine

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
