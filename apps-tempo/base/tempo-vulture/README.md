# loki

NOTE: loki-stack is no longer maintained, use loki [https://artifacthub.io/packages/helm/grafana/loki](https://artifacthub.io/packages/helm/grafana/loki)

Use the loki helmchart if you want SSD mode or loki-distributed if you’re interested on microservices mode.

https://grafana.com/docs/loki/latest/installation/helm/

## chart version

```bash
helm repo add grafana https://grafana.github.io/helm-charts

$ helm search repo grafana/tempo-vulture --versions

NAME                    CHART VERSION   APP VERSION     DESCRIPTION                                       
grafana/tempo-vulture   0.2.3           1.3.0           Grafana Tempo Vulture - A tool to monitor Tempo...
grafana/tempo-vulture   0.2.2           1.3.0           Grafana Tempo Vulture - A tool to monitor Tempo...
grafana/tempo-vulture   0.2.1           1.3.0           Grafana Tempo Vulture - A tool to monitor Tempo...
grafana/tempo-vulture   0.2.0           1.3.0           Grafana Tempo Vulture - A tool to monitor Tempo...
grafana/tempo-vulture   0.1.0           0.7.0           Grafana Tempo Vulture - A tool to monitor Tempo...
```