# How to observe the Runs of your Workload

{{> 'partials/supply-chain/beta-banner' }} 

[Workloads] and their [Runs] can be observed using the Tanzu `workload` CLI plugin.

## List Workloads

Lists all [Workloads]:

```console
$ tanzu workload list --namespace build
Listing workloads from the build namespace

  NAME        KIND                     VERSION  AGE
  my-web-app  buildwebapps.vmware.com  v1       6m54s
```

## Get a Workload

Get the details of the specified [Workload] within a namespace:

```console
$ tanzu workload get my-web-app --namespace build
Overview
   name:       my-web-app
   kind:       buildwebapps.vmware.com/my-web-app
   namespace:  build
   age:        17s

Runs:
  ID                    STATUS   DURATION  AGE
  my-web-app-run-lxwrm  Running  0s        17s
```

You can also get the [Workload] output as YAML or JSON for programmatic use:

```console
$ tanzu workload get my-web-app --namespace build -o yaml
---
apiVersion: vmware.com/v1
kind: BuildWebApp
metadata:
  name: my-web-app
  namespace: build
spec:
  ...
```

[Workload]: ../explanation/workloads.hbs.md
[Workloads]: ../explanation/workloads.hbs.md
[Runs]: ../explanation/workload-runs.hbs.md
