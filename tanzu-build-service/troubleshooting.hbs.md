# Troubleshooting Tanzu Build Service

This topic provides information to help troubleshoot Tanzu Build Service when used with
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

## <a id="eks-1-23-volume"></a> Builds fail due to volume errors on EKS running Kubernetes version 1.23

### Symptom

Installing TAP on or upgrading an existing EKS cluster to Kubernetes version 1.23

Build pods are showing:
```console
'running PreBind plugin "VolumeBinding": binding volumes: timed out waiting
 for the condition'
```

### Explanation

This is due to the [CSIMigrationAWS in this K8s version version](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/) which requires users to install the [Amazon EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) to use EBS volumes.

TAP uses the default storage class which uses EBS volumes by default on EKS.

### Solution

Follow the AWS documentation to install the [Amazon EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) before installing TAP or before upgrading to K8s 1.23.
