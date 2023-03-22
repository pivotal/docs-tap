# Provision Developer Namespaces

This topic describes how to provision developer namespaces.

## Prerequisite

- The Namespace Provisioner package is installed and successfully reconciled.
- The registry-credential secret referenced by the Supply chain components for pulling and pushing
images is added to tap-install and exported to all namespaces.

Example secret creation, exported to all namespaces

```console
tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --export-to-all-namespaces --yes --namespace tap-install
```

>**Important**: Namespace Provisioner creates a secret called registries-credentials in each managed
namespace which is a placeholder secret filled indirectly by
[secretgen-controller](https://github.com/carvel-dev/secretgen-controller) with all the registry
credentials exported for that managed  namespace.

## Manage a list of Developer namespaces

There are 2 ways to manage the list of Developer namespaces that are managed by Namespace provisioner.

Using Namespace Provisioner Controller
: Description

    Sample TAP values configuration:

    ```console
    namespace_provisioner:
      controller: true
    ```

    The imperative way is to create the namespace using kubectl or via other means and label it using
    the default selector.

    1. Create a namespace using kubectl or any other means

        ```console
        kubectl create namespace YOUR-NEW-DEVELOPER-NAMESPACE
        ```

    2. Label your new developer namespace with the default namespace_selector apps.tanzu.vmware.com/tap-ns="".

        ```console
        kubectl label namespaces YOUR-NEW-DEVELOPER-NAMESPACE apps.tanzu.vmware.com/tap-ns=""
        ```

      - This label tells the namespace provisioner controller to add this namespace to the
      desired-namespaces ConfigMap.
      - By default, the label’s value can be anything, including "".
      - If required, you can change the default label selector (See Controller section of the
      Customize Install for more details).

    3. Run the following command to verify the default resources have been created in the namespace:

        ```console
        kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange -n YOUR-NEW-DEVELOPER-NAMESPACE

        For example:

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

    Sample Tanzu Application Platform values configuration:

    ```console
    namespace_provisioner:
    controller: false
    gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    This GitOps configuration will do the following things:

    - controller: false will tell the namespace provisioner package to not install the controller
    as the list of namespaces will be managed in a GitOps repository.
    - The samples/gitops-install directory specified as the subPath value in the TAP values
    configuration sample above includes 2 files:
    desired-namespace.yaml contains the list of developer namespaces in a ytt data.values format.
    namespaces.yaml contains a Kubernetes namespace object.

    >**Note** If you have another tool like Tanzu Mission Control or some other process that is
    taking care of creating namespaces for you, and you don’t want a namespace provisioner to create
    the namespaces, you can delete this file from your GitOps install repository.
    >**Important**  The GitOps sample creates the following two namespaces: `dev` and `qa`. If these
    namespaces already exist in your cluster, remove them or rename the namespaces in your GitOps
    repository so they do not conflict with existing resources.

    Run the following command to verify the [default resources](#fake) have been created in the namespace:

    ```console
    kubectl get secrets,serviceaccount,rolebinding,pods,workload,configmap,limitrange -n dev


    For example:

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

    See GitOps section of the [Customize Installation](#fake) guide for more details.

    ### <a id="fake"></a>Fake section -->