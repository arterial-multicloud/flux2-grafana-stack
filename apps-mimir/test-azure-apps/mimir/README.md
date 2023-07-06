# mimir

```yaml
 cat /etc/mimir/mimir.yaml

activity_tracker:
  filepath: /active-query-tracker/activity.log
alertmanager:
  data_dir: /data
  enable_api: true
  external_url: /alertmanager
  fallback_config_file: /configs/alertmanager_fallback_config.yaml
alertmanager_storage:
  azure:
    container_name: mimir-alertmanager
blocks_storage:
  azure:
    container_name: mimir-blocks
  backend: s3
  bucket_store:
    max_chunk_pool_bytes: 12884901888
    sync_dir: /data/tsdb-sync
  tsdb:
    dir: /data/tsdb
    head_compaction_interval: 15m
    wal_replay_concurrency: 3
common:
  storage:
    azure:
      account_key: ${SWIFT_ACCOUNT_KEY}
      account_name: mimir-prod
      endpoint_suffix: blob.core.windows.net
    backend: azure
compactor:
  compaction_interval: 30m
  data_dir: /data
  deletion_delay: 2h
  first_level_compaction_wait_per
iod: 25m
  max_closing_blocks_concurrency: 2
  max_opening_blocks_concurrency: 4
  sharding_ring:
    wait_stability_min_duration: 1m
  symbols_flushers_concurrency: 4
frontend:
  align_queries_with_step: true
  log_queries_longer_than: 10s
  parallelize_shardable_queries: true
  scheduler_address: mimir-query-scheduler-headless.mimir.svc:9095
frontend_worker:
  grpc_client_config:
    max_send_msg_size: 419430400
  scheduler_address: mimir-query-scheduler-headless.mimir.svc:9095
ingester:
  ring:
    final_sleep: 0s
    num_tokens: 512
    tokens_file_path: /data/tokens
    unregister_on_shutdown: false
ingester_client:
  grpc_client_config:
    max_recv_msg_size: 104857600
    max_send_msg_size: 104857600
limits:
  ingestion_burst_size: 2000000
  ingestion_rate: 200000
  max_cache_freshness: 10m
  max_global_series_per_user: 0
  max_query_parallelism: 240
  max_total_query_length: 12000h
  out_of_order_time_window: 30m
memberlist:
  abort_if_cluster_join_fails: false
  compression_enabled: false
  join_members:
  - dns+mimir-gossip-ring.mimir.svc.cluster.local:7946
multitenancy_enabled: false
querier:
  max_concurrent: 16
query_scheduler:
  max_outstanding_requests_per_tenant: 800
ruler:
  alertmanager_url: dnssrvnoa+http://_http-metrics._tcp.mimir-alertmanager-headless.mimir.svc.cluster.local/alertmanager
  enable_api: true
  rule_path: /data
ruler_storage:
  azure:
    container_name: mimir-ruler
runtime_config:
  file: /var/mimir/runtime.yaml
server:
  grpc_server_max_concurrent_streams: 1000
  grpc_server_max_connection_age: 2m
  grpc_server_max_connection_age_grace: 5m
  grpc_server_max_connection_idle: 1m
  grpc_server_max_recv_msg_size: 104857600
  grpc_server_max_send_msg_size: 104857600
store_gateway:
  sharding_ring:
    tokens_file_path: /data/tokens
    unregister_on_shutdown: false
    wait_stability_min_duration: 1m
usage_stats:
  installation_mode: helm
```

