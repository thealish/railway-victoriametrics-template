FROM victoriametrics/victoria-metrics:latest

EXPOSE 8428

CMD ["-storageDataPath=/data", \
     "-httpListenAddr=:8428", \
     "-retentionPeriod=1", \
     "-search.latencyOffset=30s", \
     "-search.maxUniqueTimeseries=300000"]
