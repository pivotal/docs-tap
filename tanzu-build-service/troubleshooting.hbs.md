# Troubleshooting Tanzu Build Service

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
to install the [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
to use AWS Elastic Block Store (EBS) volumes.
For more information about EKS support for Kubernetes v1.23, see the
[Amazon blog post](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/).

Tanzu Application Platform uses the default storage class which uses EBS volumes by default on EKS.

### Solution

Follow the AWS documentation to install the [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
before installing Tanzu Application Platform, or before upgrading to Kubernetes v1.23.

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
For instructions, refer to the following documentation for your Kubernetes cluster provider.

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
- The [Red Hat Openshift documentation](https://docs.openshift.com/container-platform/3.11/crio/crio_runtime.html)

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

While upgrading apps to a newer stack, you might encounter the build platform
erroneously reusing the old build cache.

### Solution

If you encounter this issue, delete and recreate the workload in Tanzu Application Platform, or delete and recreate the image in Tanzu Build Service.
