# tempo generated configuration

## /conf/tempo.yaml

```yaml
multitenancy_enabled: false
usage_report:
  reporting_enabled: false
compactor:
  compaction:
    block_retention: 24h
distributor:
  receivers:
        jaeger:
          protocols:
            grpc:
              endpoint: 0.0.0.0:14250
            thrift_binary:
              endpoint: 0.0.0.0:6832
            thrift_compact:
              endpoint: 0.0.0.0:6831
            thrift_http:
              endpoint: 0.0.0.0:14268
        opencensus: null
        otlp:
          protocols:
            grpc:
              endpoint: 0.0.0.0:4317
            http:
              endpoint: 0.0.0.0:4318
ingester:
      {}
server:
      http_listen_port: 3100
storage:
      trace:
        azure:
          container_name: tempo
          storage_account_key: ${AZURE_ACCOUNT_KEY}
          storage_account_name: opsstackidmzweutestdatsa
        backend: azure
        local:
          path: /var/tempo/traces
        wal:
          path: /var/tempo/wal
querier:
      {}
query_frontend:
      {}
overrides:
      per_tenant_override_config: /conf/overrides.yaml
```

## deployyment

```bash
$ k get all -n tempo

NAME          READY   STATUS    RESTARTS   AGE
pod/tempo-0   1/1     Running   0          120m

NAME            TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                                                                                                   AGE
service/tempo   ClusterIP   10.0.130.224   <none>        3100/TCP,6831/UDP,6832/UDP,14268/TCP,14250/TCP,9411/TCP,55680/TCP,55681/TCP,4317/TCP,4318/TCP,55678/TCP   178m

NAME                     READY   AGE
statefulset.apps/tempo   1/1     178m
```
