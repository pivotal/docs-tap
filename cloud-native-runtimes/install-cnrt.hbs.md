# Install Cloud Native Runtimes

This document describes how to install Cloud Native Runtimes
from the Tanzu Application Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Cloud Native Runtimes. For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='cnr-prereqs'></a>Prerequisites

Before installing Cloud Native Runtimes:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.hbs.md).
- Ensure Contour v1.22.0 or greater is installed. Tanzu Application Platform comes with a correctly versioned package of Contour if you do not have it installed already.

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
      cnrs.tanzu.vmware.com  2.0.2    2022-11-15T00:00:00Z
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather values schema.

        ```console
        tanzu package available get cnrs.tanzu.vmware.com/2.0.2 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get cnrs.tanzu.vmware.com/2.0.2 --values-schema -n tap-install
        | Retrieving package details for cnrs.tanzu.vmware.com/2.0.2...
          KEY                         DEFAULT                               TYPE     DESCRIPTION
          provider                    <nil>                                 string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on a local Kubernetes cluster provider.
          default_tls_secret          <nil>                                 string   Optional: Overrides the config-contour configmap in namespace knative-serving.
          domain_config               <nil>                                 object   Optional: Overrides the config-domain configmap in namespace knative-serving. Must be valid YAML.
          domain_name                 <nil>                                 string   Optional: Default domain name for Knative Services.
          domain_template             \{{.Name}}.\{{.Namespace}}.\{{.Domain}}  string   Optional: specifies the golang text template string to use when constructing the Knative service's DNS name.
          ingress.external.namespace  tanzu-system-ingress                  string   Required: Specify a namespace where an existing Contour is installed on your cluster. CNR will use this Contour instance for external services.
          ingress.internal.namespace  tanzu-system-ingress                  string   Required: Specify a namespace where an existing Contour is installed on your cluster. CNR will use this Contour instance for internal services.
          lite.enable                 false                                 boolean  Optional: Not recommended for production. Set to "true" to reduce CPU and Memory resource requests for all CNR Deployments, Daemonsets, and Statefulsets by half. On by default when "provider" is set to "local".
          pdb.enable                  true                                  boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
        ```

    1. Create a `cnr-values.yaml` by using the following sample as a guide:

        Sample `cnr-values.yaml` for Cloud Native Runtimes:


        ```console
        ---
        domain_name: example.com
        ingress:
        external:
            namespace: tanzu-system-ingress
        internal:
            namespace: tanzu-system-ingress
        ```

        >**Note** For most installations, you can leave the `cnr-values.yaml` empty, and use the default values.

        If you are running on a single-node cluster, such as kind or minikube, set the `lite.enable: true`
        option. This option reduces resources requests for CNR deployments.

        Cloud Native Runtimes uses the existing Contour installation in the  `tanzu-system-ingress` namespace by default for external and internal access.

        If your environment has Contour installed already, and it is not the TAP provided Contour, you can configure CNR to use it. See [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-contour.html) in the Cloud Native Runtimes documentation for more information.

1. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.0.2 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.0.2 -n tap-install -f cnr-values.yaml --poll-timeout 30m
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
    PACKAGE-VERSION:         2.0.2
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

1. Configure a namespace to use Cloud Native Runtimes:

   >**Important** This step covers configuring a namespace to run Knative services.
   >If you rely on a SupplyChain to deploy Knative services into your cluster,
   >skip this step because namespace configuration is covered in
   >[Set up developer namespaces to use your installed packages](../install-online/set-up-namespaces.hbs.md).
   >Otherwise, you must follow these steps for each namespace where you create Knative services.

   Service accounts that run workloads using Cloud Native Runtimes need access to the image pull secrets for the Tanzu package.
   This includes the `default` service account in a namespace, which is created automatically but not associated with any image pull secrets.
   Without these credentials, attempts to start a service fail with a timeout and the pods report that they are unable to pull the `queue-proxy` image.

    1. Create an image pull secret in the current namespace and fill it from the `tap-registry`
    secret mentioned in [Add the Tanzu Application Platform package repository](../install-online/profile.hbs.md#add-tap-package-repo).
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

        >**Note** The service account has access to the `pull-secret` image pull secret.
