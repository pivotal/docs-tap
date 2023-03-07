# Provision namespace resources

There are two approaches to provisioning namespace-scoped resources supported:

[Using Namespace Provisioner Controller](#controller-ns-provision) is recommended for Tanzu
Application Platform clusters that:

- include [Out of the Box Supply Chain Basic](../scc/ootb-supply-chain-basic.hbs.md)
- require only the default namespace-scoped resources to be provisioned

[Using GitOps](#using-gitops) is required for Tanzu Application Platform clusters that
meet any of the following:

- include [Out of the Box Supply Chain - Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md)
- require customization or extension of the default namespace-scoped resources that are provisioned
- prefer to control which namespaces get provisioned with GitOps

## <a id="controller-ns-provision"></a>Using Namespace Provisioner Controller

This section describes how to use the Namespace Provisioner Controller to provision namespace-scoped resources.

### <a id="nps-controller-prereq"></a>Prerequisites</a>

Ensure that the following prerequisites.

- The Namespace Provisioner package is installed and reconciled.
- The [controller tap value key](install.hbs.md#customized-installation) is set to **`true`**
  (Default is `true`).
- The `registry-credentials` secret referenced by the Tanzu Build Service is added to tap-install
  and exported to all namespaces. If you don’t want to export this secret to all namespaces for any
  reason, you must complete an additional step to create this secret in each namespace
  you want to provision.
  - Example secret creation, exported to all namespaces

    ```terminal
    tanzu secret registry add tbs-registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --export-to-all-namespaces --yes --namespace tap-install
    ```

  - Example secret creation for a specific namespace

    ```console
    tanzu secret registry add tbs-registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --yes --namespace YOUR-NEW-DEVELOPER-NAMESPACE
    ```

### <a id="provision-dev-namespace"></a>Provision a new developer namespace

Complete the following steps to provision a new developer namespace:

1. Create a namespace using kubectl or any other means:

   ```console
   kubectl create namespace YOUR-NEW-DEVELOPER-NAMESPACE
   ```

2. Label your new developer namespace with the label selector `apps.tanzu.vmware.com/tap-ns=""`:

   ```console
   kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE apps.tanzu.vmware.com/tap-ns=""
   ```

   - This label tells the controller to add this namespace to the
   [desired-namespaces](about.hbs.md#desired-ns-configmap) ConfigMap.
   - The label's value can be anything, including "".
   - If required, you can change the default label selector by configuring the
     [namespace_selector](install.hbs.md#customized-install) property/value in tap-values
     for namespace provisioner.

3. (Optional) Add the registry-credentials secret referenced by the Tanzu Build Service to the new
     namespace and patch the service account that will be used by the workload to refer to this new secret.

     ```console
     tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --yes --namespace YOUR-NEW-DEVELOPER-NAMESPACE
     ```

   This step is only required if the `registry-credentials` secret that was created
   during Tanzu Application Platform Installation **_was not_** exported to all namespaces (see the
   [Prerequisites](#nps-controller-prerequisites) section above for details).

4. Run the following command to verify the correct resources were created in the namespace:

   ```console
   kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap -n YOUR-NEW-DEVELOPER-NAMESPACE
   ```

   To see the list of resources that are provisioned in your namespace based on the installation
   profile and supply chain values configured in your `tap-values.yaml` file, see
   [Default resources mapping](reference.hbs.md#default-resources-mapping).

## <a id="using-gitops"></a>Using GitOps

This section describes how to use the built-in controller instead of using GitOps to
manage the list of namespaces in the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap).

>**WARNING** If there is a namespace in your GitOps repository [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) list that does not exist on the cluster, the [provisioner application](about.hbs.md#nsp-component-carvel-app) fails to reconcile and cannot create resources.
Creation of the namespaces is out of the scope for the Namespace Provisioner package.

### <a id="gitops-prerequisites"></a>Prerequisites

The prerequisites for using GitOps are the same as those specified in the
[controller prerequisites](#nps-controller-prereq) above except for the `controller`
tap value key's value as follows:

- The [controller tap value key](install.hbs.md#customized-install) is set to **`false`**
  (Default is `true`)

For more information about provisioning namespaces with GitOps, see [Control the desired-namespaces ConfigMap with GitOps](how-tos.hbs.md#control-desired-namespaces).
