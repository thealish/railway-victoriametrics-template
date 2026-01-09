FROM grafana/grafana:12.4.0

USER root

COPY provisioning/datasources /etc/grafana/provisioning/datasources
COPY provisioning/dashboards /etc/grafana/provisioning/dashboards

RUN chown -R grafana:root /etc/grafana/provisioning

USER grafana

EXPOSE 3000

