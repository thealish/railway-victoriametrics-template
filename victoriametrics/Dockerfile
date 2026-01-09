FROM victoriametrics/victoria-metrics:latest

EXPOSE 8428

# Volume configured via railway.json

CMD ["/victoria-metrics-prod", \
     "-storageDataPath=/data", \
     "-httpListenAddr=:8428", \
     "-retentionPeriod=${RETENTION_PERIOD:-1}", \
     "-search.latencyOffset=${SEARCH_LATENCY_OFFSET:-30s}", \
     "-search.maxUniqueTimeseries=${MAX_UNIQUE_TIMESERIES:-300000}"]

