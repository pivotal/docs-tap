# <a id='installing'></a> Installing Part II: Packages

This document describes how to install Tanzu Application Platform packages
from the Tanzu Application Platform package repository.

Before you install the packages, ensure that you have completed the prerequisites, configured
and verified the cluster, accepted the EULA, and installed the Tanzu CLI and the package plugin.
For information, see [Installing Part I: Prerequisites, Cluster Configurations, EULA, and CLI](install-general.md).


## <a id='install-packages'></a> About Installing Packages

The parameters that are required for the installation need to be defined in a YAML file.

The required parameters for the individual packages can be identified by the values schema
that are defined in the package.
You can get these parameters by running the command
as described in the procedure below.

## <a id='add-package-repositories'></a> Add the Tanzu Application Platform Package Repository

To add the Tanzu Application Platform package repository:

1. Create a namespace called `tap-install` for deploying the packages of the components by running:
    ```
    kubectl create ns tap-install
    ```

    This namespace is to keep the objects grouped together logically.

2. Create a imagepullsecret:
    ```
    tanzu imagepullsecret add tap-registry --username TANZU-NET-USER --password TANZU-NET-PASSWORD --registry registry.tanzu.vmware.com --export-to-all-namespaces -n tap-install
    ```

    Where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

3. Add Tanzu Application Platform package repository to the cluster by running:

    ```
    tanzu package repository add tanzu-tap-repository --url TAP-REPO-IMGPKG -n tap-install
    ```

    Where TAP-REPO-IMGPKG is the Tanzu Application Platform repo bundle artifact reference.

    For example:
    ```
    $ tanzu package repository add tanzu-tap-repository --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0 -n tap-install
    \ Adding package repository 'tanzu-tap-repository'... 
    Added package repository 'tanzu-tap-repository'
    ```

5. Get status of the Tanzu Application Platform package repository, and ensure the status updates to `Reconcile succeeded` by running:

    ```
    tanzu package repository list -n tap-install
    ```
    For example:
    ```
    $ tanzu package repository list -n tap-install
    - Retrieving repositories...
      NAME                  REPOSITORY                                                         STATUS               DETAILS
      tanzu-tap-repository  registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:0.2.0  Reconcile succeeded
    ```

6. List the available packages by running:

    ```
    tanzu package available list -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list -n tap-install
    / Retrieving available packages...
      NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
      accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
      appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
      cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
    ```

7. List version information for the `cnrs.tanzu.vmware.com` package by running:
    ```
    tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    ```
    For example:
    ```
    $ tanzu package available list cnrs.tanzu.vmware.com -n tap-install
    - Retrieving package versions for cnrs.tanzu.vmware.com...
      NAME                   VERSION  RELEASED-AT
      cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
    ```


## <a id='general-procedure-to-install-a-package'></a> General Procedure to Install a Package

To install any package from the Tanzu Application Platform package repository:

