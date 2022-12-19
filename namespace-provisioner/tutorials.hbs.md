# Tutorial: Provisioning new developer namespaces

Two approaches to provisioning namespaced resources are supported:

1. [Using Namespace Provisioner Controller](#controller-ns-provisioning)
2. [Using GitOps](#using-gitops)

## <a id="controller-ns-provisioning"></a>Using Namespace Provisioner Controller

---

### <a id="nps-controller-prerequisites"></a>Prerequisites:</br>
* The Namespace Provisioner package is installed and successfully reconciled
* The [`controller` tap value key](install.hbs.md#customized-installation) is set to **`true`** (Default is `true`)
* The `registry-credentials` secret referenced by the Tanzu Build Service is added to tap-install and exported to all namespaces. If you don’t want to export this secret to all namespaces for any reason, you will have to go through an additional step to create this secret in each namespace you wish to provision.
  * Example secret creation, exported to all namespaces
    ```bash
    tanzu secret registry add tbs-registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --export-to-all-namespaces --yes --namespace tap-install
    ```
  * Example secret creation for a specific namespace
    ```bash
    tanzu secret registry add tbs-registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --yes --namespace YOUR-NEW-DEVELOPER-NAMESPACE
    ```
  

--- 

### <a id="provision-dev-namespace"></a>Steps to provision a new developer namespace:

1. Create a namespace using `kubectl` or any other means
   ```bash
   kubectl create namespace YOUR-NEW-DEVELOPER-NAMESPACE
   ```
2. Label your new developer namespace with the label selector **`apps.tanzu.vmware.com/tap-ns=""`** *
   ```bash
   kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE apps.tanzu.vmware.com/tap-ns=""
   ```
    \* This label tells the controller to add this namespace to the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) ConfigMap.</br>
   * The label's value can be anything you wish, including "".
   * If desired, you can change the default label selector by configuring the  [`namespace_selector`](install.hbs.md#customized-installation) property/value in tap-values for namespace provisioner.
3. **Optional** - this step is only required if the `registry-credentials` secret that was created during TAP Installation **_was not_** exported to all namespaces (see the [Prerequisites](#nps-controller-prerequisites) section above for details).
   * Add the registry-credentials secret referrenced by the Tanzu Build Service to the new namespace and patch the service account that will be used by the workload to refer to this new secret.
     ```bash
     tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --yes --namespace YOUR-NEW-DEVELOPER-NAMESPACE
     ```
4. Run the following command to verify the correct resources have been created in the namespace *
   ```bash
   kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap -n YOUR-NEW-DEVELOPER-NAMESPACE
   ```
   \* Refer to the [TAP Profile Resource Mapping table](reference.hbs.md#profile-resource-mapping) on the [Namespace Provisioner reference materials](reference.hbs.md) page to see the list of resources you should expect to be provisioned in your namespace based on TAP installation profile and supply chain values configured in your tap-values.yaml file.



## <a id="using-gitops"></a>Using GitOps
This section is for those who choose not to use the built-in controller in favor of using GitOps to manage the list of namespaces in the [`desired-namespaces`](about.hbs.md#nsp-component-desired-namespaces-configmap) ConfigMap.

>**WARNING**: if there is a namespace in your GitOps repo desired-namespace list that does not exist on the cluster, the “provisioner” app will fail to reconcile and will not be able to create resources. Creation of the namespaces themselves is out of the scope for the namespace provisioner package.

---

### <a id="gitops-prerequisites"></a>Prerequisites:</br>

The prerequisites for using GitOps are the same as those specified in the [controller prerequisites](#nps-controller-prerequisites) above with the exception of the `controller` tap value key's value as follows:

* The [`controller` tap value key](install.hbs.md#customized-installation) is set to **`false`** (Default is `true`)

---

Please go to the  [**Control the `desired-namespaces` ConfigMap via GitOps**](how-tos.hbs.md#control-desired-namespaces) section of the [How-to Guide](how-tos.hbs.md) for detailed instructions for provisinging namespaces via GitOps. 

### Links to additional Namespace Provisioner documentation:
* [Overview](about.hbs.md)
* [Installation](installation.hbs.md)
* [How-To Provision and Customize Namespaces via GitOps](how-tos.hbs.md)
* [Troubleshooting](troubleshooting.hbs.md)
* [Reference Materials](reference.hbs.md)