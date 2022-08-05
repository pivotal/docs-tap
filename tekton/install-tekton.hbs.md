# Install Tekton

This topic describes how to install Tekton from the Tanzu Application Platform package repository.

Use the instructions on this page if you do not want to install Tekton by using a
Tanzu Application Platform profile.
The Full, Iterate, and Build profiles include the Tekton Pipelines package.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.html).


## <a id='prereqs'></a>Prerequisites

Before installing Tekton, complete all [prerequisites](../prerequisites.html) to install
Tanzu Application Platform.


## <a id='install-tekton-pipelines'></a> Install Tekton Pipelines

To install Tekton Pipelines:

1. See the Tekton Pipelines package versions available to install by running:

    ```console
    tanzu package available list -n tap-install tekton.tanzu.vmware.com
    ```

    For example:

    ```console
    $ tanzu package available list -n tap-install tekton.tanzu.vmware.com
    \ Retrieving package versions for tekton.tanzu.vmware.com...
      NAME                     VERSION  RELEASED-AT
      tekton.tanzu.vmware.com  0.30.0   2021-11-18 17:05:37Z
    ```

1. Install Tekton by running:

    ```console
    tanzu package install tekton-pipelines -n tap-install -p tekton.tanzu.vmware.com -v VERSION
    ```

    Where `VERSION` is the desired version number. For example, `0.30.0`.

    For example:

    ```console
    $ tanzu package install tekton-pipelines -n tap-install -p tekton.tanzu.vmware.com -v 0.30.0
    - Installing package 'tekton.tanzu.vmware.com'
    \ Getting package metadata for 'tekton.tanzu.vmware.com'
    / Creating service account 'tekton-pipelines-tap-install-sa'
    / Creating cluster admin role 'tekton-pipelines-tap-install-cluster-role'
    / Creating cluster role binding 'tekton-pipelines-tap-install-cluster-rolebinding'
    / Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'tekton-pipelines'
    - 'PackageInstall' resource install status: Reconciling


     Added installed package 'tekton-pipelines'
    ```

1. Verify that you installed the package by running:

    ```console
    tanzu package installed get tekton-pipelines -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get tekton-pipelines -n tap-install
    \ Retrieving installation details for tekton...
    NAME:                    tekton-pipelines
    PACKAGE-NAME:            tekton.tanzu.vmware.com
    PACKAGE-VERSION:         0.30.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.


## <a id='config-namespace'></a> Configure a namespace to use Tekton Pipelines

This section covers configuring a namespace to run Tekton Pipelines.
If you rely on a SupplyChain to create Tekton PipelinesRuns in your cluster, skip this step because
namespace configuration is covered in [Set up developer namespaces to use installed packages](#setup).
Otherwise, perform the steps in this section for each namespace where you create Tekton Pipelines.

Service accounts that run Tekton workloads need access to the image pull secrets for the Tanzu package.
This includes the `default` service account in a namespace, which is created automatically but is
not associated with any image pull secrets.
Without these credentials, PipelineRuns fail with a timeout and the pods report that they cannot
pull images.

To configure a namespace to use Tekton Pipelines:

1. Create an image pull secret in the current namespace and fill it from the `tap-registry` secret.
For more information, see [Relocate images to a registry](../install.html#add-tap-package-repo).

1. Create an empty secret, and annotate it as a target of the secretgen controller, by running:

    ```console
    kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
    kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
    ```

1. After you create a `pull-secret` secret in the same namespace as the service account, add the
secret to the service account by running:

    ```console
    kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
    ```

1. Verify that a service account is correctly configured by running:

    ```console
    kubectl describe serviceaccount default
    ```

    For example:

    ```console
    kubectl describe sa default
    Name:                default
    Namespace:           default
    Labels:              <none>
    Annotations:         <none>
    Image pull secrets:  pull-secret
    Mountable secrets:   default-token-xh6p4
    Tokens:              default-token-xh6p4
    Events:              <none>
    ```

    > **Note:** The service account has access to the `pull-secret` image pull secret.

For more details about Tekton Pipelines, see the [Tekton documentation](https://tekton.dev/docs/) and
the [GitHub repository](https://github.com/tektoncd/pipeline).

For information about getting started with Tekton, see the Tekton
[tutorial](https://github.com/tektoncd/pipeline/blob/main/docs/tutorial.md) in GitHub and the
[getting started guide](https://tekton.dev/docs/getting-started/) in the Tekton documentation.

> **Note:** Windows workloads are deactivated and cause an error if any Tasks try to use Windows scripts.
