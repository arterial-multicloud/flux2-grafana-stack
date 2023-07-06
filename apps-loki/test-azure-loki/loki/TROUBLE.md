# problem

https://grafana.com/docs/agent/latest/operator/deploy-agent-operator-resources/

no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1" ensure CRDs are installed first

installed here: https://github.com/grafana/loki/blob/main/production/helm/loki/templates/monitoring/pod-logs.yaml

{{- if .Values.monitoring.selfMonitoring.enabled }}
{{- with .Values.monitoring.selfMonitoring.podLogs }}

```bash

$ k get hr -A
NAMESPACE                  NAME                       AGE     READY   STATUS
aad-pod-identity           aad-pod-identity           3h32m   True    Release reconciliation succeeded
cert-manager               cert-manager               3h32m   True    Release reconciliation succeeded
flux-system                weave-gitops               3h30m   True    Release reconciliation succeeded
grafana-agent-flow         grafana-agent-flow         3h25m   True    Release reconciliation succeeded
grafana-agent-static-k8s   grafana-agent-static-k8s   3h25m   True    Release reconciliation succeeded
grafana                    grafana                    3h25m   True    Release reconciliation succeeded
ingress-nginx              ingress-nginx              3h30m   True    Release reconciliation succeeded
loki                       loki                       3h25m   False   Helm install failed: unable to build kubernetes objects from release manifest: resource mapping not found for name: "loki" namespace: "" from "": no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1"...
mimir                      mimir                      3h25m   True    Release reconciliation succeeded
prometheus                 kube-prometheus-stack      3h25m   True    Release reconciliation succeeded
promtail                   promtail                   3h25m   True    Release reconciliation succeeded
tempo-vulture              tempo                      3h25m   True    Release reconciliation succeeded
tempo                      tempo                      3h25m   True    Release reconciliation succeede



$ kubectl describe hr loki -n loki
Name:         loki
Namespace:    loki
Labels:       kustomize.toolkit.fluxcd.io/name=apps
              kustomize.toolkit.fluxcd.io/namespace=flux-system
Annotations:  <none>
API Version:  helm.toolkit.fluxcd.io/v2beta1
Kind:         HelmRelease
Metadata:
  Creation Timestamp:  2023-06-11T10:46:16Z
  Finalizers:
    finalizers.fluxcd.io
  Generation:        15
  Resource Version:  101181
  UID:               e9deee75-a0ae-4dee-bb3d-1152bb2b7784
Spec:
  Chart:
    Spec:
      Chart:               loki
      Reconcile Strategy:  ChartVersion
      Source Ref:
        Kind:       HelmRepository
        Name:       grafana-charts
        Namespace:  grafana-charts
      Version:      5.6.4
......
Status:
  Conditions:
    Last Transition Time:  2023-06-11T14:09:48Z
    Message:               Helm install failed: unable to build kubernetes objects from release manifest: resource mapping not found for name: "loki" namespace: "" from "": no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1"
ensure CRDs are installed first
    Reason:                InstallFailed
    Status:                False
    Type:                  Ready
    Last Transition Time:  2023-06-11T14:09:48Z
    Message:               Helm install failed: unable to build kubernetes objects from release manifest: resource mapping not found for name: "loki" namespace: "" from "": no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1"
ensure CRDs are installed first

Last Helm logs:

CRD grafanaagents.monitoring.grafana.com is already present. Skipping.
CRD integrations.monitoring.grafana.com is already present. Skipping.
CRD logsinstances.monitoring.grafana.com is already present. Skipping.
CRD metricsinstances.monitoring.grafana.com is already present. Skipping.
CRD podlogs.monitoring.grafana.com is already present. Skipping.
    Reason:                        InstallFailed
    Status:                        False
    Type:                          Released
  Failures:                        2
  Helm Chart:                      grafana-charts/loki-loki
  Install Failures:                2
  Last Attempted Revision:         5.6.4
  Last Attempted Values Checksum:  7004d000dccbf5dc4ed7c5164d025e48ce390abe
  Observed Generation:             15
Events:
  Type     Reason  Age                  From             Message
  ----     ------  ----                 ----             -------
  Warning  error   21m (x10 over 135m)  helm-controller  reconciliation failed: Helm install failed: unable to build kubernetes objects from release manifest: resource mapping not found for name: "loki" namespace: "" from "": no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1"
ensure CRDs are installed first
  Normal   info   5m20s (x23 over 3h39m)  helm-controller  Helm install has started
  Warning  error  5m16s (x13 over 135m)   helm-controller  Helm install failed: unable to build kubernetes objects from release manifest: resource mapping not found for name: "loki" namespace: "" from "": no matches for kind "PodLogs" in version "monitoring.grafana.com/v1alpha1"
ensure CRDs are installed first

Last Helm logs:

CRD grafanaagents.monitoring.grafana.com is already present. Skipping.
CRD integrations.monitoring.grafana.com is already present. Skipping.
CRD logsinstances.monitoring.grafana.com is already present. Skipping.
CRD metricsinstances.monitoring.grafana.com is already present. Skipping.
CRD podlogs.monitoring.grafana.com is already present. Skipping.




$ k api-versions  | grep monitoring
monitoring.grafana.com/v1alpha1
monitoring.grafana.com/v1alpha2

$ k get crd | grep monitoring.grafana.com

grafanaagents.monitoring.grafana.com                        2023-06-11T10:46:22Z
integrations.monitoring.grafana.com                         2023-06-11T10:46:22Z
logsinstances.monitoring.grafana.com                        2023-06-11T10:46:22Z
metricsinstances.monitoring.grafana.com                     2023-06-11T10:46:23Z
podlogs.monitoring.grafana.com                              2023-06-11T10:46:20Z


$ k describe crd podlogs.monitoring.grafana.com

$ k get crd | grep monitoring.grafana.com | awk '{print $1}' | while read CRD
do
echo
k describe crd $CRD | egrep "^Name: |helm.toolkit|Creation Timestamp|Name:  v1" | egrep -v apiextension | awk '{print $NF}' | sort 
echo
done

2023-06-11T10:46:22Z
grafanaagents.monitoring.grafana.com
helm.toolkit.fluxcd.io/name=grafana-agent-static-k8s
helm.toolkit.fluxcd.io/namespace=grafana-agent-static-k8s
v1alpha1


2023-06-11T10:46:22Z
helm.toolkit.fluxcd.io/name=grafana-agent-static-k8s
helm.toolkit.fluxcd.io/namespace=grafana-agent-static-k8s
integrations.monitoring.grafana.com
v1alpha1


2023-06-11T10:46:22Z
helm.toolkit.fluxcd.io/name=grafana-agent-static-k8s
helm.toolkit.fluxcd.io/namespace=grafana-agent-static-k8s
logsinstances.monitoring.grafana.com
v1alpha1


2023-06-11T10:46:23Z
helm.toolkit.fluxcd.io/name=grafana-agent-static-k8s
helm.toolkit.fluxcd.io/namespace=grafana-agent-static-k8s
metricsinstances.monitoring.grafana.com
v1alpha1


2023-06-11T10:46:20Z
helm.toolkit.fluxcd.io/name=grafana-agent-flow
helm.toolkit.fluxcd.io/namespace=grafana-agent-flow
podlogs.monitoring.grafana.com
v1alpha2


$ k get crd | grep monitoring.grafana.com | awk '{print $1}' | while read CRD
do
echo
echo $CRD:
k get $CRD -A
echo
done

grafanaagents.monitoring.grafana.com:
No resources found

integrations.monitoring.grafana.com:
No resources found

logsinstances.monitoring.grafana.com:
No resources found

metricsinstances.monitoring.grafana.com:
No resources found

podlogs.monitoring.grafana.com:
No resources found

```