```bash
$ k get all -n mimir

NAME                                            READY   STATUS             RESTARTS          AGE
pod/mimir-alertmanager-0                        0/1     Running            95 (6m19s ago)    14h
pod/mimir-compactor-0                           0/1     CrashLoopBackOff   170 (3m54s ago)   14h
pod/mimir-distributor-8487f6477f-tztvn          1/1     Running            0                 14h
pod/mimir-ingester-0                            0/1     CrashLoopBackOff   170 (4m7s ago)    14h
pod/mimir-ingester-1                            0/1     CrashLoopBackOff   171 (14s ago)     14h
pod/mimir-ingester-2                            0/1     CrashLoopBackOff   170 (4m47s ago)   14h
pod/mimir-nginx-7455659959-4m62n                1/1     Running            0                 14h
pod/mimir-overrides-exporter-79f6bf9c99-xftcm   1/1     Running            0                 14h
pod/mimir-querier-857c5fff78-2hns2              0/1     CrashLoopBackOff   170 (3m53s ago)   14h
pod/mimir-querier-857c5fff78-46wdx              0/1     CrashLoopBackOff   171 (6s ago)      14h
pod/mimir-query-frontend-65c8c4fcf7-kz7pp       1/1     Running            0                 14h
pod/mimir-query-scheduler-b966b5bb6-kvbr9       1/1     Running            0                 14h
pod/mimir-query-scheduler-b966b5bb6-lz9j4       1/1     Running            0                 14h
pod/mimir-ruler-75b46789b-qggtk                 0/1     CrashLoopBackOff   187 (2m12s ago)   14h
pod/mimir-store-gateway-0                       0/1     CrashLoopBackOff   171 (27s ago)     14h

NAME                                     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
service/mimir-alertmanager               ClusterIP   10.0.36.216    <none>        8080/TCP,9095/TCP            14h
service/mimir-alertmanager-headless      ClusterIP   None           <none>        8080/TCP,9095/TCP,9094/TCP   14h
service/mimir-compactor                  ClusterIP   10.0.26.8      <none>        8080/TCP,9095/TCP            14h
service/mimir-distributor                ClusterIP   10.0.251.248   <none>        8080/TCP,9095/TCP            14h
service/mimir-distributor-headless       ClusterIP   None           <none>        8080/TCP,9095/TCP            14h
service/mimir-gossip-ring                ClusterIP   None           <none>        7946/TCP                     14h
service/mimir-ingester                   ClusterIP   10.0.104.169   <none>        8080/TCP,9095/TCP            14h
service/mimir-ingester-headless          ClusterIP   None           <none>        8080/TCP,9095/TCP            14h
service/mimir-nginx                      ClusterIP   10.0.120.238   <none>        80/TCP                       14h
service/mimir-overrides-exporter         ClusterIP   10.0.19.91     <none>        8080/TCP,9095/TCP            14h
service/mimir-querier                    ClusterIP   10.0.195.217   <none>        8080/TCP,9095/TCP            14h
service/mimir-query-frontend             ClusterIP   10.0.213.189   <none>        8080/TCP,9095/TCP            14h
service/mimir-query-scheduler            ClusterIP   10.0.215.67    <none>        8080/TCP,9095/TCP            14h
service/mimir-query-scheduler-headless   ClusterIP   None           <none>        8080/TCP,9095/TCP            14h
service/mimir-ruler                      ClusterIP   10.0.29.255    <none>        8080/TCP                     14h
service/mimir-store-gateway              ClusterIP   10.0.255.89    <none>        8080/TCP,9095/TCP            14h
service/mimir-store-gateway-headless     ClusterIP   None           <none>        8080/TCP,9095/TCP            14h

NAME                                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mimir-distributor          1/1     1            1           14h
deployment.apps/mimir-nginx                1/1     1            1           14h
deployment.apps/mimir-overrides-exporter   1/1     1            1           14h
deployment.apps/mimir-querier              0/2     2            0           14h
deployment.apps/mimir-query-frontend       1/1     1            1           14h
deployment.apps/mimir-query-scheduler      2/2     2            2           14h
deployment.apps/mimir-ruler                0/1     1            0           14h

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/mimir-distributor-8487f6477f          1         1         1       14h
replicaset.apps/mimir-nginx-7455659959                1         1         1       14h
replicaset.apps/mimir-overrides-exporter-79f6bf9c99   1         1         1       14h
replicaset.apps/mimir-querier-857c5fff78              2         2         0       14h
replicaset.apps/mimir-query-frontend-65c8c4fcf7       1         1         1       14h
replicaset.apps/mimir-query-scheduler-b966b5bb6       2         2         2       14h
replicaset.apps/mimir-ruler-75b46789b                 1         1         0       14h

NAME                                   READY   AGE
statefulset.apps/mimir-alertmanager    0/1     14h
statefulset.apps/mimir-compactor       0/1     14h
statefulset.apps/mimir-ingester        0/3     14h
statefulset.apps/mimir-store-gateway   0/1     14h

$ k get pv -n mimir
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                 STORAGECLASS   REASON   AGE
pvc-0a9f2297-6550-4c0e-831a-8910a8251ada   10Gi       RWO            Delete           Bound    loki/storage-loki-2                   default                 2d17h
pvc-51360e3d-cc88-4e15-be03-10db06c9e995   50Gi       RWO            Delete           Bound    mimir/storage-mimir-store-gateway-0   default                 14h
pvc-82f284a5-736d-4c07-951d-8ded29962b14   10Gi       RWO            Delete           Bound    loki/storage-loki-0                   default                 2d17h
pvc-98622301-93c6-4d8f-addf-2b0725aba1e7   50Gi       RWO            Delete           Bound    mimir/storage-mimir-ingester-2        default                 14h
pvc-ae8a34a7-d311-4577-8cf5-57b24cb6262e   50Gi       RWO            Delete           Bound    mimir/storage-mimir-ingester-0        default                 14h
pvc-c87351c8-511f-43a7-96a7-ac2223895a08   50Gi       RWO            Delete           Bound    mimir/storage-mimir-ingester-1        default                 14h
pvc-db3d2e3e-2bbf-4c24-b7a4-7b82e5115d4d   1Gi        RWO            Delete           Bound    mimir/storage-mimir-alertmanager-0    default                 14h
pvc-e4922182-ba5e-4bf1-aba6-d469e4c47c09   10Gi       RWO            Delete           Bound    loki/storage-loki-1                   default                 2d17h
pvc-ff3a757b-5634-4557-a995-08db1ecb0ac5   50Gi       RWO            Delete           Bound    mimir/storage-mimir-compactor-0       default                 14h

$ k get configmap -n mimir
NAME                                 DATA   AGE
kube-root-ca.crt                     1      15h
mimir-alertmanager-fallback-config   1      15h
mimir-config                         1      15h
mimir-nginx                          1      15h
mimir-runtime                        1      15h
adminuser@vm-hub-linux:~$


$ k get configmap -n mimir mimir-config -o yaml
apiVersion: v1
data:
  mimir.yaml: |2

    activity_tracker:
      filepath: /active-query-tracker/activity.log
    alertmanager:
      data_dir: /data
      enable_api: true
      external_url: /alertmanager
      fallback_config_file: /configs/alertmanager_fallback_config.yaml
    alertmanager_storage:
      azure:
        container_name: mimir-alertmanager
    blocks_storage:
      azure:
        container_name: mimir-blocks
      backend: s3
      bucket_store:
        max_chunk_pool_bytes: 12884901888
        sync_dir: /data/tsdb-sync
      tsdb:
        dir: /data/tsdb
        head_compaction_interval: 15m
        wal_replay_concurrency: 3
    common:
      storage:
        azure:
          account_key: ${AZURE_SA_ACCOUNT_KEY}
          account_name: ${AZURE_SA_ACCOUNT_NAME}
          endpoint_suffix: blob.core.windows.net
        backend: azure
    compactor:
      compaction_interval: 30m
      data_dir: /data
      deletion_delay: 2h
      first_level_compaction_wait_period: 25m
      max_closing_blocks_concurrency: 2
      max_opening_blocks_concurrency: 4
      sharding_ring:
        wait_stability_min_duration: 1m
      symbols_flushers_concurrency: 4
    frontend:
      align_queries_with_step: true
      log_queries_longer_than: 10s
      parallelize_shardable_queries: true
      scheduler_address: mimir-query-scheduler-headless.mimir.svc:9095
    frontend_worker:
      grpc_client_config:
        max_send_msg_size: 419430400
      scheduler_address: mimir-query-scheduler-headless.mimir.svc:9095
    ingester:
      ring:
        final_sleep: 0s
        num_tokens: 512
        tokens_file_path: /data/tokens
        unregister_on_shutdown: false
    ingester_client:
      grpc_client_config:
        max_recv_msg_size: 104857600
        max_send_msg_size: 104857600
    limits:
      ingestion_burst_size: 2000000
      ingestion_rate: 200000
      max_cache_freshness: 10m
      max_global_series_per_user: 0
      max_query_parallelism: 240
      max_total_query_length: 12000h
      out_of_order_time_window: 30m
    memberlist:
      abort_if_cluster_join_fails: false
      compression_enabled: false
      join_members:
      - dns+mimir-gossip-ring.mimir.svc.cluster.local:7946
    multitenancy_enabled: false
    querier:
      max_concurrent: 16
    query_scheduler:
      max_outstanding_requests_per_tenant: 800
    ruler:
      alertmanager_url: dnssrvnoa+http://_http-metrics._tcp.mimir-alertmanager-headless.mimir.svc.cluster.local/alertmanager
      enable_api: true
      rule_path: /data
    ruler_storage:
      azure:
        container_name: mimir-ruler
    runtime_config:
      file: /var/mimir/runtime.yaml
    server:
      grpc_server_max_concurrent_streams: 1000
      grpc_server_max_connection_age: 2m
      grpc_server_max_connection_age_grace: 5m
      grpc_server_max_connection_idle: 1m
      grpc_server_max_recv_msg_size: 104857600
      grpc_server_max_send_msg_size: 104857600
    store_gateway:
      sharding_ring:
        tokens_file_path: /data/tokens
        unregister_on_shutdown: false
        wait_stability_min_duration: 1m
    usage_stats:
      installation_mode: helm
kind: ConfigMap
metadata:
  annotations:
    meta.helm.sh/release-name: mimir
    meta.helm.sh/release-namespace: mimir
  creationTimestamp: "2023-06-08T16:49:09Z"
  labels:
    app.kubernetes.io/instance: mimir
    app.kubernetes.io/managed-by: Helm
    app.kubernetes.io/name: mimir
    app.kubernetes.io/version: 2.8.0
    helm.sh/chart: mimir-distributed-4.4.1
    helm.toolkit.fluxcd.io/name: mimir
    helm.toolkit.fluxcd.io/namespace: mimir
  name: mimir-config
  namespace: mimir
  resourceVersion: "1543079"
  uid: 1bdb5ba5-06d1-44b1-bb94-3633ee59cb10

```

