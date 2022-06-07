# Install Application Accelerator

This document describes how to install Application Accelerator
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Application Accelerator.
For more information about profiles, see [About Tanzu Application Platform package and profiles](../about-package-profiles.md).

## <a id='app-acc-prereqs'></a>Prerequisites

Before installing Application Accelerator:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

- Install Flux SourceController on the cluster.
See [Install cert-manager, Contour, and FluxCD Source Controller](../cert-mgr-contour-fcd/install-cert-mgr.md).

-  Install Source Controller on the cluster.
See [Install Source Controller](../source-controller/install-source-controller.md).

## <a id='app-acc-config'></a> Configure properties and resource usage

When you install the Application Accelerator, you can configure the following optional properties:

| Property | Default | Description |
| --- | --- | --- |
| registry.secret_ref | registry.tanzu.vmware.com | The secret used for accessing the registry where the App-Accelerator images are located |
| server.service_type | LoadBalancer | The service type for the acc-ui-server service including LoadBalancer, NodePort, or ClusterIP |
| server.watched_namespace | accelerator-system | The namespace the server watches for accelerator resources |
| server.engine_invocation_url | http://acc-engine.accelerator-system.svc.cluster.local/invocations | The URL to use for invoking the accelerator engine |
| engine.service_type | ClusterIP | The service type for the acc-engine service including LoadBalancer, NodePort, or ClusterIP |
| engine.max_direct_memory_size | 32M | The maximum size for the Java -XX:MaxDirectMemorySize setting |
| samples.include | True | Option to include the bundled sample Accelerators in the installation |
| ingress.include | False | Option to include the ingress configuration in the installation |
| ingress.enable_tls | False | Option to include TLS for the ingress configuration |
| domain | tap.example.com | Top-level domain to use for ingress configuration, defaults to `shared.ingress_domain` |
| tls.secretName | tls | The name of the secret |
| tls.namespace | tanzu-system-ingress | The namespace for the secret |

VMware recommends that you do not override the defaults for `registry.secret_ref`,
`server.engine_invocation_url`, or `engine.service_type`.
These properties are only used to configure non-standard installations.

The following table is the resource usage configurations for the components of Application Accelerator.

| Component | Resource requests | Resource limits |
| --- | --- | --- |
| acc-controller | cpu: 100m <br> memory: 20Mi| cpu: 100m <br> memory: 30Mi |
| acc-server | cpu: 100m <br> memory:20Mi | cpu: 100m <br> memory: 30Mi |
| acc-engine | cpu: 500m <br> memory: 1Gi | cpu: 500m <br> memory: 2Gi |


## <a id='app-acc-install'></a> Install

To install Application Accelerator:

1. List version information for the package by running:

    ```console
    tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list accelerator.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for accelerator.apps.tanzu.vmware.com...
      NAME                               VERSION  RELEASED-AT
      accelerator.apps.tanzu.vmware.com  0.5.1    2021-12-02T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```console
    tanzu package available get accelerator.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```console
    $ tanzu package available get accelerator.apps.tanzu.vmware.com/0.5.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.


1. Create an `app-accelerator-values.yaml` using the following example code:

    ```yaml
    server:
      service_type: "LoadBalancer"
      watched_namespace: "accelerator-system"
    samples:
      include: true
    ```

    Edit the values if needed or leave the default values.

    >**Note:** For clusters that do not support the `LoadBalancer` service type, override the default
    >value for `server.service_type`.

1. Install the package by running:

    ```console
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-accelerator-values.yaml
    ```

    Where `VERSION-NUMBER` is the version included in the Tanzu Application Platform installation.

    For example:

    ```console
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 1.0.0 -n tap-install -f app-accelerator-values.yaml
    - Installing package 'accelerator.apps.tanzu.vmware.com'
    | Getting package metadata for 'accelerator.apps.tanzu.vmware.com'
    | Creating service account 'app-accelerator-tap-install-sa'
    | Creating cluster admin role 'app-accelerator-tap-install-cluster-role'
    | Creating cluster role binding 'app-accelerator-tap-install-cluster-rolebinding'
    | Creating secret 'app-accelerator-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'app-accelerator' in namespace 'tap-install'
    ```

1. Verify the package install by running:

    ```console
    tanzu package installed get app-accelerator -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

1. To see the IP address for the Application Accelerator API when the `server.service_type` is set to `LoadBalancer`, run the following command:

    ```console
    kubectl get service -n accelerator-system
    ```

    This lists an external IP address for use with the `--server-url` Tanzu CLI flag for the Accelerator plug-in `generate` command.
