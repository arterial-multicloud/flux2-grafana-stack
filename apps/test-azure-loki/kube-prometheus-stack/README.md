# prometheus

## deployment

```bash
$ k get all -n prometheus
NAME                                                            READY   STATUS    RESTARTS   AGE
pod/kube-prometheus-stack-grafana-8d55458cc-75lh2               3/3     Running   0          3h52m
pod/kube-prometheus-stack-kube-state-metrics-6d55456bc7-9gtn2   1/1     Running   0          3h52m
pod/kube-prometheus-stack-operator-75586d4df6-7hf6l             1/1     Running   0          3h52m
pod/kube-prometheus-stack-prometheus-node-exporter-8p7s5        1/1     Running   0          3h52m
pod/kube-prometheus-stack-prometheus-node-exporter-g5slv        1/1     Running   0          3h52m
pod/kube-prometheus-stack-prometheus-node-exporter-qjc69        1/1     Running   0          3h52m
pod/prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   0          3h52m

NAME                                                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/kube-prometheus-stack-grafana                    ClusterIP   10.0.94.199    <none>        80/TCP     3h52m
service/kube-prometheus-stack-kube-state-metrics         ClusterIP   10.0.249.130   <none>        8080/TCP   3h52m
service/kube-prometheus-stack-operator                   ClusterIP   10.0.128.24    <none>        443/TCP    3h52m
service/kube-prometheus-stack-prometheus                 ClusterIP   10.0.249.56    <none>        9090/TCP   3h52m
service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   10.0.188.215   <none>        9100/TCP   3h52m
service/prometheus-operated                              ClusterIP   None           <none>        9090/TCP   3h52m

NAME                                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/kube-prometheus-stack-prometheus-node-exporter   3         3         3       3            3           <none>          3h52m

NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kube-prometheus-stack-grafana              1/1     1            1           3h52m
deployment.apps/kube-prometheus-stack-kube-state-metrics   1/1     1            1           3h52m
deployment.apps/kube-prometheus-stack-operator             1/1     1            1           3h52m

NAME                                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/kube-prometheus-stack-grafana-8d55458cc               1         1         1       3h52m
replicaset.apps/kube-prometheus-stack-kube-state-metrics-6d55456bc7   1         1         1       3h52m
replicaset.apps/kube-prometheus-stack-operator-75586d4df6             1         1         1       3h52m

NAME                                                           READY   AGE
statefulset.apps/prometheus-kube-prometheus-stack-prometheus   1/1     3h52m
```
