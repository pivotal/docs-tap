# Troubleshooting and known limitations

This document provides guidance on how to debug issues related to working with services on Tanzu
Application Platform and workarounds for known limitations.

## <a id="stk-debug-dynamic-provisioning"></a> Debug `ClassClaim` and provisioner-based `ClusterInstanceClass`

This section of the document provides guidance on how to debug issues related to usage of `ClassClaim` and provisioner-based `ClusterInstanceClass`. You will require `kubectl` access to the cluster. The general approach detailed here starts by inspecting a `ClassClaim` and tracing the way back through the chain of resources that are created in order to fulfill the `ClassClaim`.

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

## Troubleshooting known limitations

### <a id="stk-known-limitation-multi-workloads"></a> Cannot claim and bind to the same service instance from across multiple namespaces

**Description**

It is not currently possible for two or more workloads residing in two or more distinct namespaces to claim and bind to the same service instance. This is due to the mutually exclusive nature of claims - once a claim has successfully claimed a service instance, no other claim can then claim that same service instance. This limitation does not exist for two or more workloads residing in the same namespace, as in this case the workloads can all still all bind to the one claim. This is not currently possible across the namespace divide. We are planning to remove this limitation in the future.

### Unexpected error if `"additionalProperties": true` is set in a CompositeResourceDefinition

**Description**

When creating a `CompositeResourceDefinition`, if you set `additionalProperties: true` in the `openAPIV3Schema` section, then an error will be encountered during the validation step of the creation of any `ClassClaim` which referrs to a class which referrs to the `CompositeResourceDefinitions`.

**Error**

`json: cannot unmarshal bool into Go struct field JSONSchemaProps.AdditionalProperties of type apiextensions.JSONSchemaPropsOrBool`

**Workaround**

Rather than setting `additionalProperties: true`, you can set `additionalProperties: {}` instead, which will have the same effect but will not result in unexpected errors.

### <a id="stk-known-limitation-too-many-crds"></a> Cluster performance degradation due to large number of CRDs

**Description**

While not strictly a limitation with Services Toolkit per se, care should be taken before choosing to install additional Crossplane `Providers` into Tanzu Application Platform. Some of these `Providers` install multiple hundreds of additional CRDs into the cluster. This is particularly true of the `Providers` for the three big clouds - AWS, Azure and GCP. At the time of writing `provider-aws` installs [894](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/crds), `provider-azure` installs [705 CRDs](https://marketplace.upbound.io/providers/upbound/provider-azure/latest/crds) and `provider-gcp` installs [329 CRDs](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest/crds). You must ensure your cluster has sufficient resource to support this number of additional CRDs if choosing to install them.

### Private registry or VMware Application Catalog (VAC) configuration does not seem to take effect

**Description**

As of Tanzu Application Platform v1.5.0 there is a known issue that occurs if you try to
[configure private registry integration for the Bitnami services](../../bitnami-services/how-to-guides/configure-private-reg-integration.hbs.md)
after having already created a claim for one or more of the Bitnami services using the default configuration.
The issue is that the updated private registry configuration does not appear to take effect.
This is due to caching behavior in the system which is not currently accounted for during configuration
updates.

**Workaround**

Delete the `provider-helm-*` pods in the `crossplane-system` namespace and wait for new pods to come
back online after having applied the updated registry configuration.
