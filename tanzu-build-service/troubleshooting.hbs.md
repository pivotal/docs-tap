# Troubleshooting Tanzu Build Service

This topic tells you how to troubleshoot Tanzu Build Service when used with
Tanzu Application Platform.

## <a id="tbs-1-2-breaking-change"></a> Builds fail after upgrading to Tanzu Application Platform v1.2

### Symptom

After upgrading to Tanzu Application Platform v1.2, you see failing builds.

### Explanation

After the upgrade, Tanzu Build Service image resources automatically run a build
that fails due to a missing dependency.

This error does not persist and any subsequent builds will resolve this error.

### Solution

You can safely wait for the next build of the workloads, which is triggered by new source code changes.

If you do not want to wait for subsequent builds to run automatically, you can use the open source
[kp](https://github.com/vmware-tanzu/kpack-cli) CLI to re-run failing builds:

1. List the image resources in the developer namespace by running:

    ```console
    kp image list -n DEVELOPER-NAMESPACE
    ```

    Where `DEVELOPER-NAMESPACE` is the namespace where workloads are created.

1. Manually trigger the image resources to re-run builds for each failing image by running:

    ```console
    kp image trigger IMAGE-NAME -n DEVELOPER-NAMESPACE
    ```

    Where:

    - `IMAGE-NAME` is the name of the failing image.
    - `DEVELOPER-NAMESPACE` is the namespace where workloads are created.

## <a id="eks-1-23-volume"></a> Builds fail due to volume errors on EKS running Kubernetes v1.23

### Symptom

After installing Tanzu Application Platform on or upgrading an existing
Amazon Elastic Kubernetes Service (EKS) cluster to Kubernetes v1.23, build pods show:

```console
'running PreBind plugin "VolumeBinding": binding volumes: timed out waiting
 for the condition'
```

### Explanation

This is due to the CSIMigrationAWS in this Kubernetes version, which requires users
to install the [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
to use AWS Elastic Block Store (EBS) volumes.
For more information about EKS support for Kubernetes v1.23, see the
[Amazon blog post](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/).

Tanzu Application Platform uses the default storage class which uses EBS volumes by default on EKS.

### Solution

Follow the AWS documentation to install the [Amazon EBS CSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
before installing Tanzu Application Platform, or before upgrading to Kubernetes v1.23.
