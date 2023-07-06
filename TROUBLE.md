# Troubleshooting

## Problem

When installing Mimir and Loki in the same cluster there is a conflict

The order of installation causes mimir-log-* and/or loki-log-* to go mental, spawning hundreds of times (400+) with each pod immediately Terminating but not closing down. It overloads the cluster and causes a world of pain.  k delete doesnt work without --force, and when it is used the memory doesnt free up

### Install Loki and Mimir

When Loki and Mimir are installed in the same cluster, ensuring the prometheus CRDs are installed first, and again, loki-logs is failing in awesome style, with minutes till the cluster crashes.

$ k get pod -n loki | grep loki-logs- | grep Terminating | wc -l
603

This has happened regularly but only if I install the whole stack with product monitoring enabled. Everything works fine if I dont. It sometimes works if I partially enable monitoring.

The failing code is at this commit https://github.com/arterial-multicloud/flux2-grafana-stack/tree/82401bbdff4bb5fa0092df75756b364f69a9e5a5

I cannot see how to identify what is causing the pod to terminate.  Should I raise a bug? If so against which product.

It is worth noting that all apps get installed simultaneously, there are no dependencies in there currently.  If there is a preferred order please let me know.

### Install Loki then Mimir:

An ordered install of Loki then Mimir. Running individally Loki will run quite happily until the Mimir install

The failing code is at https://github.com/arterial-multicloud/flux2-grafana-stack/tree/d65a8a298de1dba72ece8117a48791ea601605de


