# loki

NOTE: loki-stack is no longer maintained, use loki [https://artifacthub.io/packages/helm/grafana/loki](https://artifacthub.io/packages/helm/grafana/loki)

Use the loki helmchart if you want SSD mode or loki-distributed if you’re interested on microservices mode.

https://grafana.com/docs/loki/latest/installation/helm/

## chart version

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm search repo grafana/loki --versions

$ helm search repo grafana/loki --versions
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
grafana/loki                    5.5.3           2.8.2           Helm chart for Grafana Loki in simple, scalable...
grafana/loki                    5.5.2           2.8.2           Helm chart for Grafana Loki in simple, scalable...
grafana/loki                    5.5.1           2.8.2           Helm chart for Grafana Loki in simple, scalable...
```
