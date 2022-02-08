# Install Tekton

This document describes how to install Tekton
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Tekton.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

## <a id='prereqs'></a>Prerequisites

Before installing Tekton:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

## <a id='install-tekton-pipelines'></a> Install Tekton Pipelines

To install Tekton Pipelines:

1. See what versions of Tekton Pipelines are available to install by running:

    ```
    tanzu package available list -n tap-install tekton.tanzu.vmware.com
    ```

    For example:

    ```
    $ tanzu package available list -n tap-install tekton.tanzu.vmware.com
    \ Retrieving package versions for tekton.tanzu.vmware.com...
      NAME                     VERSION  RELEASED-AT
      tekton.tanzu.vmware.com  0.30.0   2021-11-18 17:05:37Z
    ```

1. Install Tekton by running:

    ```
    tanzu package install tekton-pipelines -n tap-install -p tekton.tanzu.vmware.com -v 0.30.0
    ```

    For example:

    ```
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

1. Verify that the package installed by running:

    ```
    tanzu package installed get tekton-pipelines -n tap-install
    ```

    For example:

    ```
    $ tanzu package installed get tekton-pipelines -n tap-install
    \ Retrieving installation details for tekton...
    NAME:                    tekton-pipelines
    PACKAGE-NAME:            tekton.tanzu.vmware.com
    PACKAGE-VERSION:         0.30.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be `Reconcile succeeded`.

1. Configuring a namespace to use Tekton Pipelines:

   > **Note:** This step covers configuring a namespace to run Tekton Pipelines.
   If you rely on a SupplyChain to create Tekton PipelineRuns in your cluster,
   then skip this step because namespace configuration is covered in
   [Set up developer namespaces to use installed packages](#setup). Otherwise,
   you must complete the following steps for each namespace where you create
   Tekton Pipeline/Tasks.

   Service accounts that run Tekton workloads need access to the image pull
   secrets for the Tanzu package.  This includes the `default` service account
   in a namespace, which is created automatically but not associated with any
   image pull secrets.  Without these credentials, PipelineRuns fail with a
   timeout and the pods report that they cannot pull images.

   Create an image pull secret in the current namespace and fill it from
   [the `tap-registry` secret](../install.md#add-package-repositories).  Run the following
   commands to create an empty secret and annotate it as a target of the
   secretgen controller:

   ```
   kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
   kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
   ```

   After you create a `pull-secret` secret in the same namespace as the service account,
   run the following command to add the secret to the service account:

   ```
   kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
   ```

    Verify that a service account is correctly configured by running:

   ```
   kubectl describe serviceaccount default
   ```

   For example:

   ```
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

For more details on Tekton Pipelines, see the [Tekton documentation](https://tekton.dev/docs/) and the
[github repository](https://github.com/tektoncd/pipeline).

You can also view the Tekton [tutorial](https://github.com/tektoncd/pipeline/blob/main/docs/tutorial.md) and
[getting started guide](https://tekton.dev/docs/getting-started/).

> **Note:** Windows workloads have been disabled and will error if any Tasks tries to use Windows scripts.
