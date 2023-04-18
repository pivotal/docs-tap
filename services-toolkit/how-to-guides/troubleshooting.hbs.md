# Troubleshoot Services Toolkit

This topic provides guidance on how to troubleshoot issues related to working with services on Tanzu
Application Platform. For workarounds for known limitations, see [Known limitations](../reference/known-limitations.hbs.md).

## <a id="prereq"></a> Prerequisites

To follow the steps in this topic, you require kubectl access to the cluster.

## <a id="debug-dynamic-provisioning"></a> Debug `ClassClaim` and provisioner-based `ClusterInstanceClass`

This section provides guidance on how to debug issues related to using `ClassClaim`
and provisioner-based `ClusterInstanceClass`.
The general approach detailed in this topic starts by inspecting
a `ClassClaim` and tracing back through the chain of resources that are created when
fulfilling the `ClassClaim`.

### <a id="inspect-class-claim"></a> Step 1: Inspect the `ClassClaim`, `ClusterInstanceClass` and `CompositeResourceDefinition`

1. Inspect the status of `ClassClaim` by running:

   ```console
   kubectl describe classclaim claim-name -n NAMESPACE
   ```

   Where `NAMESPACE` is your namespace.

   From the output, check the following:

   - Check the status conditions for any useful information that can lead you to the cause of the issue.
   - Check `.spec.classRef.name` and record the value.

1. Inspect the status of the `ClusterInstanceClass` by running:

   ```console
   kubectl describe clusterinstanceclass CLASS-NAME
   ```

   Where `CLASS-NAME` is the value of `.spec.classRef.name` you retrieved in the previous step.

   From the output, check the following:

   - Check the status conditions for any useful information that can lead you to the cause of the issue.
   - Check that the `Ready` condition has status `"True"`.
   - Check `.spec.provisioner.crossplane` and record the value.

1. Inspect the status of the `CompositeResourceDefinition`, as follows:

   ```console
   kubectl describe xrd XRD-NAME
   ```

   Where `XRD-NAME` is the value of `.spec.provisioner.crossplane` you retrieved in the previous step.

   From the output, check the following:

   - Check the status conditions for any useful information that can lead you to the cause of the issue.
   - Check that the `Established` condition has status `"True"`.
   - Check events for any errors or warnings that can lead you to the cause of the issue.
   - If both the `ClusterInstanceClass` reports `Ready="True"` and the `CompositeResourceDefinition`
     reports `Established="True"`, move on to the next section.

### <a id="inspect-comp-resource"></a> Step 2: Inspect the Composite Resource, the Managed Resources and the underlying resources

1. Check `.status.provisionedResourceRef` by running:

   ```console
   kubectl describe classclaim claim-name -n NAMESPACE
   ```

   Where `NAMESPACE` is your namespace.

   From the output, check the following:

   - Check `.status.provisionedResourceRef`, and record the values of `kind`, `apiVersion`, and `name`.

1. Inspect the status of the Composite Resource by running:

   ```console
   kubectl describe KIND.API-GROUP NAME
   ```

   Where:

   - `KIND` is the value of `kind` you retrieved in the previous step.
   - `API-GROUP` is the value of `apiVersion` you retrieved in the previous step without the `/<version>` part.
   - `NAME` is the value of `name` you retrieved in the previous step.

   From the output, check the following:

   - Check the status conditions for any useful information that can lead you to the cause of the issue.
   - Check that the `Synced` condition has status `"True"`, if it doesn't then there was an issue creating
   the Managed Resources from which this Composite Resource is composed. Refer to `.spec.resourceRefs`
   in the output and for each:
     - Use the values of `kind`, `apiVersion` and `name` to inspect the status of the Managed Resource.
     - Check the status conditions for any useful information which can lead you to the cause of the issue.
   - Check events for any errors or warnings that can lead you to the cause of the issue.
   - If all Managed Resources appear healthy, move on to the next section.

### <a id="inspect-log"></a> Step 3: Inspect the events log

Inspect the events log by running:

```console
kubectl get events -A
```

From the output, check the following:

- Check for any errors or warnings that can lead you to the cause of the issue.
- If there are no errors or warnings, move on to the next section.

### <a id="inspect-secret"></a> Step 4: Inspect the secret

1. Check `.status.resourceRef` by running:

   ```console
   kubectl get classclaim claim-name -n NAMESPACE -o yaml
   ```

   Where `NAMESPACE` is your namespace.

   From the output, check the following:

   - Check `.status.resourceRef` and record the values `kind`, `apiVersion`, `name`, and `namespace`

1. Inspect the claimed resource, which is likely a secret, by running:

   ```console
   kubectl get secret NAME -n NAMESPACE -o yaml
   ```

   Where:

   - `NAME` is the `name` you retrieved in the previous step.
   - `NAMESPACE` is the `namespace` you retrieved in the previous step.

   If the secret is there and has data, then something else must be causing the issue.

### <a id="contact-support"></a> Step 5: Contact support

If you have followed the steps in this topic and are still unable to discover the cause of the issue,
contact VMware Support for further guidance and help to resolve the issue.
