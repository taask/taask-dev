FROM gcr.io/linkerd-io/grafana:stable-2.1.0 as linkerd-graf

FROM grafana/grafana:5.4.2

RUN mkdir -p /etc/grafana/provisioning/datasources

COPY datasource.yaml /etc/grafana/provisioning/datasources/
COPY dashboards.yaml /etc/grafana/provisioning/dashboards/

COPY dashboards/taask.json /etc/grafana/provisioning/dashboards/
COPY --from=linkerd-graf /var/lib/grafana/dashboards/* /etc/grafana/provisioning/dashboards/

EXPOSE 3000