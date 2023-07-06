# loki

NOTE: loki-stack is no longer maintained, use loki [https://artifacthub.io/packages/helm/grafana/loki](https://artifacthub.io/packages/helm/grafana/loki)

Use the loki helmchart if you want SSD mode or loki-distributed if you’re interested on microservices mode.

https://grafana.com/docs/loki/latest/installation/helm/

## chart version

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm search repo grafana/tempo --versions

$ helm search repo grafana/loki --versions
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
grafana/tempo                   1.3.1           2.1.1           Grafana Tempo Single Binary Mode                  
grafana/tempo                   1.3.0           2.1.1           Grafana Tempo Single Binary Mode                  
grafana/tempo                   1.2.1           2.1.1           Grafana Tempo Single Binary Mode                  
```

## install

```bash


```
