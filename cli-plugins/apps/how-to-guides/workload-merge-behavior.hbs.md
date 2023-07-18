# Control Workload Merge Behavior

This topic tells you how to manage control the workload update behavior with the
`--update-strategy` flag.

When updating a workload from a file, manage the workload update behavior with the `--update-strategy` flag. There are two possible values: `merge` or `replace`.
The default value is `merge`.

## `merge`

If the `--file workload.yaml` deletes an existing on-cluster property or value, it is not
removed from the on-cluster definition.
If the `--file workload.yaml` includes a new property or value, it is added to the on-cluster workload
property value.
If the `--file workload.yaml` updates an existing value for a property, it is updated on the on-cluster definition.

## `replace`

The on-cluster workload is updated to exactly what is specified in the `--file workload.yaml` definition.

The current default merge strategy intents to prevent unintentional deletions of critical
properties from existing workloads.

>**Note** The default value for the `--update-strategy flag` will change from merge to replace
> in Tanzu Application Platform v1.7.0.

Examples of the outcomes of both the `merge` and `replace` values are provided in the
following examples:

- ```console
  # Export workload if there is no previous yaml definition
  tanzu apps workload get spring-petclinic --export > spring-petclinic.yaml

  # modify the workload definition
  vi rmq-sample-app.yaml
  ---
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    name: spring-petclinic
    labels:
      app.kubernetes.io/part-of: spring-petclinic
      apps.tanzu.vmware.com/workload-type: web
  spec:
    resources:
      requests:
        memory: 1Gi
      limits:           # delete this line
        memory: 1Gi     # delete this line
        cpu: 500m       # delete this line
    source:
      git:
        url: https://github.com/sample-accelerators/spring-petclinic
        ref:
          tag: tap-1.1
  ```

After saving the file, to verify how both of the update strategy options behave, run:

```console
tanzu apps workload apply -f ./spring-petclinic.yaml --update-strategy merge # if flag is not specified, merge is taken as default
```

This produces the following output:

```console
❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files
will replace rather than merge existing configuration. The change will take place in the January 2024
Tanzu Application Platform release (use "--update-strategy" to control strategy explicitly).

Workload is unchanged, skipping update
```

By contrast, use `replace` as follows:

```console
tanzu apps workload apply -f ./spring-petclinic.yaml --update-strategy replace
```

This produces the following output:

```console
❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files
will replace rather than merge existing configuration. The change will take place in the January 2024
Tanzu Application Platform release (use "--update-strategy" to control strategy explicitly).

🔎 Update workload:
...
  8,  8   |  name: spring-petclinic
  9,  9   |  namespace: default
 10, 10   |spec:
 11, 11   |  resources:
 12     - |    limits:
 13     - |      cpu: 500m
 14     - |      memory: 1Gi
 15, 12   |    requests:
 16, 13   |      memory: 1Gi
 17, 14   |  source:
 18, 15   |    git:
...
❓ Really update the workload "spring-petclinic"? [yN]:
```

The lines that were deleted in the `yaml` file are deleted as well in the workload running in the
cluster. The only text boxes that remain exactly as they were created are the system populated
metadata text boxes; `resourceVersion`, `uuid`, `generation`, `creationTimestamp`, and
`deletionTimestamp`.
