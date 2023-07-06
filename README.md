# flux2-grafana-stack

## Architecture

Flux2 cluster management for Grafana stack (Mimir, Loki, Tempo)

### Metrics

- Mimir remoteWrite metrics to itself
- Loki remoteWrite metrics to Mimir
- Grafana Agent Flow remoteWrite Metrics to Mimir
- Grafana Agent Flow scrapes
  - Tempo
  - Kube-prometheus-stack
  - Cert-manager
- Kube-prometheus-stack scrapes local k8s metrics
  - Kube-prometheus-stack is required for the kubernetes dashboards to function
  - The dashboards are not written to be multi-cluster aware you must select the cluster datasource that you want to review

### Logging

- Promtail scrapes pod logs and fowards to Loki

### Tracing

- Grafana forwards traces to tempo

## TODO

- Move hardcoded config to env vars
- TLS / letsencrypt
- Auth / azuread
- Grafana high availability with Postgres
- Cannot deploy loki alongside mimir (loki-logs issue, see [TROUBLE.md](TROUBLE.md))

## Local validation

### Pre reqs

Install yq

```bash
sudo add-apt-repository ppa:rmescandon/yq
sudo apt install yq
```

Install kubeconform from [lastest version](https://github.com/yannh/kubeconform/releases)

```bash
wget https://github.com/yannh/kubeconform/releases/download/v0.6.1/kubeconform-linux-amd64.tar.gz
tar xzf kubeconform-linux-amd64.tar.gz
rm kubeconform-linux-amd64.tar.gz
sudo mv kubeconform /usr/local/bin
```

Install kustomize

```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
sudo mv kustomize /usr/local/bin
```

### Run validate

```bash
bash scripts/validate.sh
```

## Secrets

Download the SOPS stable client (v3.7.3 at time of writing) here [https://github.com/mozilla/sops/releases](https://github.com/mozilla/sops/releases)

```bash
wget https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux.amd64 -O sops

chmod 755 sops
sudo mv sops /usr/local/bin
```

For each cluster, encrypt the secrets using steps similar to the following:

```bash
CLUSTER=staging

####################################################
# SECTION A: only if the file doesnt exist:
#
cp scripts/sops_env.sh ~/.secrets/env_${CLUSTER}.sh
#
# edit the file to set your variables
vi ~/.secrets/env_${CLUSTER}.sh
#
# set your environment
. ~/.secrets/env_${CLUSTER}.sh
#
####################################################
# SECTION B: generate the secrets
bash ./scripts/sops_encrypt_${CLUSTER}.sh

# confirm the secrets were created and encrypted
find ./apps/${CLUSTER} -name '*-secret.yaml'
```

## Useful links

- [grafana](https://github.com/grafana/helm-charts/tree/main/charts/grafana)
- [loki](https://github.com/grafana/loki/tree/main/production/helm/loki)
- [promtail](https://github.com/grafana/helm-charts/tree/main/charts/promtail)
- [tempo](https://github.com/grafana/helm-charts/blob/main/charts/tempo/README.md)
- [flux workload identity discussion](https://github.com/fluxcd/flux2/discussions/3917)
- [SOPS](https://fluxcd.io/flux/guides/mozilla-sops/#azure)

## Troubleshooting cheatsheet

[https://fluxcd.io/flux/cheatsheets/troubleshooting/](https://fluxcd.io/flux/cheatsheets/troubleshooting/)

```bash
# whats not ready
flux get all -A --status-selector ready=false

# Flux CLI (check for Ready=True and Suspend=False)
flux get sources all -A

# kubectl (check for Ready=True)
kubectl get gitrepositories.source.toolkit.fluxcd.io -A
kubectl get helmrepositories.source.toolkit.fluxcd.io -A

# Flux CLI (check for Ready=True and Suspend=False)
flux get kustomizations -A
flux get helmreleases -A

# kubectl (check for Ready=True)
kubectl get kustomizations.kustomize.toolkit.fluxcd.io -A
kubectl get helmreleases.helm.toolkit.fluxcd.io -A
kubectl get helmcharts.source.toolkit.fluxcd.io -A

# Looking for controller errors:
flux logs --all-namespaces --level=error
flux check


kubectl describe helmrelease loki -n loki
```
