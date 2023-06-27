# Install Application Accelerator

This topic describes how to install Application Accelerator
from the Tanzu Application Platform (commonly known as TAP) package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install
> Application Accelerator. For more information about profiles, see [About Tanzu Application Platform
> components and profiles](../about-package-profiles.hbs.md).

## <a id='app-acc-prereqs'></a>Prerequisites

Before installing Application Accelerator:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).

- Install Flux SourceController on the cluster.
See [Install cert-manager, Contour, and FluxCD Source Controller](../cert-mgr-contour-fcd/install-cert-mgr.md).

- Install Source Controller on the cluster.
See [Install Source Controller](../source-controller/install-source-controller.md).

## <a id='app-acc-config'></a> Configure properties and resource use

When you install the Application Accelerator, you can configure the following optional properties:

| Property | Default | Description |
| --- | --- | --- |
| registry.secret_ref | registry.tanzu.vmware.com | The secret used for accessing the registry where the App-Accelerator images are located |
| server.service_type | ClusterIP | The service type for the acc-ui-server service including LoadBalancer, NodePort, or ClusterIP |
| server.watched_namespace | accelerator-system | The namespace the server watches for accelerator resources |
| server.engine_invocation_url | http://acc-engine.accelerator-system.svc.cluster.local/invocations | The URL to use for invoking the accelerator engine |
| engine.service_type | ClusterIP | The service type for the acc-engine service including LoadBalancer, NodePort, or ClusterIP |
| engine.max_direct_memory_size | 32M | The maximum size for the Java -XX:MaxDirectMemorySize setting |
| samples.include | True | Option to include the bundled sample Accelerators in the installation |
| ingress.include | False | Option to include the ingress configuration in the installation |
| ingress.enable_tls | False | Option to include TLS for the ingress configuration |
| domain | tap.example.com | Top-level domain to use for ingress configuration, default is `shared.ingress_domain` |
| tls.secret_name | tls | The name of the secret |
| tls.namespace | tanzu-system-ingress | The namespace for the secret |
| telemetry.retain_invocation_events_for_no_days | 30 | The number of days to retain recorded invocation events resources
| telemetry.record_invocation_events | true | Should the system record each engine invocation when generating files for an accelerator?
| git_credentials.secret_name | git-credentials | The name to use for the secret storing Git credentials for accelerators |
| git_credentials.username | null | The user name to use in secret storing Git credentials for accelerators |
| git_credentials.password | null | The password to use in secret storing Git credentials for accelerators |
| git_credentials.ca_file | null | The CA certificate data to use in secret storing Git credentials for accelerators |
| managed_resources.enable | false | Whether to enable the App used to control managed accelerator resources |
| managed_resources.git.url | none | Required if managed_resources are enabled. Git repository URL containing manifests for managed accelerator resources |
| managed_resources.git.ref | origin/main | Required if managed_resources are enabled. Git ref to use for repository containing manifests for managed accelerator resources |
| managed_resources.git.sub_path | null | Git subPath to use for repository containing manifests for managed accelerator resources |
| managed_resources.git.secret_ref | git-credentials | Secret name to use for repository containing manifests for managed accelerator resources |

VMware recommends that you do not override the defaults for `registry.secret_ref`,
`server.engine_invocation_url`, or `engine.service_type`.
These properties are only used to configure non-standard installations.

The following table is the resource use configurations for the components of Application Accelerator.

| Component | Resource requests | Resource limits |
| --- | --- | --- |
| acc-controller | CPU: 100m <br> memory: 20Mi| CPU: 100m <br> memory: 30Mi |
| acc-server | CPU: 100m <br> memory:20Mi | CPU: 100m <br> memory: 30Mi |
| acc-engine | CPU: 500m <br> memory: 1Gi | CPU: 500m <br> memory: 2Gi |

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
      accelerator.apps.tanzu.vmware.com  {{ vars.tap_version }}    2022-09-30 13:00:00 -0400 EDT
    ```

2. (Optional) To make changes to the default installation settings, run:

    ```console
    tanzu package available get accelerator.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed earlier.

    For example:

    ```console
    tanzu package available get accelerator.apps.tanzu.vmware.com/1.2.1 --values-schema --namespace tap-install
    ```

    For more information about values schema options, see the properties listed earlier.

3. Create an `app-accelerator-values.yaml` using the following example code:

    ```yaml
    server:
      service_type: "LoadBalancer"
      watched_namespace: "accelerator-system"
    samples:
      include: true
    ```

    Edit the values if needed or leave the default values.

4. (Optional) For clusters that do not support the `LoadBalancer` service type, override the default
value for `server.service_type`. For example:

    ```yaml
    server:
      service_type: "ClusterIP"
      watched_namespace: "accelerator-system"
    samples:
      include: true
    ```

5. Install the package by running:

    ```console
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v VERSION-NUMBER -n tap-install -f app-accelerator-values.yaml
    ```

    If `VERSION-NUMBER` is the version included in the Tanzu Application Platform installation.

    For example:

    ```console
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 1.2.1 -n tap-install -f app-accelerator-values.yaml
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

6. Verify the package install by running:

    ```console
    tanzu package installed get app-accelerator -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc...
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         1.2.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`.

7. To see the IP address for the Application Accelerator API when the `server.service_type` is set
   to `LoadBalancer`, run:

    ```console
    kubectl get service -n accelerator-system
    ```

    This lists an external IP address for use with the `--server-url` Tanzu CLI flag for the
    Accelerator plug-in `generate` command.

## <a id='troubleshooting'></a> Troubleshooting

Depending on the error output, there are some actions that you can take.

### Verify installed packages

The package might be already installed. Verify this by running:

`tanzu package installed list -n tap-install`

Look for any package called `accelerator.apps.tanzu.vmware.com`.

### Look at resource events

The error might be within the custom resources such as accelerator, Git repository, fragment,
and so on. These errors are checked by using Kubernetes command line tool (kubectl).

Here is an example using the custom resource `accelerator`:

`kubectl get acc -n accelerator-system`.

It displays the output:

```console
NAME                       READY   REASON     AGE
appsso-starter-java        True    Ready      5h2m
hungryman                  True    Ready      5h2m
java-function              True    Ready      5h2m
java-rest-service          True    Ready      5h2m
java-server-side-ui        True    Ready      5h2m
node-express               True    Ready      5h2m
node-function              False   Not-Ready  5h2m
python-function            True    Ready      5h2m
spring-cloud-serverless    True    Ready      5h2m
spring-smtp-gateway        True    Ready      5h2m
tanzu-java-web-app         True    Ready      5h2m
tap-initialize             True    Ready      5h2m
weatherforecast-csharp     True    Ready      5h2m
weatherforecast-steeltoe   True    Ready      5h2m
```

To verify the error event, run:

`kubectl get acc node-function -n accelerator-system -o yaml`

You can then look at the event section for more information about the error.