```bash
$ k api-versions | grep monitoring

monitoring.coreos.com/v1
monitoring.coreos.com/v1alpha1
monitoring.grafana.com/v1alpha1

$ k api-resources | grep monitoring

alertmanagerconfigs               amcfg               monitoring.coreos.com/v1alpha1           true         AlertmanagerConfig
alertmanagers                     am                  monitoring.coreos.com/v1                 true         Alertmanager
podmonitors                       pmon                monitoring.coreos.com/v1                 true         PodMonitor
probes                            prb                 monitoring.coreos.com/v1                 true         Probe
prometheuses                      prom                monitoring.coreos.com/v1                 true         Prometheus
prometheusrules                   promrule            monitoring.coreos.com/v1                 true         PrometheusRule
servicemonitors                   smon                monitoring.coreos.com/v1                 true         ServiceMonitor
thanosrulers                      ruler               monitoring.coreos.com/v1                 true         ThanosRuler
grafanaagents                                         monitoring.grafana.com/v1alpha1          true         GrafanaAgent
integrations                                          monitoring.grafana.com/v1alpha1          true         Integration
logsinstances                                         monitoring.grafana.com/v1alpha1          true         LogsInstance
metricsinstances                                      monitoring.grafana.com/v1alpha1          true         MetricsInstance
podlogs                                               monitoring.grafana.com/v1alpha1          true         PodLogs


$ k describe hr -n loki loki | tail -15
  ----     ------  ----               ----             -------
  Normal   info    45m                helm-controller  HelmChart 'grafana-charts/loki-loki' is not ready
  Normal   info    29m (x3 over 39m)  helm-controller  Helm uninstall succeeded
  Normal   info    29m (x4 over 44m)  helm-controller  Helm install has started
  Warning  error   24m (x4 over 39m)  helm-controller  Helm install failed: context deadline exceeded

Last Helm logs:

CRD grafanaagents.monitoring.grafana.com is already present. Skipping.
CRD integrations.monitoring.grafana.com is already present. Skipping.
CRD logsinstances.monitoring.grafana.com is already present. Skipping.
CRD metricsinstances.monitoring.grafana.com is already present. Skipping.
CRD podlogs.monitoring.grafana.com is already present. Skipping.
  Warning  error  24m (x4 over 39m)  helm-controller  reconciliation failed: Helm install failed: context deadline exceeded
  Warning  error  11m (x7 over 24m)  helm-controller  reconciliation failed: install retries exhausted


$ k describe ds -n loki loki-logs
Name:           loki-logs
Selector:       app.kubernetes.io/instance=loki,app.kubernetes.io/managed-by=grafana-agent-operator,app.kubernetes.io/name=grafana-agent,app.kubernetes.io/version=v0.28.0,grafana-agent=loki,operator.agent.grafana.com/name=loki,operator.agent.grafana.com/type=logs
Node-Selector:  <none>
Labels:         app.kubernetes.io/instance=loki
                app.kubernetes.io/managed-by=grafana-agent-operator
                app.kubernetes.io/name=grafana-agent
                app.kubernetes.io/version=v0.28.0
                grafana-agent=loki
                operator.agent.grafana.com/name=loki
                operator.agent.grafana.com/type=logs
Annotations:    deprecated.daemonset.template.generation: 1
                meta.helm.sh/release-name: loki
                meta.helm.sh/release-namespace: loki
Desired Number of Nodes Scheduled: 6
Current Number of Nodes Scheduled: 6
Number of Nodes Scheduled with Up-to-date Pods: 6
Number of Nodes Scheduled with Available Pods: 0
Number of Nodes Misscheduled: 0
Pods Status:  0 Running / 6 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:           app.kubernetes.io/instance=loki
                    app.kubernetes.io/managed-by=grafana-agent-operator
                    app.kubernetes.io/name=grafana-agent
                    app.kubernetes.io/version=v0.28.0
                    grafana-agent=loki
                    operator.agent.grafana.com/name=loki
                    operator.agent.grafana.com/type=logs
  Annotations:      kubectl.kubernetes.io/default-container: grafana-agent
  Service Account:  loki-grafana-agent
  Containers:
   config-reloader:
    Image:      quay.io/prometheus-operator/prometheus-config-reloader:v0.47.0
    Port:       <none>
    Host Port:  <none>
    Args:
      --config-file=/var/lib/grafana-agent/config-in/agent.yml
      --config-envsubst-file=/var/lib/grafana-agent/config/agent.yml
      --watch-interval=1m
      --statefulset-ordinal-from-envvar=POD_NAME
      --reload-url=http://127.0.0.1:8080/-/reload
    Environment:
      POD_NAME:   (v1:metadata.name)
      HOSTNAME:   (v1:spec.nodeName)
      SHARD:     0
    Mounts:
      /var/lib/docker/containers from dockerlogs (ro)
      /var/lib/grafana-agent/config from config-out (rw)
      /var/lib/grafana-agent/config-in from config (ro)
      /var/lib/grafana-agent/data from data (rw)
      /var/lib/grafana-agent/secrets from secrets (ro)
      /var/log from varlog (ro)
   grafana-agent:
    Image:      grafana/agent:v0.28.0
    Port:       8080/TCP
    Host Port:  0/TCP
    Args:
      -config.file=/var/lib/grafana-agent/config/agent.yml
      -config.expand-env=true
      -server.http.address=0.0.0.0:8080
      -enable-features=integrations-next
    Readiness:  http-get http://:http-metrics/-/ready delay=0s timeout=3s period=5s #success=1 #failure=120
    Environment:
      POD_NAME:   (v1:metadata.name)
      HOSTNAME:   (v1:spec.nodeName)
      SHARD:     0
    Mounts:
      /var/lib/docker/containers from dockerlogs (ro)
      /var/lib/grafana-agent/config from config-out (rw)
      /var/lib/grafana-agent/config-in from config (ro)
      /var/lib/grafana-agent/data from data (rw)
      /var/lib/grafana-agent/secrets from secrets (ro)
      /var/log from varlog (ro)
  Volumes:
   config:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  loki-logs-config
    Optional:    false
   config-out:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
   secrets:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  loki-secrets
    Optional:    false
   varlog:
    Type:          HostPath (bare host directory volume)
    Path:          /var/log
    HostPathType:
   dockerlogs:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/docker/containers
    HostPathType:
   data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/grafana-agent/data
    HostPathType:
Events:
  Type    Reason            Age   From                  Message
  ----    ------            ----  ----                  -------
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-2dbg8
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-4x7ll
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-vpl9s
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-n8bkm
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-gslrf
  Normal  SuccessfulCreate  14s   daemonset-controller  Created pod: loki-logs-t48nd


$ k describe pod -n loki loki-logs-xtsvj
Name:                      loki-logs-xtsvj
Namespace:                 loki
Priority:                  0
Service Account:           loki-grafana-agent
Node:                      aks-core-14827334-vmss000001/10.101.22.12
Start Time:                Fri, 16 Jun 2023 04:39:08 +0000
Labels:                    app.kubernetes.io/instance=loki
                           app.kubernetes.io/managed-by=grafana-agent-operator
                           app.kubernetes.io/name=grafana-agent
                           app.kubernetes.io/version=v0.28.0
                           controller-revision-hash=58759b596b
                           grafana-agent=loki
                           operator.agent.grafana.com/name=loki
                           operator.agent.grafana.com/type=logs
                           pod-template-generation=1
Annotations:               cni.projectcalico.org/containerID: bb5a2579684b56e5ca375a47ce069f8d7a38c25d46cfd0fdaf62e16f3514dd9d
                           cni.projectcalico.org/podIP: 10.244.8.178/32
                           cni.projectcalico.org/podIPs: 10.244.8.178/32
                           kubectl.kubernetes.io/default-container: grafana-agent
Status:                    Terminating (lasts <invalid>)
Termination Grace Period:  4800s
IP:
IPs:                       <none>
Controlled By:             DaemonSet/loki-logs
Containers:
  config-reloader:
    Container ID:
    Image:         quay.io/prometheus-operator/prometheus-config-reloader:v0.47.0
    Image ID:
    Port:          <none>
    Host Port:     <none>
    Args:
      --config-file=/var/lib/grafana-agent/config-in/agent.yml
      --config-envsubst-file=/var/lib/grafana-agent/config/agent.yml
      --watch-interval=1m
      --statefulset-ordinal-from-envvar=POD_NAME
      --reload-url=http://127.0.0.1:8080/-/reload
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Environment:
      POD_NAME:  loki-logs-xtsvj (v1:metadata.name)
      HOSTNAME:   (v1:spec.nodeName)
      SHARD:     0
    Mounts:
      /var/lib/docker/containers from dockerlogs (ro)
      /var/lib/grafana-agent/config from config-out (rw)
      /var/lib/grafana-agent/config-in from config (ro)
      /var/lib/grafana-agent/data from data (rw)
      /var/lib/grafana-agent/secrets from secrets (ro)
      /var/log from varlog (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mnxkj (ro)
  grafana-agent:
    Container ID:
    Image:         grafana/agent:v0.28.0
    Image ID:
    Port:          8080/TCP
    Host Port:     0/TCP
    Args:
      -config.file=/var/lib/grafana-agent/config/agent.yml
      -config.expand-env=true
      -server.http.address=0.0.0.0:8080
      -enable-features=integrations-next
    State:          Waiting
      Reason:       ContainerCreating
    Ready:          False
    Restart Count:  0
    Readiness:      http-get http://:http-metrics/-/ready delay=0s timeout=3s period=5s #success=1 #failure=120
    Environment:
      POD_NAME:  loki-logs-xtsvj (v1:metadata.name)
      HOSTNAME:   (v1:spec.nodeName)
      SHARD:     0
    Mounts:
      /var/lib/docker/containers from dockerlogs (ro)
      /var/lib/grafana-agent/config from config-out (rw)
      /var/lib/grafana-agent/config-in from config (ro)
      /var/lib/grafana-agent/data from data (rw)
      /var/lib/grafana-agent/secrets from secrets (ro)
      /var/log from varlog (ro)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-mnxkj (ro)
Conditions:
  Type              Status
  Initialized       True
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  config:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  loki-logs-config
    Optional:    false
  config-out:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:
    SizeLimit:  <unset>
  secrets:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  loki-secrets
    Optional:    false
  varlog:
    Type:          HostPath (bare host directory volume)
    Path:          /var/log
    HostPathType:
  dockerlogs:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/docker/containers
    HostPathType:
  data:
    Type:          HostPath (bare host directory volume)
    Path:          /var/lib/grafana-agent/data
    HostPathType:
  kube-api-access-mnxkj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/disk-pressure:NoSchedule op=Exists
                             node.kubernetes.io/memory-pressure:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists
                             node.kubernetes.io/pid-pressure:NoSchedule op=Exists
                             node.kubernetes.io/unreachable:NoExecute op=Exists
                             node.kubernetes.io/unschedulable:NoSchedule op=Exists
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  75s   default-scheduler  Successfully assigned loki/loki-logs-xtsvj to aks-core-14827334-vmss000001
  Normal  Pulled     26s   kubelet            Container image "quay.io/prometheus-operator/prometheus-config-reloader:v0.47.0" already present on machine


k get secrets -n loki
NAME                         TYPE                 DATA   AGE
loki-az-sa-access-key        Opaque               2      10h
loki-config                  Opaque               1      10h
loki-logs-config             Opaque               1      10h
loki-secrets                 Opaque               0      10h
sh.helm.release.v1.loki.v1   helm.sh/release.v1   1      10h

$ k get configmap -n loki
NAME               DATA   AGE
kube-root-ca.crt   1      10h
loki               1      10h
loki-gateway       1      10h
loki-runtime       1      10h

$ k get secret -n loki loki-logs-config -n loki -o yaml
apiVersion: v1
data:
  agent.yml: bG9nczoKICAgIGNvbmZpZ3M6CiAgICAgICAgLSBjbGllbnRzOgogICAgICAgICAgICAtIGV4dGVybmFsX2xhYmVsczoKICAgICAgICAgICAgICAgIGNsdXN0ZXI6IGxva2kKICAgICAgICAgICAgICB1cmw6IGh0dHA6Ly9sb2tpLWdhdGV3YXkubG9raS5zdmMuY2x1c3Rlci5sb2NhbC9sb2tpL2FwaS92MS9wdXNoCiAgICAgICAgICBuYW1lOiBsb2tpL2xva2kKICAgICAgICAgIHNjcmFwZV9jb25maWdzOgogICAgICAgICAgICAtIGpvYl9uYW1lOiBwb2RMb2dzL2xva2kvbG9raQogICAgICAgICAgICAgIGt1YmVybmV0ZXNfc2RfY29uZmlnczoKICAgICAgICAgICAgICAgIC0gbmFtZXNwYWNlczoKICAgICAgICAgICAgICAgICAgICBuYW1lczoKICAgICAgICAgICAgICAgICAgICAgICAgLSBsb2tpCiAgICAgICAgICAgICAgICAgIHJvbGU6IHBvZAogICAgICAgICAgICAgIHBpcGVsaW5lX3N0YWdlczoKICAgICAgICAgICAgICAgIC0gY3JpOiB7fQogICAgICAgICAgICAgIHJlbGFiZWxfY29uZmlnczoKICAgICAgICAgICAgICAgIC0gc291cmNlX2xhYmVsczoKICAgICAgICAgICAgICAgICAgICAtIGpvYgogICAgICAgICAgICAgICAgICB0YXJnZXRfbGFiZWw6IF9fdG1wX3Byb21ldGhldXNfam9iX25hbWUKICAgICAgICAgICAgICAgIC0gYWN0aW9uOiBrZWVwCiAgICAgICAgICAgICAgICAgIHJlZ2V4OiBsb2tpCiAgICAgICAgICAgICAgICAgIHNvdXJjZV9sYWJlbHM6CiAgICAgICAgICAgICAgICAgICAgLSBfX21ldGFfa3ViZXJuZXRlc19wb2RfbGFiZWxfYXBwX2t1YmVybmV0ZXNfaW9faW5zdGFuY2UKICAgICAgICAgICAgICAgIC0gYWN0aW9uOiBrZWVwCiAgICAgICAgICAgICAgICAgIHJlZ2V4OiBsb2tpCiAgICAgICAgICAgICAgICAgIHNvdXJjZV9sYWJlbHM6CiAgICAgICAgICAgICAgICAgICAgLSBfX21ldGFfa3ViZXJuZXRlc19wb2RfbGFiZWxfYXBwX2t1YmVybmV0ZXNfaW9fbmFtZQogICAgICAgICAgICAgICAgLSBzb3VyY2VfbGFiZWxzOgogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfbmFtZXNwYWNlCiAgICAgICAgICAgICAgICAgIHRhcmdldF9sYWJlbDogbmFtZXNwYWNlCiAgICAgICAgICAgICAgICAtIHNvdXJjZV9sYWJlbHM6CiAgICAgICAgICAgICAgICAgICAgLSBfX21ldGFfa3ViZXJuZXRlc19zZXJ2aWNlX25hbWUKICAgICAgICAgICAgICAgICAgdGFyZ2V0X2xhYmVsOiBzZXJ2aWNlCiAgICAgICAgICAgICAgICAtIHNvdXJjZV9sYWJlbHM6CiAgICAgICAgICAgICAgICAgICAgLSBfX21ldGFfa3ViZXJuZXRlc19wb2RfbmFtZQogICAgICAgICAgICAgICAgICB0YXJnZXRfbGFiZWw6IHBvZAogICAgICAgICAgICAgICAgLSBzb3VyY2VfbGFiZWxzOgogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfcG9kX2NvbnRhaW5lcl9uYW1lCiAgICAgICAgICAgICAgICAgIHRhcmdldF9sYWJlbDogY29udGFpbmVyCiAgICAgICAgICAgICAgICAtIHJlcGxhY2VtZW50OiBsb2tpL2xva2kKICAgICAgICAgICAgICAgICAgdGFyZ2V0X2xhYmVsOiBqb2IKICAgICAgICAgICAgICAgIC0gcmVwbGFjZW1lbnQ6IC92YXIvbG9nL3BvZHMvKiQxLyoubG9nCiAgICAgICAgICAgICAgICAgIHNlcGFyYXRvcjogLwogICAgICAgICAgICAgICAgICBzb3VyY2VfbGFiZWxzOgogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfcG9kX3VpZAogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfcG9kX2NvbnRhaW5lcl9uYW1lCiAgICAgICAgICAgICAgICAgIHRhcmdldF9sYWJlbDogX19wYXRoX18KICAgICAgICAgICAgICAgIC0gYWN0aW9uOiByZXBsYWNlCiAgICAgICAgICAgICAgICAgIHNvdXJjZV9sYWJlbHM6CiAgICAgICAgICAgICAgICAgICAgLSBfX21ldGFfa3ViZXJuZXRlc19wb2Rfbm9kZV9uYW1lCiAgICAgICAgICAgICAgICAgIHRhcmdldF9sYWJlbDogX19ob3N0X18KICAgICAgICAgICAgICAgIC0gYWN0aW9uOiBsYWJlbG1hcAogICAgICAgICAgICAgICAgICByZWdleDogX19tZXRhX2t1YmVybmV0ZXNfcG9kX2xhYmVsXyguKykKICAgICAgICAgICAgICAgIC0gYWN0aW9uOiByZXBsYWNlCiAgICAgICAgICAgICAgICAgIHJlcGxhY2VtZW50OiAkMQogICAgICAgICAgICAgICAgICBzZXBhcmF0b3I6ICctJwogICAgICAgICAgICAgICAgICBzb3VyY2VfbGFiZWxzOgogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfcG9kX2xhYmVsX2FwcF9rdWJlcm5ldGVzX2lvX25hbWUKICAgICAgICAgICAgICAgICAgICAtIF9fbWV0YV9rdWJlcm5ldGVzX3BvZF9sYWJlbF9hcHBfa3ViZXJuZXRlc19pb19jb21wb25lbnQKICAgICAgICAgICAgICAgICAgdGFyZ2V0X2xhYmVsOiBfX3NlcnZpY2VfXwogICAgICAgICAgICAgICAgLSBhY3Rpb246IHJlcGxhY2UKICAgICAgICAgICAgICAgICAgcmVwbGFjZW1lbnQ6ICQxCiAgICAgICAgICAgICAgICAgIHNlcGFyYXRvcjogLwogICAgICAgICAgICAgICAgICBzb3VyY2VfbGFiZWxzOgogICAgICAgICAgICAgICAgICAgIC0gX19tZXRhX2t1YmVybmV0ZXNfbmFtZXNwYWNlCiAgICAgICAgICAgICAgICAgICAgLSBfX3NlcnZpY2VfXwogICAgICAgICAgICAgICAgICB0YXJnZXRfbGFiZWw6IGpvYgogICAgICAgICAgICAgICAgLSBhY3Rpb246IHJlcGxhY2UKICAgICAgICAgICAgICAgICAgc291cmNlX2xhYmVsczoKICAgICAgICAgICAgICAgICAgICAtIF9fbWV0YV9rdWJlcm5ldGVzX3BvZF9jb250YWluZXJfbmFtZQogICAgICAgICAgICAgICAgICB0YXJnZXRfbGFiZWw6IGNvbnRhaW5lcgogICAgICAgICAgICAgICAgLSBhY3Rpb246IHJlcGxhY2UKICAgICAgICAgICAgICAgICAgcmVwbGFjZW1lbnQ6IGxva2kKICAgICAgICAgICAgICAgICAgdGFyZ2V0X2xhYmVsOiBjbHVzdGVyCiAgICBwb3NpdGlvbnNfZGlyZWN0b3J5OiAvdmFyL2xpYi9ncmFmYW5hLWFnZW50L2RhdGEKc2VydmVyOiB7fQoK
kind: Secret
metadata:
  creationTimestamp: "2023-06-15T18:36:16Z"
  labels:
    app.kubernetes.io/managed-by: grafana-agent-operator
  name: loki-logs-config
  namespace: loki
  ownerReferences:
  - apiVersion: monitoring.grafana.com/v1alpha1
    blockOwnerDeletion: true
    kind: GrafanaAgent
    name: loki
    uid: f21a9b04-8a8b-487d-8ff7-4825aae94d62
  resourceVersion: "121319"
  uid: 7584d56f-3d40-41ce-93a5-9f6699face9e
type: Opaque

agent:.yaml
    logs:
        configs:
            - clients:
                - external_labels:
                    cluster: loki
                url: http://loki-gateway.loki.svc.cluster.local/loki/api/v1/push
            name: loki/loki
            scrape_configs:
                - job_name: podLogs/loki/loki
                kubernetes_sd_configs:
                    - namespaces:
                        names:
                            - loki
                    role: pod
                pipeline_stages:
                    - cri: {}
                relabel_configs:
                    - source_labels:
                        - job
                    target_label: __tmp_prometheus_job_name
                    - action: keep
                    regex: loki
                    source_labels:
                        - __meta_kubernetes_pod_label_app_kubernetes_io_instance
                    - action: keep
                    regex: loki
                    source_labels:
                        - __meta_kubernetes_pod_label_app_kubernetes_io_name
                    - source_labels:
                        - __meta_kubernetes_namespace
                    target_label: namespace
                    - source_labels:
                        - __meta_kubernetes_service_name
                    target_label: service
                    - source_labels:
                        - __meta_kubernetes_pod_name
                    target_label: pod
                    - source_labels:
                        - __meta_kubernetes_pod_container_name
                    target_label: container
                    - replacement: loki/loki
                    target_label: job
                    - replacement: /var/log/pods/*$1/*.log
                    separator: /
                    source_labels:
                        - __meta_kubernetes_pod_uid
                        - __meta_kubernetes_pod_container_name
                    target_label: __path__
                    - action: replace
                    source_labels:
                        - __meta_kubernetes_pod_node_name
                    target_label: __host__
                    - action: labelmap
                    regex: __meta_kubernetes_pod_label_(.+)
                    - action: replace
                    replacement: $1
                    separator: '-'
                    source_labels:
                        - __meta_kubernetes_pod_label_app_kubernetes_io_name
                        - __meta_kubernetes_pod_label_app_kubernetes_io_component
                    target_label: __service__
                    - action: replace
                    replacement: $1
                    separator: /
                    source_labels:
                        - __meta_kubernetes_namespace
                        - __service__
                    target_label: job
                    - action: replace
                    source_labels:
                        - __meta_kubernetes_pod_container_name
                    target_label: container
                    - action: replace
                    replacement: loki
                    target_label: cluster
        positions_directory: /var/lib/grafana-agent/data
    server: {}


```

