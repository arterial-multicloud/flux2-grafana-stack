# loki generated configuration

## Helm

```bash
$ helm search repo loki
NAME                            CHART VERSION   APP VERSION     DESCRIPTION                                       
grafana/loki                    5.5.3           2.8.2           Helm chart for Grafana Loki in simple, scalable...
grafana/loki-canary             0.11.0          2.7.4           Helm chart for Grafana Loki Canary                
grafana/loki-distributed        0.69.16         2.8.2           Helm chart for Grafana Loki in microservices mode 
grafana/loki-simple-scalable    1.8.11          2.6.1           Helm chart for Grafana Loki in simple, scalable...
grafana/loki-stack              2.9.10          v2.6.1          Loki: like Prometheus, but for logs.              
grafana/fluent-bit              2.5.0           v2.1.0          Uses fluent-bit Loki go plugin for gathering lo...
grafana/promtail                6.11.2          2.8.2           Promtail is an agent which ships the contents o...
```

## deployyment

```bash

$ k get all -n loki

NAME                                               READY   STATUS    RESTARTS   AGE
pod/loki-0                                         1/1     Running   0          17h
pod/loki-1                                         1/1     Running   0          17h
pod/loki-2                                         1/1     Running   0          17h
pod/loki-canary-86j9j                              1/1     Running   0          20h
pod/loki-canary-l278g                              1/1     Running   0          20h
pod/loki-canary-lz292                              1/1     Running   0          20h
pod/loki-gateway-d45b5679f-79wv2                   1/1     Running   0          20h
pod/loki-grafana-agent-operator-684b478b77-4ph95   1/1     Running   0          20h
pod/loki-logs-6sg92                                2/2     Running   0          20h
pod/loki-logs-h49sm                                2/2     Running   0          20h
pod/loki-logs-j6wf7                                2/2     Running   0          20h

NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
service/loki              ClusterIP   10.0.81.12     <none>        3100/TCP,9095/TCP   20h
service/loki-canary       ClusterIP   10.0.168.250   <none>        3500/TCP            20h
service/loki-gateway      ClusterIP   10.0.56.200    <none>        80/TCP              20h
service/loki-headless     ClusterIP   None           <none>        3100/TCP            20h
service/loki-memberlist   ClusterIP   None           <none>        7946/TCP            20h

NAME                         DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/loki-canary   3         3         3       3            3           <none>          20h
daemonset.apps/loki-logs     3         3         3       3            3           <none>          20h

NAME                                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/loki-gateway                  1/1     1            1           20h
deployment.apps/loki-grafana-agent-operator   1/1     1            1           20h

NAME                                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/loki-gateway-d45b5679f                   1         1         1       20h
replicaset.apps/loki-grafana-agent-operator-684b478b77   1         1         1       20h

NAME                    READY   AGE
statefulset.apps/loki   3/3     20h
```

## monitoring

https://grafana.com/docs/loki/latest/installation/helm/monitor-and-alert/with-local-monitoring/