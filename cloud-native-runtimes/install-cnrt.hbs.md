# Install Cloud Native Runtimes

This topic describes how to install Cloud Native Runtimes
from the Tanzu Application Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Cloud Native Runtimes. For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

## <a id='cnr-prereqs'></a>Prerequisites

Before installing Cloud Native Runtimes:

- Complete all prerequisites to install Tanzu Application Platform. See [Prerequisites](../prerequisites.hbs.md).
- Ensure that Contour v1.22.0 or later is installed. Tanzu Application Platform includes a correctly versioned package of Contour if you do not have it installed already.

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
      cnrs.tanzu.vmware.com  2.2.0    2023-03-08 16:00:00 -0800 PST
    ```

1. (Optional) Make changes to the default installation settings:

    1. Gather values schema.

        ```console
        tanzu package available get cnrs.tanzu.vmware.com/2.2.0 --values-schema -n tap-install
        ```

        For example:

        ```console
        $ tanzu package available get cnrs.tanzu.vmware.com/2.2.0 --values-schema -n tap-install
        | Retrieving package details for cnrs.tanzu.vmware.com/2.2.0...
          KEY                         DEFAULT                               TYPE     DESCRIPTION
          https_redirection           true                                  boolean  CNRs ingress will send a 301 redirect for all http connections, asking the clients to use HTTPS
          ingress.internal.namespace  tanzu-system-ingress                  string   Required. Specify a namespace where an existing Contour is installed on your cluster. CNR will use this Contour instance for internal services.
          ingress.external.namespace  tanzu-system-ingress                  string   Required. Specify a namespace where an existing Contour is installed on your cluster. CNR will use this Contour instance for external services.
          ingress_issuer                                                    string   Cluster issuer to be used in CNRs. To use this property the domain_name or domain_config must be set. Under the hood, when this property is set auto-tls is Enabled.
          namespace_selector                                                string   Specifies a LabelSelector which determines which namespaces should have a wildcard certificate provisioned. Set this property only if the Cluster issuer is type DNS-01 challenge.
          domain_config               <nil>                                 <nil>    Optional. Overrides the Knative Serving "config-domain" ConfigMap, allowing you to map Knative Services to specific domains. Must be valid YAML and conform to the "config-domain" specification.
          domain_template             \{{.Name}}.\{{.Namespace}}.\{{.Domain}}  string   Optional. Specifies the golang text template string to use when constructing the DNS name for a Knative Service.
          lite.enable                 false                                 <nil>    Optional. Set to "true" to enable lite mode. Reduces CPU and Memory resource requests for all cnrs Deployments, Daemonsets, and StatefulSets by half. Not recommended for production.
          pdb.enable                  true                                  <nil>    Optional. Set to true to enable a PodDisruptionBudget for the Knative Serving activator and webhook deployments.
          default_tls_secret                                                string   Optional. Specify a fallback TLS Certificate for use by Knative Services if autoTLS is disabled. Will set default exterenal scheme for Knative Service URLs to "https". Requires either "domain_name" or "domain_config" to be set.
          kubernetes_version          0.0.0                                 <nil>    Optional. Version of K8s infrastructure being used. Supported Values: valid Kubernetes major.minor.patch versions
          ca_cert_data                                                      string   Optional. PEM Encoded certificate data to trust TLS connections with a private CA.
          provider                    <nil>                                 <nil>    Deprecated. Instead, use "lite.enable" and "pdb.enable" options combined. Supported Values: local
          domain_name                                                       string   Optional. Default domain name for Knative Services.
          kubernetes_distribution     <nil>                                 <nil>    Optional. Type of K8s infrastructure being used. Supported Values: openshift
        ```

    1. Create a `cnr-values.yaml` by using the following sample as a guide:

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
        option. This option reduces resources requests for Cloud Native Runtimes deployments.

        Cloud Native Runtimes uses the existing Contour installation in the  `tanzu-system-ingress` namespace by default for external and internal access.

        If your environment has Contour installed already, and it is not the Tanzu Application Platform provided Contour, you can configure Cloud Native Runtimes to use it. See [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.2/tanzu-cloud-native-runtimes/contour.html) in the Cloud Native Runtimes documentation.

2. Install the package by running:

    ```console
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.2.0 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    ```

    For example:

    ```console
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 2.2.0 -n tap-install -f cnr-values.yaml --poll-timeout 30m
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```

    Use an empty file for `cnr-values.yaml` if you want the default installation configuration. Otherwise, see the earlier step to learn more about setting installation configuration values.

3. Verify the package install by running:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```

    For example:

    ```console
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc...
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         2.2.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

4. Configure a namespace to use Cloud Native Runtimes:

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
       Run these commands to create an empty secret and annotate it as a target of the secretgen
       controller:

        ```console
        kubectl create secret generic pull-secret --from-literal=.dockerconfigjson={} --type=kubernetes.io/dockerconfigjson
        kubectl annotate secret pull-secret secretgen.carvel.dev/image-pull-secret=""
        ```

    2. After you create a `pull-secret` secret in the same namespace as the service account,
    run the following command to add the secret to the service account:

        ```console
        kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "pull-secret"}]}'
        ```

    3. Verify that a service account is correctly configured by running:

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
