# Troubleshooting and known limitations

This topic provides guidance on how to debug issues related to working with services on Tanzu
Application Platform and workarounds for known limitations.

## <a id="stk-debug-dynamic-provisioning"></a> Debug `ClassClaim` and provisioner-based `ClusterInstanceClass`

This section provides guidance on how to debug issues related to usage of `ClassClaim`
and provisioner-based `ClusterInstanceClass`.
You will require `kubectl` access to the cluster. The general approach detailed here starts by inspecting
a `ClassClaim` and tracing the way back through the chain of resources that are created in order to
fulfill the `ClassClaim`.

### Step 1: Inspect the `ClassClaim`, `ClusterInstanceClass` and `CompositeResourceDefinition`

```console
$ kubectl describe classclaim claim-name -n namespace
```

* Check the status conditions for any useful information which can lead you to the cause of the issue
* Check `.spec.classRef.name`, and use the value to inspect the status of the `ClusterInstanceClass`, as follows:

```console
$ kubectl describe clusterinstanceclass class-name
```

* Check the status conditions for any useful information which can lead you to the cause of the issue
* Check that the `Ready` condition has status `"True"`
* Check `.spec.provisioner.crossplane`, and use the values to inspect the status of the `CompositeResourceDefinition`, as follows:

```console
$ kubectl describe xrd xrd-name
```

* Check the status conditions for any useful information which can lead you to the cause of the issue
* Check that the `Established` condition has status `"True"`
* Check events for any errors or warnings which can lead you to the cause of the issue
* If both the `ClusterInstanceClass` reports `Ready="True"` and the `CompositeResourceDefinition` reports `Established="True"`, then move on to the next step.

### Step 2: Inspect the Composite Resource, the Managed Resources and the underlying resources

```console
$ kubectl describe classclaim claim-name -n namespace
```

* Check `.status.provisionedResourceRef`, and use the values (`kind`, `apiVersion` and `name`) to inspect the status of the Composite Resource, as follows:

```console
$ kubectl describe <kind>.<api group> <name> # <api group> = apiVersion minus the `/<version>` part
```

* Check the status conditions for any useful information which can lead you to the cause of the issue
* Check that the `Synced` condition has status `"True"`, if it doesn't then there has been an issue creating the Managed Resources from which this Composite Resource is composed, in which case refer to `.spec.resourceRefs` in the output of the above command and for each:
  * Use the values (`kind`, `apiVersion` and `name`) to inspect the status of the Managed Resource
    * Check the status conditions for any useful information which can lead you to the cause of the issue
* Check events for any errors or warnings which can lead you to the cause of the issue
* If all Managed Resources appear healthy, move on to the next step.

### Step 3: Inspect the events log

```console
$ kubectl get events -A
```

* Check for any errors or warnings which can lead you to the cause of the issue
* If there are no errors or warnings printed, move on to the next step.

### Step 4: Inspect the `Secret`

```console
$ kubectl get classclaim claim-name -n namespace -o yaml
```

* Check `.status.resourceRef`, and use the values (`kind`, `apiVersion`, `name` and `namespace`) to inspect the claimed resource (likely a `Secret`), as follows:

```console
$ kubectl get secret <name> -n <namespace> -o yaml
```

* If the `Secret` is there and has data, then something else must be causing the issue.

### Step 5: Contact support

If you have run through the steps here and are still unable to determine the cause of the issue, then please reach out to VMware Support for further guidance and help to resolve the issue.

