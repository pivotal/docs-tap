# Install Cloud Native Runtimes

This document describes how to install Cloud Native Runtimes
from the Tanzu Application Platform package repository.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Cloud Native Runtimes.
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.md).

## <a id='cnr-prereqs'></a>Prerequisites

Before installing Cloud Native Runtimes:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Ensure you have an internal or external Contour namespace on a cluster with v1.19.1 of Contour installed when you configure `reuse_crds:true`.

>**Note:** Cloud Native Runtimes fails to install when configured with `reuse_crds:true` and no internal or external Contour namespace provided on a cluster with Contour installed at a version other than v1.19.1.

## <a id='cnr-install'></a> Install

To install Cloud Native Runtimes:

1. List version information for the package by running:

    ```console
    tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list cnrs.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.3    2021-10-20T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather values schema.

        ```console
        tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get cnrs.tanzu.vmware.com/1.0.3 --values-schema -n tap-install
        | Retrieving package details for cnrs.tanzu.vmware.com/1.0.3...
          KEY                         DEFAULT  TYPE             DESCRIPTION
          ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance is already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
          ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance is already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
          ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance is already present in the cluster. Set to "true" if you want CNR to re-use the cluster's existing Contour CRDs.
          local_dns.domain            <nil>    string   Optional: Set a custom domain for CoreDNS. Only applicable when "local_dns.enable" is set to "true" and "provider" is set to "local" and running on Kind.
          local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
          pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
          provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on a local Kubernetes cluster provider.
        ```

    1. Create a `cnr-values.yaml` by using the following sample as a guide:

        Sample `cnr-values.yaml` for Cloud Native Runtimes:


        ```console
        ---
        # if deploying on a local cluster such as Kind. Otherwise, you can remove this field
        provider: local
        ```

        >**Note:** For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

        If you are running on a single-node cluster, such as kind or minikube, set the `provider: local`
        option. This option reduces resource requirements by using a HostPort service instead of a
        LoadBalancer and reduces the number of replicas.

        Cloud Native Runtimes reuses the existing `tanzu-system-ingress` Contour installation for
        external and internal access when installed in the `light` or `full` profile.
        If you want to use a separate Contour installation for system-internal traffic, set
        `cnrs.ingress.internal.namespace` to the empty string (`""`).

        For more information about using Cloud Native Runtimes with kind, see the
        [Cloud Native Runtimes documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.2/tanzu-cloud-native-runtimes/GUID-local-dns.html#config-cluster).
        If you are running on a multinode cluster, do not set `provider`.

        If your environment has Contour packages, Contour might conflict with the Cloud Native Runtimes installation.

        For information about how to prevent conflicts, see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.2/tanzu-cloud-native-runtimes/GUID-contour.html) in the Cloud Native Runtimes documentation.
        Specify values for `ingress.reuse_crds`,
        `ingress.external.namespace`, and `ingress.internal.namespace` in the `cnr-values.yaml` file.

1. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.3 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```

    Use an empty file for `cnr-values.yaml` if you want the default installation configuration. Otherwise, see the previous step to learn more about setting installation configuration values.

1. Verify the package install by running:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.3
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. Configure a namespace to use Cloud Native Runtimes:

   >**Note:** This step covers configuring a namespace to run Knative services.
   >If you rely on a SupplyChain to deploy Knative services into your cluster,
   >skip this step because namespace configuration is covered in
   >[Set up developer namespaces to use installed packages](../set-up-namespaces.md).
   >Otherwise, you must complete the following steps for each namespace where you create Knative services.

   Service accounts that run workloads using Cloud Native Runtimes need access to the image pull secrets for the Tanzu package.
   This includes the `default` service account in a namespace, which is created automatically but not associated with any image pull secrets.
   Without these credentials, attempts to start a service fail with a timeout and the pods report that they are unable to pull the `queue-proxy` image.

    1. Create an image pull secret in the current namespace and fill it from the `tap-registry`
    secret mentioned in
       [Add the Tanzu Application Platform package repository](../install.md#add-tap-package-repo).
       Run the following commands to create an empty secret and annotate it as a target of the secretgen
       controller:

        ```console
        kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
        kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
        ```

    1. After you create a `pull-secret` secret in the same namespace as the service account,
    run the following command to add the secret to the service account:

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

        >**Note:** The service account has access to the `pull-secret` image pull secret.
