# Troubleshoot Tanzu Build Service

This topic tells you how to troubleshoot Tanzu Build Service when used with
Tanzu Application Platform (commonly known as TAP).

## <a id="eks-1-23-volume"></a> Builds fail due to volume errors on EKS running Kubernetes v1.23

### Symptom

After installing Tanzu Application Platform on or upgrading an existing
Amazon Elastic Kubernetes Service (EKS) cluster to Kubernetes v1.23, build pods show:

```console
'running PreBind plugin "VolumeBinding": binding volumes: timed out waiting
 for the condition'
```

### Cause

This is due to the CSIMigrationAWS in this Kubernetes version, which requires users
to install the Amazon EBS CSI driver
to use AWS Elastic Block Store (EBS) volumes. See the [Amazon documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html).
For more information about EKS support for Kubernetes v1.23, see the
[Amazon blog post](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/).

Tanzu Application Platform uses the default storage class which uses EBS volumes by default on EKS.

### Solution

Follow the AWS documentation to install the [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
before installing Tanzu Application Platform, or before upgrading to Kubernetes v1.23. See

---

## <a id="smart-warmer-image-fetcher"></a> Smart-warmer-image-fetcher reports ErrImagePull due to dockerd's layer depth limitation

### Symptom

When using dockerd as the cluster's container runtime, you might see the `smart-warmer-image-fetcher` pods
report a status of `ErrImagePull`.

### Cause

This error might be due to dockerd's layer depth limitation, in which the maximum
supported image layer depth is 125.

To verify that the `ErrImagePull` status is due to dockerd's maximum supported image layer depth,
check for event messages containing the words `max depth exceeded`. For example:

```console
$ kubectl get events -A | grep "max depth exceeded"
  build-service        73s         Warning     Failed         pod/smart-warmer-image-fetcher-wxtr8     Failed to pull image
  "harbor.somewhere.com/aws-repo/build-service:clusterbuilder-full@sha256:065bb361fd914a3970ad3dd93c603241e69cca214707feaa6
  d8617019e20b65e":  rpc error: code = Unknown desc = failed to register layer: max depth exceeded
```

### Solution

To work around this issue, configure your cluster to use containerd or CRI-O as its default container runtime.
For instructions, see the following documentation for your Kubernetes cluster provider.

For AWS, see:

- The [Amazon blog](https://docs.aws.amazon.com/eks/latest/userguide/dockershim-deprecation.html)
- The [eksctl CLI documentation](https://eksctl.io/usage/container-runtime/)

For AKS, see:

- The [Microsoft Azure documentation](https://docs.microsoft.com/en-us/azure/aks/cluster-configuration#container-runtime-configuration)
- The [Microsoft Azure blog](https://techcommunity.microsoft.com/t5/apps-on-azure-blog/dockershim-deprecation-and-aks/ba-p/3055902)

For GKE, see:

- The [GKE documentation](https://cloud.google.com/kubernetes-engine/docs/concepts/using-containerd)

For OpenShift, see:

- The [Red Hat Hybrid Cloud blog](https://cloud.redhat.com/blog/containerd-support-for-windows-containers-in-openshift)
- The [Red Hat OpenShift documentation](https://docs.openshift.com/container-platform/3.11/crio/crio_runtime.html)

---

## <a id="max-message-size"></a> Nodes fail due to "trying to send message larger than max" error

### Symptom

You see the following error, or similar, in a node status:

```console
Warning ContainerGCFailed 119s (x2523 over 42h) kubelet rpc error: code = ResourceExhausted desc = grpc: trying to send message larger than max (16779959 vs. 16777216)
```

### Cause

This is due to the way that the container runtime interface (CRI) handles garbage
collection for unused images and containers.

### Solution

Do not use Docker as the CRI because it is not supported. Some versions of EKS
default to Docker as the runtime.

---

## <a id="old-build-cache-used"></a> Build platform uses the old build cache after upgrade to new stack

### Symptom

While upgrading apps to a later stack, you might encounter the build platform
erroneously reusing the old build cache.

### Solution

If you encounter this issue, delete, and recreate the workload in Tanzu Application Platform,
or delete and recreate the image in Tanzu Build Service.

## <a id="shared-image-registry"></a> Switching from `buildservice.kp_default_repository` to `shared.image_registry`

### Symptom

After switching to using the `shared.image_registry` fields in `tap-values.yaml`, your workloads
might start failing with a `TemplateRejectedByAPIServer` error, with the error message:
`admission webhook "validation.webhook.kpack.io" denied the request: validation
failed: Immutable field changed: spec.tag`.

### Cause

Tanzu Application Platform automatically appends `/buildservice` to the end of the repository
specified in `shared.image_registry.project_path`. This updates the existing workload image
tags, which is not allowed by Tanzu Build Service.

### Solution

Delete the `images.kpack.io`, it has the same name as the
workload. The workload then recreates it with valid values.

Alternatively, re-add the `buildservice.kp_default_repository_*` fields
in the `tap-values.yaml`. You must set both the repository and the
authentication fields to override the shared values. Set `kp_default_repository`, `kp_default_repository_secret.name`, and
`kp_default_repository_secret.namespace`.

## <a id='failed-builds-upgrade'></a> Failing builds during an upgrade

### Symptom

During upgrades a large number of builds might be created due to buildpack and stack updates.
Some of these builds might fail causing the workload to be in an unhealthy state.

### Cause

Builds fail due to transient network issues.

### Solution

This resolves itself on subsequent builds after a code change and does not affect the running application.

If you do not want to wait for subsequent builds to run, you can use either the Tanzu Build Service
plug-in for the Tanzu CLI or the open source [kpack CLI](https://github.com/buildpacks-community/kpack-cli)
to trigger a build manually.

**If using the Tanzu CLI**, manually trigger a build as follows:

1. List the image resources in the developer namespace by running:

    ```console
    tanzu build-service image list -n DEVELOPER-NAMESPACE
    ```

1. Manually trigger the image resources to re-run builds for each failing image by running:

    ```console
    tanzu build-service image trigger IMAGE-NAME -n DEVELOPER-NAMESPACE
    ```

**If using the kpack CLI**, manually trigger a build as follows:

1. List the image resources in the developer namespace by running:

    ```console
    kp image list -n DEVELOPER-NAMESPACE
    ```

1. Manually trigger the image resources to re-run builds for each failing image by running:

    ```console
    kp image trigger IMAGE-NAME -n DEVELOPER-NAMESPACE
    ```