1. Run:
    ```
    tanzu package available get PACKAGE-NAME/VERSION-NUMBER --values-schema -n tap-install
    ```

     Where:

     + `PACKAGE-NAME` is the name of the package listed in step 6 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.
     + `VERSION-NUMBER` is the version of the package listed in step 7 of
     [Add the Tanzu Application Platform Package Repository](#add-package-repositories) above.

    For example:
    ```
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    ```

2. Follow the specific installation instructions for each package:

    + [Install Cloud Native Runtimes](#install-cnr)
    + [Install Application Accelerator](#install-app-accelerator)
    + [Install Application Live View](#install-app-live-view)
    + [Install Supply Chain Security Tools - Store](#install-scst-store)
    + [Install Supply Chain Security Tools - Sign](#install-scst-sign)
    + [Install Supply Chain Security Tools - Scan](#install-scst-scan)
    + [Install API portal](#install-api-portal)
    + [Install SCP Toolkit](#install-scp-toolkit)


## <a id='install-cnr'></a> Install Cloud Native Runtimes

To install Cloud Native Runtimes:

1. Follow the instructions in [Install Packages](#install-packages) above.


    ```
    tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    ```
    For example:
    ```
    $ tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
    | Retrieving package details for cnrs.tanzu.vmware.com/1.0.1...
      KEY                         DEFAULT  TYPE             DESCRIPTION
      pdb.enable                  true     boolean  Optional: Set to true to enable Pod Disruption Budget. If provider local is set to "local", the PDB will be disabled automatically.
      provider                    <nil>    string   Optional: Kubernetes cluster provider. To be specified if deploying CNR on TKGs or on a local Kubernetes cluster provider.
      ingress.external.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for external services) if you want CNR to use your Contour instance.
      ingress.internal.namespace  <nil>    string   Optional: Only valid if a Contour instance already present in the cluster. Specify a namespace where an existing Contour is installed on your cluster (for internal services) if you want CNR to use your Contour instance.
      ingress.reuse_crds          false    boolean  Optional: Only valid if a Contour instance already present in the cluster. Set to "true" if you want CNR to re-use the cluster's existing Contour CRDs.
      local_dns.enable            false    boolean  Optional: Only for when "provider" is set to "local" and running on Kind. Set to true to enable local DNS.
      local_dns.domain            <nil>    string   Optional: Set a custom domain for the Knative services.
    ```

2. Gather the values schema.

3. Create a `cnr-values.yaml` using the following sample as a guide:

    Sample `cnr-values.yaml` for Cloud Native Runtimes:

    ```
    ---
    # if deploying on a local cluster such as Kind. Otherwise, you can use the defaults values to install CNR.
    provider: local
    ```

    In Tanzu Kubernetes Grid environments, Contour packages that are already been present might conflict
    with the Cloud Native Runtimes installation.
    For how to prevent conflicts,
    see [Installing Cloud Native Runtimes for Tanzu with an Existing Contour Installation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) in the Cloud Native Runtimes documentation.
    Then, in the `values.yaml` file, specify values for `ingress.reuse_crds`, `ingress.external.namespace`,
    and `ingress.internal.namespace` as appropriate.

    For a local Kubernetes cluster, set `provider: "local"`.
    For other infrastructures, do not set `provider`.

4. Install the package by running:

    ```
    tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f cnr-values.yaml
    ```
    For example:
    ```
    $ tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f cnr-values.yaml
    - Installing package 'cnrs.tanzu.vmware.com'
    | Getting package metadata for 'cnrs.tanzu.vmware.com'
    | Creating service account 'cloud-native-runtimes-tap-install-sa'
    | Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
    | Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
    ```
5. Verify the package install by running:
    
    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    ```
    For example:
    ```
    tanzu package installed get cloud-native-runtimes -n tap-install
    | Retrieving installation details for cc... 
    NAME:                    cloud-native-runtimes
    PACKAGE-NAME:            cnrs.tanzu.vmware.com
    PACKAGE-VERSION:         1.0.1
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be Reconcile succeeded.


## <a id='install-app-accelerator'></a> Install Application Accelerator

To install Application Accelerator:

**Prerequisite**: Flux installed on the cluster.
For how to install Flux,
see [Install Flux2](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.2/acc-docs/GUID-installation-install.html#install-flux2-2)
in the Application Accelerator documentation.

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Create an `app-accelerator-values.yaml` using the following sample as a guide:

    ```
    server:
      # Set this service_type to "NodePort" for local clusters like minikube.
      service_type: "LoadBalancer"
      watched_namespace: "default"
      engine_invocation_url: "http://acc-engine.accelerator-system.svc.cluster.local/invocations"
    engine:
      service_type: "ClusterIP"
    ```

4. Install the package by running:

    ```
    tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-accelerator-values.yaml
    ```
    For example:
    ```
    $ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.3.0 -n tap-install -f app-accelerator-values.yaml
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

5. Verify the package install by running:
    
    ```
    tanzu package installed get app-accelerator -n tap-install
    ```
    For example:
    ```
    tanzu package installed get app-accelerator -n tap-install
    | Retrieving installation details for cc... 
    NAME:                    app-accelerator
    PACKAGE-NAME:            accelerator.apps.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be Reconcile succeeded.

## <a id="install-app-live-view"></a>Install Application Live View

To install Application Live View:

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Gather the values schema.

3. Create a `app-live-view-values.yaml` using the following sample as a guide:

    Sample `app-live-view-values.yaml` for Application Live View:

    ```
    ---
    connector_namespaces: [foo, bar]
    server_namespace: tap-install
    ```
    The server_namespace is the namespace to which the Application Live View server is deployed. Typically you should pick the namespace you created earlier, tap-install. The connector_namespaces should be a list of namespaces in which you want Application Live View to monitor your apps. To each of those namespace an instance of the Application Live View Connector will be deployed.

4. Install the package by running:

    ```
    tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-live-view-values.yaml
    ```
    For example:
    ```
    $ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-live-view-values.yaml
    - Installing package 'appliveview.tanzu.vmware.com'
    | Getting package metadata for 'appliveview.tanzu.vmware.com'
    | Creating service account 'app-live-view-tap-install-sa'
    | Creating cluster admin role 'app-live-view-tap-install-cluster-role'
    | Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
    | Creating secret 'app-live-view-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'app-live-view' in namespace 'tap-install'
    ```

    For more information about Application Live View,
    see the [Application Live View documentation](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.1/docs/GUID-index.html).

5. Verify the package install by running:
    
    ```
    tanzu package installed get app-live-view -n tap-install
    ```
    For example:
    ```
    tanzu package installed get app-live-view -n tap-install
    | Retrieving installation details for cc... 
    NAME:                    app-live-view
    PACKAGE-NAME:            appliveview.tanzu.vmware.com
    PACKAGE-VERSION:         0.2.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:    
    ```
    STATUS should be Reconcile succeeded.


## <a id='install-scst-store'></a> Install Supply Chain Security Tools - Store

To install Supply Chain Security Tools - Store:

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```sh
    tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```

    For example:
    ```sh
    $ tanzu package available get scst-store.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for scst-store.tanzu.vmware.com/1.0.0-beta.0...
      KEY               DEFAULT              TYPE     DESCRIPTION
      auth_proxy_host   0.0.0.0              string   The binding ip address of the kube-rbac-proxy sidecar
      db_name           metadata-store       string   The name of the database to use.
      db_password                            string   The database user password.
      db_port           5432                 string   The database port to use. This is the port to use when connecting to the database pod.
      db_sslmode        verify-full          string   Determines the security connection between API server and Postgres database. This can be set to 'verify-ca' or 'verify-full'
      db_user           metadata-store-user  string   The database user to create and use for updating and querying. The metadata postgres section create this user. The metadata api server uses this username to connect to the database.
      api_host          localhost            string   The internal hostname for the metadata api endpoint. This will be used by the kube-rbac-proxy sidecar.
      api_port          9443                 integer  The internal port for the metadata app api endpoint. This will be used by the kube-rbac-proxy sidecar.
      app_service_type  NodePort             string   The type of service to use for the metadata app service. This can be set to 'Nodeport' or 'LoadBalancer'.
      auth_proxy_port   8443                 integer  The external port address of the of the kube-rbac-proxy sidecar
      db_host           metadata-postgres    string   The database hostname
      storageClassName  manual               string   The storage class name of the persistent volume used by Postgres database for storing data. The default value will use the default class name defined on the cluster.
      use_cert_manager  true                 string   Cert manager is required to be installed to use this flag. When true, this creates certificates object to be signed by cert manager for the API server and Postgres database. If false, the certificate object have to be provided by the user.
    ```

2. Gather the values schema.

3. Create a `scst-store-values.yaml` using the following sample as a guide:

    Sample `scst-store-values.yaml` for Supply Chain Security Tools - Store:

    ```yaml
    db_password: "password0123456"
    app_service_type: "LoadBalancer"
    ```

    Here, `app_service_type` has been set to `LoadBalancer`.
    If your environment does not support `LoadBalancer`, omit this line and it will use the default value `NodePort`.

4. Install the package by running:

    ```sh
    tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-store-values.yaml
    ```

    For example:
    ```sh
    $ tanzu package install metadata-store \
      --package-name scst-store.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-store-values.yaml

    - Installing package 'scst-store.tanzu.vmware.com'
    / Getting namespace 'tap-install'
    - Getting package metadata for 'scst-store.tanzu.vmware.com'
    / Creating service account 'metadata-store-tap-install-sa'
    / Creating cluster admin role 'metadata-store-tap-install-cluster-role'
    / Creating cluster role binding 'metadata-store-tap-install-cluster-rolebinding'
    / Creating secret 'metadata-store-tap-install-values'
    | Creating package resource
    - Package install status: Reconciling

    Added installed package 'metadata-store' in namespace 'tap-install'
    ```
## <a id='install-scst-sign'></a> Install Supply Chain Security Tools - Sign

To install Supply Chain Security Tools - Sign:

1. Follow the instructions in [Install Packages](#install-packages) above.
1. Gather the values schema
    ```
    tanzu package available get image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0 --values-schema
    | Retrieving package details for image-policy-webhook.signing.run.tanzu.vmware.com/1.0.0-beta.0...
      KEY                DEFAULT  TYPE     DESCRIPTION
      warn_on_unmatched  false    boolean  Feature flag for enabling admission of images that do not match 
                                           any patterns in the image policy configuration.
                                           Set to true to allow images that do not match any patterns into
                                           the cluster with a warning.

    ```
1. Create a file named `values.yaml` with `warn_on_unmatched` property.
   To warn the user when images do not match any pattern in the policy, but still allow them into the cluster,  set it to `true`.
   To deny images that do not match any pattern in the policy, set it to `false`

   ```yaml
   ---
   warn_on_unmatched: true 
   ```

1. Install the package:
   ```bash
   tanzu package install webhook \
     --package-name image-policy-webhook.signing.run.tanzu.vmware.com \
     --version 1.0.0-beta.0 \
     --namespace tap-install \
     --values-file values.yaml
    
    | Installing package 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Getting namespace 'default'
    | Getting package metadata for 'image-policy-webhook.signing.run.tanzu.vmware.com'
    | Creating service account 'webhook-default-sa'
    | Creating cluster admin role 'webhook-default-cluster-role'
    | Creating cluster role binding 'webhook-default-cluster-rolebinding'
    | Creating secret 'webhook-default-values'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'webhook' in namespace 'default'
   ```
1. After the webhook is up and running, create a service account named `registry-credentials` in the `image-policy-system` namespace. This is a required configuration even if the images and signatures are in public registries. 

1. If the registry or registries that hold your images and signatures are private,
you will need to provide the webhook with credentials to access your artifacts. Create your secrets to access those registries in the `image-policy-system`
namespace. These secrets should be added to the `registry-credentials` service account created above.

    For example:

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: registry-credentials
      namespace: image-policy-system
    imagePullSecrets:
    - name: secret1
    - name: secret2
    ...
    - name: secretn
    ```

1. You must also create a `ClusterImagePolicy` to inform the webhook which images it should validate.
   The cluster image policy is a custom resource definition containing the following information:
   - A list of namespaces to which the policy should not be enforced.
   - A list of public keys complementary to the private keys that were used to sign the images.
   - A list of image name patterns to which we want to enforce the policy, mapping to the public keys to use for each pattern.

   An example policy would look like this:
   ```yaml
   ---
   apiVersion: signing.run.tanzu.vmware.com/v1alpha1
   kind: ClusterImagePolicy
   metadata:
     name: image-policy
   spec:
     verification:
       exclude:
         resources:
           namespaces:
           - kube-system
       keys:
       - name: first-key
         publicKey: |
           -----BEGIN PUBLIC KEY-----
           <content ...>
           -----END PUBLIC KEY-----
       images:
       - namePattern: registry.example.org/myproject/*
         keys:
         - name: first-key
   ```

   As of this writing, the custom resource for the policy must have a name of `image-policy`.

   The platform operator should add to the `verification.exclude.resources.namespaces` section any namespaces that are known to run container images that are not currently signed, such as `kube-system`.

## <a id='install-scst-scan'></a> Install Supply Chain Security Tools - Scan

The installation for Supply Chain Security Tools – Scan involves installing two packages: Scan Controller and Grype Scanner.
Ensure both are installed.

To install Supply Chain Security Tools - Scan (Scan Controller):

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```
    
    For example:
    ```console
    $ tanzu package available get scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for scanning.apps.tanzu.vmware.com/1.0.0-beta.0...
      KEY                        DEFAULT                                                           TYPE    DESCRIPTION
      metadataStoreTokenSecret                                                                     string  Token Secret of the Insight Metadata Store deployed in the cluster
      metadataStoreUrl           https://metadata-store-app.metadata-store.svc.cluster.local:8443  string  Url of the Insight Metadata Store deployed in the cluster
      namespace                  scan-link-system                                                  string  Deployment namespace for the Scan Controller
      resources.limits.cpu       250m                                                              <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.limits.memory    256Mi                                                             <nil>   Limits describes the maximum amount of memory resources allowed.
      resources.requests.cpu     100m                                                              <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi                                                             <nil>   Requests describes the minimum amount of memory resources required.
      metadataStoreCa                                                                              string  CA Cert of the Insight Metadata Store deployed in the cluster
    ```
    
2. Gather the values schema.
3. Create a `scst-scan-controller-values.yaml` using the following sample as a guide: 
    
    Sample `scst-scan-controller-values.yaml` for Scan Controller:

    ```yaml
    ---
    metadataStoreUrl: https://metadata-store-app.metadata-store.svc.cluster.local:8443
    metadataStoreCa: |-
      -----BEGIN CERTIFICATE-----
      MIIC8TCCAdmgAwIBAgIRAIGDgx7Dk/2unVKuT9KXetUwDQYJKoZIhvcNAQELBQAw
      ...
      hOSbQ50VLo+YPF9NtTPRaS7QaIcFWot0EPwBMOCZR6Dd1HU6Qg==
      -----END CERTIFICATE-----
    metadataStoreTokenSecret: metadata-store-secret
    ```

    These values require the [Supply Chain Security Tools - Store](#install-scst-store) to have already been installed.
    The following code snippets show how to determine what these values are:

    The `metadataStoreUrl` value can be determined by:
    ```bash
    kubectl -n metadata-store get service -o name |
      grep app |
      xargs kubectl -n metadata-store get -o jsonpath='{.spec.ports[].name}{"://"}{.metadata.name}{"."}{.metadata.namespace}{".svc.cluster.local:"}{.spec.ports[].port}'
    ```

    The `metadataStoreCa` value can be determined by:
    ```bash
    kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d
    ```

    The `metadataStoreTokenSecret` is a reference to a secret that you will create and contains the Metadata Store token.
    The name of the secret is arbitrary, and for example, we will set it as "metadata-store-secret".

    The secret to be created and applied into the cluster is (ensure the namespace is created in the cluster before applying):
    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: <metadataStoreTokenSecret>
      namespace: scan-link-system
    type: kubernetes.io/opaque
    stringData:
      token: <METADATA_STORE_TOKEN>
    ```

    The `METADATA_STORE_TOKEN` value can be determined by:
    ```bash
    kubectl get secrets -n tap-install -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-tap-install-sa')].data.token}" | base64 -d
    ```

4. Install the package by running:

    ```bash
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    ```

    For example:
    ```console
    $ tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install \
      --values-file scst-scan-controller-values.yaml
    | Installing package 'scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'scanning.apps.tanzu.vmware.com'
    | Creating service account 'scan-controller-tap-install-sa'
    | Creating cluster admin role 'scan-controller-tap-install-cluster-role'
    | Creating cluster role binding 'scan-controller-tap-install-cluster-rolebinding'
    | Creating secret 'scan-controller-tap-install-values'
    / Creating package resource
    / Package install status: Reconciling

     Added installed package 'scan-controller' in namespace 'tap-install'
    ```

To install Supply Chain Security Tools - Scan (Grype Scanner):

1. Follow the instructions in [Install Packages](#install-packages) above.

    ```bash
    tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    ```
    For example:
    ```console
    $ tanzu package available get grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0 --values-schema -n tap-install
    | Retrieving package details for grype.scanning.apps.tanzu.vmware.com/1.0.0-beta.0...
      KEY                        DEFAULT  TYPE    DESCRIPTION
      namespace                  default  string  Deployment namespace for the Scan Templates
      resources.limits.cpu       1000m    <nil>   Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu     250m     <nil>   Requests describes the minimum amount of cpu resources required.
      resources.requests.memory  128Mi    <nil>   Requests describes the minimum amount of memory resources required.
    ```

2. The default values are appropriate for this package.
   If you want to change from the default values, use the Scan Controller instructions as a guide.

3. Install the package by running:

    ```bash
    tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install
    ```

    For example:
    ```console
    $ tanzu package install grype-scanner \
      --package-name grype.scanning.apps.tanzu.vmware.com \
      --version 1.0.0-beta.0 \
      --namespace tap-install
    / Installing package 'grype.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'grype.scanning.apps.tanzu.vmware.com'
    | Creating service account 'grype-scanner-tap-install-sa'
    | Creating cluster admin role 'grype-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'grype-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

     Added installed package 'grype-scanner' in namespace 'tap-install'
    ```

## <a id='install-api-portal'></a> Install API portal

1. Follow the instructions in [Install Packages](#install-packages) above.

2. Check what versions of API portal are available to install by running:
   ```bash
   tanzu package available list -n tap-install api-portal.tanzu.vmware.com
   ```

   For example:
   ```console
   $ tanzu package available list -n tap-install api-portal.tanzu.vmware.com
   - Retrieving package versions for api-portal.tanzu.vmware.com...
     NAME                         VERSION           RELEASED-AT
     api-portal.tanzu.vmware.com  1.0.2             2021-09-27T00:00:00Z
   ```

3. Create a container registry secret named `api-portal-image-pull-secret`.

   ```console
   $ kubectl create secret docker-registry api-portal-image-pull-secret -n tap-install \
     --docker-server=registry.tanzu.vmware.com \
     --docker-username=TANZU-NET-USER \
     --docker-password=TANZU-NET-PASSWORD
   secret/api-portal-image-pull-secret created
   ```
   - where `TANZU-NET-USER` and `TANZU-NET-PASSWORD` are your credentials for Tanzu Network.

4. Install API portal.
   
   ```console
   $ tanzu package install api-portal -n tap-install -p api-portal.tanzu.vmware.com -v 1.0.2
   
   / Installing package 'api-portal.tanzu.vmware.com'
   | Getting namespace 'api-portal'
   | Getting package metadata for 'api-portal.tanzu.vmware.com'
   | Creating service account 'api-portal-api-portal-sa'
   | Creating cluster admin role 'api-portal-api-portal-cluster-role'
   | Creating cluster role binding 'api-portal-api-portal-cluster-rolebinding'
   / Creating package resource
   - Package install status: Reconciling
   
   
    Added installed package 'api-portal' in namespace 'tap-install'
   ```

5. Visit [API portal for VMware Tanzu](https://docs.pivotal.io/api-portal/1-0/) for more information about API portal.

## <a id='install-scp-toolkit'></a> Install SCP Toolkit

**Prerequisite**: cert-manager installed on the cluster.
Please refer to the cert-manager [documentation](https://cert-manager.io/docs/) for information on how to install cert-manager.

To install SCP Toolkit:

1. Check what versions of SCP Toolkit are available to install by running:

   ```console
   tanzu package available list -n tap-install scp-toolkit.tanzu.vmware.com
   ```

   For example:

   ```console
   $ tanzu package available list -n tap-install scp-toolkit.tanzu.vmware.com
   - Retrieving package versions for scp-toolkit.tanzu.vmware.com...
     NAME                          VERSION           RELEASED-AT
     scp-toolkit.tanzu.vmware.com  0.3.0             2021-09-17T13:53:29Z
   ```

2. Install SCP Toolkit.

   ```console
   $ tanzu package install scp-toolkit -n tap-install -p scp-toolkit.tanzu.vmware.com -v 0.3.0
   / Installing package 'scp-toolkit.tanzu.vmware.com'
   | Getting namespace 'scp-toolkit'
   | Getting package metadata for 'scp-toolkit.tanzu.vmware.com'
   | Creating service account 'scp-toolkit-scp-toolkit-sa'
   | Creating cluster admin role 'scp-toolkit-scp-toolkit-cluster-role'
   | Creating cluster role binding 'scp-toolkit-scp-toolkit-cluster-rolebinding'
   / Creating package resource
   - Package install status: Reconciling


    Added installed package 'scp-toolkit' in namespace 'tap-install'
   ```

3. Verify the package install by running:

    ```console
    tanzu package installed get scp-toolkit -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get scp-toolkit -n tap-install
    | Retrieving installation details for cc...
    NAME:                    scp-toolkit
    PACKAGE-NAME:            scp-toolkit.tanzu.vmware.com
    PACKAGE-VERSION:         0.3.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True  }]
    USEFUL-ERROR-MESSAGE:
    ```

    STATUS should be Reconcile succeeded.

## <a id='verify'></a> Verify the Installed Packages

To verify that the packages are installed:

1. List the installed packages by running:
    ```
    tanzu package installed list -n tap-install
    ```
    For example:
    ```
    $ tanzu package installed list -n tap-install
    \ Retrieving installed packages...
      NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS
      app-accelerator        accelerator.apps.tanzu.vmware.com  0.3.0            Reconcile succeeded
      app-live-view         appliveview.tanzu.vmware.com        0.2.0            Reconcile succeeded
      cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded
    ```
