FROM victoriametrics/victoria-metrics:v1.96.0

EXPOSE 8428

VOLUME ["/data"]

CMD ["/victoria-metrics-prod", \
     "-storageDataPath=/data", \
     "-httpListenAddr=:8428", \
     "-retentionPeriod=${RETENTION_PERIOD:-1}", \
     "-search.latencyOffset=${SEARCH_LATENCY_OFFSET:-30s}", \
     "-search.maxUniqueTimeseries=${MAX_UNIQUE_TIMESERIES:-300000}"]

