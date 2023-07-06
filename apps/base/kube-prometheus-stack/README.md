# kube-prometheus-stack

## overview

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

Note: This chart was formerly named prometheus-operator chart, now renamed to more clearly reflect that it installs the kube-prometheus project stack, within which Prometheus Operator is only one component.

From: https://github.com/prometheus-operator/kube-prometheus

Components included in this package:

- The Prometheus Operator
- Highly available Prometheus
- Highly available Alertmanager
- Prometheus node-exporter
- Prometheus Adapter for Kubernetes Metrics APIs
- kube-state-metrics
- Grafana

This stack is meant for cluster monitoring, so it is pre-configured to collect metrics from all Kubernetes components. In addition to that it delivers a default set of dashboards and alerting rules. Many of the useful dashboards and alerts come from the kubernetes-mixin project, similar to this project it provides composable jsonnet as a library for users to customize to their needs.

## customise

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update

# To see all configurable options with detailed comments:
# https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/values.yaml
# or run
# helm show values prometheus-community/kube-prometheus-stack

$ helm search repo prometheus-community

NAME                                                    CHART VERSION   APP VERSION     DESCRIPTION                                       
prometheus-community/alertmanager                       0.30.1          v0.25.0         The Alertmanager handles alerts sent by client ...
prometheus-community/alertmanager-snmp-notifier         0.1.0           v1.4.0          The SNMP Notifier handles alerts coming from Pr...
prometheus-community/jiralert                           1.2.1           v1.3.0          A Helm chart for Kubernetes to install jiralert   
prometheus-community/kube-prometheus-stack              45.31.1         v0.65.1         kube-prometheus-stack collects Kubernetes manif...
prometheus-community/kube-state-metrics                 5.6.3           2.8.2           Install kube-state-metrics to generate and expo...
prometheus-community/prom-label-proxy                   0.2.0           v0.6.0          A proxy that enforces a given label in a given ...
prometheus-community/prometheus                         22.6.2          v2.44.0         Prometheus is a monitoring system and time seri...
prometheus-community/prometheus-adapter                 4.2.0           v0.10.0         A Helm chart for k8s prometheus adapter           
prometheus-community/prometheus-blackbox-exporter       7.8.0           0.23.0          Prometheus Blackbox Exporter                      
prometheus-community/prometheus-cloudwatch-expo...      0.25.0          0.15.3          A Helm chart for prometheus cloudwatch-exporter   
prometheus-community/prometheus-conntrack-stats...      0.5.5           v0.4.11         A Helm chart for conntrack-stats-exporter         
prometheus-community/prometheus-consul-exporter         1.0.0           0.4.0           A Helm chart for the Prometheus Consul Exporter   
prometheus-community/prometheus-couchdb-exporter        1.0.0           1.0             A Helm chart to export the metrics from couchdb...
prometheus-community/prometheus-druid-exporter          1.0.0           v0.11.0         Druid exporter to monitor druid metrics with Pr...
prometheus-community/prometheus-elasticsearch-e...      5.1.1           1.5.0           Elasticsearch stats exporter for Prometheus       
prometheus-community/prometheus-fastly-exporter         0.1.2           7.2.4           A Helm chart for the Prometheus Fastly Exporter   
prometheus-community/prometheus-json-exporter           0.7.0           v0.5.0          Install prometheus-json-exporter                  
prometheus-community/prometheus-kafka-exporter          2.1.0           v1.6.0          A Helm chart to export the metrics from Kafka i...
prometheus-community/prometheus-mongodb-exporter        3.1.3           0.31.0          A Prometheus exporter for MongoDB metrics         
prometheus-community/prometheus-mysql-exporter          1.14.0          v0.14.0         A Helm chart for prometheus mysql exporter with...
prometheus-community/prometheus-nats-exporter           2.12.0          0.11.0          A Helm chart for prometheus-nats-exporter         
prometheus-community/prometheus-nginx-exporter          0.1.1           0.11.0          A Helm chart for the Prometheus NGINX Exporter    
prometheus-community/prometheus-node-exporter           4.17.2          1.5.0           A Helm chart for prometheus node-exporter         
prometheus-community/prometheus-operator                9.3.2           0.38.1          DEPRECATED - This chart will be renamed. See ht...
prometheus-community/prometheus-operator-admiss...      0.4.0           0.65.1          Prometheus Operator Admission Webhook             
prometheus-community/prometheus-operator-crds           3.0.0           0.64.1          A Helm chart that collects custom resource defi...
prometheus-community/prometheus-pgbouncer-exporter      0.1.1           1.18.0          A Helm chart for prometheus pgbouncer-exporter    
prometheus-community/prometheus-pingdom-exporter        2.4.1           20190610-1      A Helm chart for Prometheus Pingdom Exporter      
prometheus-community/prometheus-pingmesh-exporter       0.1.0           v1.0.0          Prometheus Pingmesh Exporter                      
prometheus-community/prometheus-postgres-exporter       4.4.4           0.11.1          A Helm chart for prometheus postgres-exporter     
prometheus-community/prometheus-pushgateway             2.1.6           v1.5.1          A Helm chart for prometheus pushgateway           
prometheus-community/prometheus-rabbitmq-exporter       1.5.0           v0.29.0         Rabbitmq metrics exporter for prometheus          
prometheus-community/prometheus-redis-exporter          5.3.2           v1.44.0         Prometheus exporter for Redis metrics             
prometheus-community/prometheus-smartctl-exporter       0.4.3           v0.9.1          A Helm chart for Kubernetes                       
prometheus-community/prometheus-snmp-exporter           1.4.0           v0.21.0         Prometheus SNMP Exporter                          
prometheus-community/prometheus-stackdriver-exp...      4.3.0           0.13.0          Stackdriver exporter for Prometheus               
prometheus-community/prometheus-statsd-exporter         0.8.0           v0.22.8         A Helm chart for prometheus stats-exporter        
prometheus-community/prometheus-to-sd                   0.4.2           0.5.2           Scrape metrics stored in prometheus format and ...
```