Saved config

```yaml
    monitoring:
      dashboards: 
        enabled: true
      rules: 
        enabled: true
        alerting: false
      serviceMonitor:
        enabled: true
        metricsInstance:
          enabled: false
          annotations: {}
          labels: {}
          remoteWrite: http://mimir-nginx.mimir.svc.cluster.local/api/v1/push
      selfMonitoring:
        enabled: true
        podLogs:
          annotations: {}
          labels: {}
          relabelings: {}
      lokiCanary:
        enabled: true
        # nodeSelector:
          # node_workload_type: apps

```

Also occuring with the grafana agent static k8s

```bash
$ k logs grafana-agent-static-k8s-grafana-agent-operator-7cb7448cbddhbll -n grafana-agent-static-k8s
level=info ts=2023-06-11T14:18:44.862307494Z component=controller-runtime.metrics msg="Metrics server is starting to listen" addr=:8080
level=info ts=2023-06-11T14:18:44.862843903Z msg="starting manager"
level=info ts=2023-06-11T14:18:44.862998605Z path=/metrics kind=metrics addr=[::]:8080 msg="Starting server"
level=info ts=2023-06-11T14:18:44.863162208Z controller=node controllerGroup= controllerKind=Node msg="Starting EventSource" source="kind source: *v1.Node"
level=info ts=2023-06-11T14:18:44.863182108Z controller=node controllerGroup= controllerKind=Node msg="Starting EventSource" source="kind source: *v1.Service"
level=info ts=2023-06-11T14:18:44.863194208Z controller=node controllerGroup= controllerKind=Node msg="Starting EventSource" source="kind source: *v1.Endpoints"
level=info ts=2023-06-11T14:18:44.863206309Z controller=node controllerGroup= controllerKind=Node msg="Starting Controller"
level=info ts=2023-06-11T14:18:44.863412012Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1alpha1.GrafanaAgent"
level=info ts=2023-06-11T14:18:44.863610515Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.StatefulSet"
level=info ts=2023-06-11T14:18:44.863812718Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.DaemonSet"
level=info ts=2023-06-11T14:18:44.864012522Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Deployment"
level=info ts=2023-06-11T14:18:44.864230425Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Secret"
level=info ts=2023-06-11T14:18:44.864402928Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Service"
level=info ts=2023-06-11T14:18:44.864587031Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Secret"
level=info ts=2023-06-11T14:18:44.864799734Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1alpha1.LogsInstance"
level=info ts=2023-06-11T14:18:44.864916736Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1alpha1.PodLogs"
level=info ts=2023-06-11T14:18:44.86513714Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1alpha1.MetricsInstance"
level=info ts=2023-06-11T14:18:44.865426844Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1alpha1.Integration"
level=info ts=2023-06-11T14:18:44.865613647Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.PodMonitor"
level=info ts=2023-06-11T14:18:44.865822951Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Probe"
level=info ts=2023-06-11T14:18:44.865978653Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.ServiceMonitor"
level=info ts=2023-06-11T14:18:44.866172756Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.Secret"
level=info ts=2023-06-11T14:18:44.86637826Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting EventSource" source="kind source: *v1.ConfigMap"
level=info ts=2023-06-11T14:18:44.866450861Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Starting Controller"
level=error ts=2023-06-11T14:18:47.362950269Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=info ts=2023-06-11T14:18:47.363247973Z controller=node controllerGroup= controllerKind=Node msg="Starting workers" workercount=1
level=info ts=2023-06-11T14:18:47.363365575Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-core-15635809-vmss000000 reconcileID=871bd136-d9bb-458a-adff-00ac89ce0417 msg="reconciling node"
level=info ts=2023-06-11T14:18:47.389215893Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-apps-22237468-vmss000001 reconcileID=b1b6b544-31c5-4b7a-9eb1-a77e270a8065 msg="reconciling node"
level=info ts=2023-06-11T14:18:47.405864262Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-apps-22237468-vmss000002 reconcileID=0d0f14ac-2ce9-47b8-8ed1-79c0f30cf95e msg="reconciling node"
level=info ts=2023-06-11T14:18:47.423507646Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-default-29793384-vmss000000 reconcileID=9146ca51-7ac1-4712-8cc7-a3af8d24202f msg="reconciling node"
level=info ts=2023-06-11T14:18:47.439587206Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-apps-22237468-vmss000000 reconcileID=0785ac77-88de-46a1-b37b-4ee161452841 msg="reconciling node"
level=error ts=2023-06-11T14:18:58.368895285Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:19:08.368493654Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=info ts=2023-06-11T14:19:17.408139451Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-core-15635809-vmss000000 reconcileID=fb0b2261-c385-4347-9a16-5ada853a64dc msg="reconciling node"
level=error ts=2023-06-11T14:19:18.369637993Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=info ts=2023-06-11T14:19:21.46981406Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-apps-22237468-vmss000001 reconcileID=24315abe-b9f7-4a3b-8279-d929b35e9e43 msg="reconciling node"
level=error ts=2023-06-11T14:19:28.368001973Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:19:38.369491798Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:19:48.369856144Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:19:58.367979318Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=info ts=2023-06-11T14:20:02.184160829Z controller=node controllerGroup= controllerKind=Node Node="unsupported value type" namespace= name=aks-default-29793384-vmss000000 reconcileID=89ea8e4f-dc34-47d0-97b7-7e7d419b539b msg="reconciling node"
level=error ts=2023-06-11T14:20:08.369034991Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:20:18.369132948Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:20:28.368473295Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:20:38.369545821Z component=controller-runtime.source msg="if kind is a CRD, it should be installed before calling Start" err="no matches for kind \"PodLogs\" in version \"monitoring.grafana.com/v1alpha1\"" kind=PodLogs.monitoring.grafana.com
level=error ts=2023-06-11T14:20:47.464874291Z controller=grafanaagent controllerGroup=monitoring.grafana.com controllerKind=GrafanaAgent msg="Could not wait for Cache to sync" err="failed to wait for grafanaagent caches to sync: timed out waiting for cache to be synced"
level=info ts=2023-06-11T14:20:47.464981493Z msg="Stopping and waiting for non leader election runnables"
level=info ts=2023-06-11T14:20:47.465515701Z msg="Stopping and waiting for leader election runnables"
level=info ts=2023-06-11T14:20:47.465692903Z controller=node controllerGroup= controllerKind=Node msg="Shutdown signal received, waiting for all workers to finish"
level=info ts=2023-06-11T14:20:47.465734504Z controller=node controllerGroup= controllerKind=Node msg="All workers finished"
level=info ts=2023-06-11T14:20:47.465776605Z msg="Stopping and waiting for caches"
level=info ts=2023-06-11T14:20:47.466168511Z msg="Stopping and waiting for webhooks"
level=info ts=2023-06-11T14:20:47.466205411Z msg="Wait completed, proceeding to shutdown the manager"
level=error ts=2023-06-11T14:20:47.466219011Z msg="problem running manager" err="failed to wait for grafanaagent caches to sync: timed out waiting for cache to be synced"
```