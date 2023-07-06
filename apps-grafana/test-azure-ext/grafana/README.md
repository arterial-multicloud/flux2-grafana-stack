# grafana

## deployyment

```bash
$ k get all -n grafana

NAME                          READY   STATUS    RESTARTS   AGE
pod/grafana-589878cff-2lcrz   1/1     Running   0          17h
pod/grafana-589878cff-fp9m6   1/1     Running   0          17h
pod/grafana-589878cff-gkxrn   1/1     Running   0          17h

NAME              TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/grafana   ClusterIP   10.0.77.46   <none>        80/TCP    22h

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/grafana   3/3     3            3           22h

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/grafana-589878cff    3         3         3       22h
replicaset.apps/grafana-59bfccbf87   0         0         0       17h
replicaset.apps/grafana-5bffdc6766   0         0         0       22h
replicaset.apps/grafana-5cf8945cc8   0         0         0       22h

NAME                                          REFERENCE            TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/grafana   Deployment/grafana   <unknown>/60%   3         5         3          22h

$ k get NetworkPolicy -n grafana

NAME                                       POD-SELECTOR   AGE
allow-from-ingress-controller-to-grafana   app=grafana    7m22s

```

## Workload identity (non-prod workaround and discussion)

See TROUBLE.md and [https://github.com/grafana/grafana/discussions/53645](https://github.com/grafana/grafana/discussions/53645)

## generate dashboard yaml (example)

```bash
ls -1 | while read dashboard
do
  echo "        $(echo $dashboard | awk 'BEGIN{FS="."} {print $1}'):"
  echo "          url: https://raw.githubusercontent.com/grafana/grafana/tree/main/public/app/plugins/datasource/azuremonitor/dashboards/$dashboard"
  echo "          datasource: Azure Monitor"
done
```
