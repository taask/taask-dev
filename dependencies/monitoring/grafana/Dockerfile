FROM grafana/grafana:5.4.2

RUN mkdir -p /etc/grafana/provisioning/datasources

COPY datasource.yaml /etc/grafana/provisioning/datasources/

COPY dashboard.json /etc/grafana/provisioning/dashboards/
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/

EXPOSE 3000