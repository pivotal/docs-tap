# Provision developer namespaces

This topic describes how to use Namespace Provisioner to provision developer namespaces in Tanzu Application Platform (commonly known as TAP).

## Prerequisite

- The Namespace Provisioner package is installed and reconciled.
- The registry-credential secret referenced by the Supply chain components for pulling and pushing images is added to **tap-install** and exported to all namespaces.

Example secret creation, exported to all namespaces:

```shell
tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --export-to-all-namespaces --yes --namespace tap-install
```

>**Important** Namespace Provisioner creates a secret called registries-credentials in each managed namespace which is a placeholder secret filled indirectly by [secretgen-controller](https://github.com/carvel-dev/secretgen-controller) with all the registry credentials exported for that managed  namespace.

## <a id ='manage-list'></a>Manage a list of developer namespaces

There are two ways to manage the list of developer namespaces that are managed by Namespace Provisioner.

Using Namespace Provisioner Controller
:

  `tap-values.yaml` configuration example:

  ```yaml
  namespace_provisioner:
    controller: true
  ```

  The imperative way is to create the namespace using kubectl or using other means and label it using the default selector.

  1. Create a namespace using kubectl or any other means

      ```shell
      kubectl create namespace YOUR-NEW-DEVELOPER-NAMESPACE
      ```

  2. Label your new developer namespace with the default *namespace_selector* `apps.tanzu.vmware.com/tap-ns=""`.

      ```shell
      kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE apps.tanzu.vmware.com/tap-ns=""
      ```

      - This label tells the Namespace Provisioner controller to add this namespace to the [desired-namespaces](about.hbs.md#desired-ns) ConfigMap.
      - By default, the label’s value can be anything, including "".
      - If required, you can change the default label selector, see [Customize Installation of Namespace Provisioner](customize-installation.hbs.md#con-label-selector).
  3. Run the following command to verify the [default resources](default-resources.hbs.md) have been created in the namespace:

      ```shell
      kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange -n YOUR-NEW-DEVELOPER-NAMESPACE
      ```
      For example:

      ```console
      NAME                            TYPE                             DATA   AGE
      secret/app-tls-cert             kubernetes.io/tls                3      19s
      secret/registries-credentials   kubernetes.io/dockerconfigjson   1      26s
      secret/scanner-secret-ref       kubernetes.io/dockerconfigjson   1      20s

      NAME                           SECRETS   AGE
      serviceaccount/default         1         4h7m
      serviceaccount/grype-scanner   2         20s

      NAME                                                               ROLE                      AGE
      rolebinding.rbac.authorization.k8s.io/default-permit-deliverable   ClusterRole/deliverable   26s
      rolebinding.rbac.authorization.k8s.io/default-permit-workload      ClusterRole/workload      26s

      NAME                         DATA   AGE
      configmap/kube-root-ca.crt   1      38h

      NAME                            CREATED AT
      limitrange/dev-lr   2023-03-08T04:18:58Z
    
     ```

Using GitOps
: The GitOps approach provides a fully declarative way to create developer namespaces managed
by Namespace Provisioner.

  `tap-values.yaml` configuration example:

  ```yaml
  namespace_provisioner:
    controller: false
    gitops_install:
      ref: origin/main
      subPath: ns-provisioner-samples/gitops-install
      url: https://github.com/vmware-tanzu/application-accelerator-samples.git
  ```

  This GitOps configuration does the following things:

  - `controller: false` - The Namespace Provisioner package does not install the controller. The list of namespaces is managed in a GitOps repository instead.
  - The `gitops-install` directory specified as the `subPath` value includes two files:

    1. [desired-namespace.yaml](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-install/desired-namespaces.yaml) contains the list of developer namespaces in a ytt data.values format.
    2. [namespaces.yaml](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-install/namespaces.yaml) contains a Kubernetes namespace object.

  >**Note** If you have another tool like Tanzu Mission Control or some other process that is taking care of creating namespaces for you, and you don’t want a Namespace Provisioner to create the namespaces, you can delete this file from your GitOps install repository.

  >**Important**  The `tap-values.yaml` configuration example above creates the following two namespaces: `dev` and `qa`. If these namespaces already exist in your cluster, remove them or rename the namespaces in your GitOps repository so they do not conflict with existing resources.

  Run the following command to verify the [default resources](default-resources.hbs.md) are created in the namespace:

  ```shell
  kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange -n dev
  ```

  For example:
  
  ```console
  NAME                            TYPE                             DATA   AGE
  secret/app-tls-cert             kubernetes.io/tls                3      52s
  secret/registries-credentials   kubernetes.io/dockerconfigjson   1      59s
  secret/scanner-secret-ref       kubernetes.io/dockerconfigjson   1      53s

  NAME                           SECRETS   AGE
  serviceaccount/default         1         59s
  serviceaccount/grype-scanner   2         53s

  NAME                                                               ROLE                      AGE
  rolebinding.rbac.authorization.k8s.io/default-permit-deliverable   ClusterRole/deliverable   59s
  rolebinding.rbac.authorization.k8s.io/default-permit-workload      ClusterRole/workload      59s

  NAME                         DATA   AGE
  configmap/kube-root-ca.crt   1      59s

  NAME                CREATED AT
  limitrange/dev-lr   2023-03-08T04:22:20Z
  ```
  
  For more information, see the GitOps section of [Customize Installation of Namespace Provisioner](customize-installation.hbs.md).

## <a id ='additional-users-k8s-rbac'></a>Enable additional users with Kubernetes RBAC
  
Namespace Provisioner does not support enabling additional users with Kubernetes RBAC. Support
is planned for an upcoming release. Until Namespace Provisioner support is provided, follow
the instructions in [Enable additional users with Kubernetes RBAC](legacy-manual-namespace-setup.hbs.md#user-rbac-k8s).
