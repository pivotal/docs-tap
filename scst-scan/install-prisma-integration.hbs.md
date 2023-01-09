# Install Prisma Scanner

>**Note** This integration is in Alpha, which means that it is still in active
>development by the Tanzu Practices Global Tech Team and may be subject to
>change at any point. Users may encounter unexpected behavior. VMware would like
>to hear your feedback if you use this integration.

## Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to
your own container image registry before installing. If you don’t relocate the
images, Prisma Scanner Installation depends on VMware Tanzu Network for
continued operation, and VMware Tanzu Network offers no uptime guarantees. The
option to skip relocation is documented for evaluation and proof-of-concept
only.

The supported registries are Harbor, Azure Container Registry, Google Container Registry, and Quay.io. For information about how to set up a registry, see:

- [Harbor documentation](https://goharbor.io/docs/2.5.0/)
- [Google Container Registry documentation](https://cloud.google.com/container-registry/docs)
- [Quay.io documentation](https://docs.projectquay.io/welcome.html)

To relocate images from the VMware Tanzu Network registry to your registry:

1. Install Docker if it is not already installed.

1. Log in to your image registry by running:

    ```
    docker login MY-REGISTRY
    ```

    Where `MY-REGISTRY` is your own container registry.

1. Log in to the VMware Tanzu Network registry with your VMware Tanzu Network credentials by running:

    ```
    docker login registry.tanzu.vmware.com
    ```

4. Set up environment variables for installation by running:

    ```
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    * `MY-REGISTRY-USER` is the user with write access to MY-REGISTRY.
    * `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    * `MY-REGISTRY` is your own container registry.
    * `VERSION` is your Prisma Scanner version. For example, `0.1.0-beta.8`.
    * `TARGET-REPOSITORY` is your target repository, a folder/repository on `MY-REGISTRY` that serves as the location for the installation files for Prisma Scanner.

1. [Install the Carvel tool imgpkg CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.4/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path-6).

1. Relocate the images with the imgpkg CLI by running:

    ```
    imgpkg copy -b projects.registry.vmware.com/tap-scanners-package/prisma-repo-scanning-bundle:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/prisma-repo-scanning-bundle
    ```

## Add the Prisma Scanner package repository

Tanzu CLI packages are available on repositories. Adding the Prisma Scanning
package repository makes the Prisma Scanning bundle and its packages available
for installation.

> **Note**
> VMware recommends, but does not require, relocating images to a registry for installation. This section assumes you relocated images to a registry. Refer to the earlier section to fill in the variables.

VMware recommends installing the Prisma Scanner objects in the existing `tap-install` namespace to keep the Prisma Scanner grouped logically with the other Tanzu Application Platform components.

1. Add the Prisma Scanner package repository to the cluster by running:

    ```console
    tanzu package repository add prisma-scanner-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/prisma-repo-scanning-bundle:$VERSION \
      --namespace tap-install
    ```

1. Get the status of the Prisma Scanner package repository, and ensure the status updates to Reconcile succeeded by running:

    ```console
    tanzu package repository get prisma-scanning-repository --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package repository get prisma-scanning-repository --namespace tap-install
    - Retrieving repository prisma-scanner-repository...
    NAME:          prisma-scanner-repository
    VERSION:       71091125
    REPOSITORY:    index.docker.io/tapsme/prisma-repo-scanning-bundle
    TAG:           0.1.0-beta.8
    STATUS:        Reconcile succeeded
    REASON:
    ```

1. List the available packages by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      prisma.scanning.apps.tanzu.vmware.com                Prisma for Supply Chain Security Tools - Scan                             Default scan templates using Prisma
    ```

## Prerequisites for Prisma Scanner (Beta)

This topic describes prerequisites for installing Supply Chain Security Tools - Scan (Prisma) from the VMware package repository.

### Prepare the Prisma Scanner configuration

To prepare the Prisma configuration before you install any scanners:

1. Obtain a Prisma Token from Prisma.

1. Create a Prisma secret YAML file and insert the base64 encoded Prisma API token into the `prisma_token`:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: PRISMA-TOKEN-SECRET
      namespace: MY-APPS
    data:
      prisma_token: BASE64-PRISMA-API-TOKEN
    ```

    Where:

    - `PRISMA-TOKEN-SECRET` is the name of your Prisma token secret.
    - `MY-APPS` is the namespace you want to use.
    - `BASE64-PRISMA-API-TOKEN` is the name of your base64 encoded Prisma API token.

1. Apply the Prisma secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Prisma secret YAML file you created.

1. Define the `--values-file` flag to customize the default configuration. You must define the following fields in the `values.yaml` file for the Prisma Scanner configuration. You can add fields as needed to activate or deactivate behaviors. You can append the values to this file as shown later in this document. Create a `values.yaml` file by using the following configuration:

    ```yaml
    ---
    namespace: DEV-NAMESPACE
    targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
    prisma:
      url: PRISMA-URL
      tokenSecret:
        name: PRISMA-CONFIG-SECRET
    ```

  Where:

  - `DEV-NAMESPACE` is your developer namespace.
    > **Note:** To use a namespace other than the default namespace, ensure that
    > the namespace exists before you install. If the namespace does not exist,
    > the scanner installation fails.
  - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
    credentials to pull an image from a private registry for scanning.
  - `PRISMA-URL` is the FQDN of your Twistlock server.
  - `PRISMA-CONFIG-SECRET` is the name of the secret you created that contains the
    Prisma configuration to connect to Prisma. This field is required.

The Prisma integration can work with or without the SCST - Store integration.
The values.yaml file is slightly different for each configuration.

### Supply Chain Security Tools - Store integration

Using Supply Chain Security Tools - Store Integration: To persist the results found by the Prisma Scanner, you can enable the Supply Chain Security Tools - Store integration by appending the fields to the values.yaml file.

The Grype, Snyk, and Prisma Scanner Integrations enable the Metadata Store. To prevent conflicts, the configuration values are slightly different based on whether the Grype Scanner Integration is installed or not. If Tanzu Application Platform is installed using the Full Profile, the Grype Scanner Integration is installed, unless it is explicitly excluded.

If the Grype or Snyk Scanner Integration is installed in the same dev-namespace Prisma Scanner is installed:

```yaml
#! ...
metadataStore:
  #! The url where the Store deployment is accessible.
  #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
  url: "STORE-URL"
  caSecret:
    #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
    #! Default value is: "app-tls-cert"
    name: "CA-SECRET-NAME"
    importFromNamespace: "" #! since both Prisma and Grype/Snyk both enable store, one must leave importFromNamespace blank
  #! authSecret is for multicluster configurations.
  authSecret:
    #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
    name: "AUTH-SECRET-NAME"
    importFromNamespace: "" #! since both Prisma and Grype/Snyk both enable store, one must leave importFromNamespace blank
```

Where:

- `STORE-URL` is the URL where the Store deployment is accessible.
- `CA-SECRET-NAME` is the name of the secret that contains the ca.crt to connect
  to the Store Deployment. Default is `app-tls-cert`.
- `AUTH-SECRET-NAME` is the name of the secret that contains the auth token to
  authenticate to the Store Deployment.

If the Grype/Snyk Scanner Integration is not installed in the same dev-namespace Prisma Scanner is installed:

```yaml
#! ...
metadataStore:
  #! The url where the Store deployment is accessible.
  #! Default value is: "https://metadata-store-app.metadata-store.svc.cluster.local:8443"
  url: "STORE-URL"
  caSecret:
    #! The name of the secret that contains the ca.crt to connect to the Store Deployment.
    #! Default value is: "app-tls-cert"
    name: "CA-SECRET-NAME"
    #! The namespace where the secrets for the Store Deployment live.
    #! Default value is: "metadata-store"
    importFromNamespace: "STORE-SECRETS-NAMESPACE"
  #! authSecret is for multicluster configurations.
  authSecret:
    #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
    name: "AUTH-SECRET-NAME"
    #! The namespace where the secrets for the Store Deployment live.
    importFromNamespace: "STORE-SECRETS-NAMESPACE"
```

Where:

- `STORE-URL` is the url where the Store deployment is accessible.
- `CA-SECRET-NAME` is the name of the secret that contains the ca.crt to connect to the Store Deployment. Default is `app-tls-cert`.
- `STORE-SECRETS-NAMESPACE` is the namespace where the secrets for the Store Deployment live. Default is `metadata-store`.
- `AUTH-SECRET-NAME` is the name of the secret that contains the auth token to authenticate to the Store Deployment.

**Without Supply Chain Security Tools - Store Integration:** If you don’t want to enable the Supply Chain Security Tools - Store integration, explicitly deactivate the integration by appending the following fields to the values.yaml file that is enabled by default:

```yaml
# ...
metadataStore:
  url: "" # Configuration is moved, so set this string to empty
```

### Sample ScanPolicy for CycloneDX Format
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
  name: prisma-scan-policy
  labels:
    'app.kubernetes.io/part-of': 'enable-in-gui'
spec:
  regoFile: |
    package main

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
    ignoreCves := []

    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }

    isSafe(match) {
      severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
      some i
      fails := contains(notAllowedSeverities, severities[i])
      not fails
    }

    isSafe(match) {
      ignore := contains(ignoreCves, match.id)
      ignore
    }

    deny[msg] {
      comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
      some i
      comp := comps[i]
      vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
      some j
      vuln := vulns[j]
      ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
      not isSafe(vuln)
      msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
    }
```

Apply the YAML:

```console
kubectl apply -n $DEV-NAMESPACE -f SCAN-POLICY-YAML
```

Where:

- `DEV-NAMESPACE` is the name of the developer namespace you want to use.
- `SCAN-POLICY-YAML` is the name of your SCST - Scan YAML.

## Install Another Scanner for Supply Security Tools - Scan (Prisma)

This topic describes how to install scanners to work with Supply Chain Security Tools - Scan from the VMware package repository.

Follow the below instructions to install a scanner other than the out of the box Grype Scanner.

### Prerequisites

Before installing a new scanner, install Supply Chain Security Tools - Scan. It must be present on the same cluster. The prerequisites for Scan are also required.

### Install
To install a new scanner, follow these steps:

1. List the available packages to discover what scanners you can use by running:

    ```console
    tanzu package available list --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list --namespace tap-install
    / Retrieving available packages...
      NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
      grype.scanning.apps.tanzu.vmware.com                 Grype Scanner for Supply Chain Security Tools - Scan                      Default scan templates using Anchore Grype
      snyk.scanning.apps.tanzu.vmware.com                  Snyk for Supply Chain Security Tools - Scan                               Default scan templates using Snyk
      carbonblack.scanning.apps.tanzu.vmware.com           Carbon Black Scanner for Supply Chain Security Tools - Scan               Default scan templates using Carbon Black
      prisma.scanning.apps.tanzu.vmware.com                Prisma for Supply Chain Security Tools - Scan                             Default scan templates using Prisma
    ```

1. List version information for the scanner package by running:

    ```console
    tanzu package available list SCANNER-NAME --namespace tap-install
    ```

    For example:

    ```console
    $ tanzu package available list prisma.scanning.apps.tanzu.vmware.com --namespace tap-install
    / Retrieving package versions for prisma.scanning.apps.tanzu.vmware.com...
      NAME                                  VERSION           RELEASED-AT
      prisma.scanning.apps.tanzu.vmware.com   0.1.0-beta.8
    ```

1. (Optional) Confirm that the `prisma-token-secret` secret has been created.

1. Create a `values.yaml` to apply custom configurations to the scanner:

    To list the values you can configure for any scanner, run:

    ```console
    tanzu package available get SCANNER-NAME/VERSION --values-schema -n tap-install
    ```

    Where:

    * `SCANNER-NAME` is the name of the scanner package you retrieved earlier.
    * `VERSION` is your package version number. For example, `prisma.scanning.apps.tanzu.vmware.com/0.1.0-beta.8`.

    For example:

    ```console
    $ tanzu package available get prisma.scanning.apps.tanzu.vmware.com/0.1.0-beta.8 --values-schema -n tap-install

      KEY                                           DEFAULT                                                           TYPE    DESCRIPTION
      prisma.tokenSecret.name                       prisma-token                                                      string  Reference to the secret named prisma-token containing a Prisma API Token set as
                                                                                                                              prisma_token
      prisma.url                                                                                                      string  Twistlock server url (https://twistlock.example.com:8083)
      prisma.caCertConfigMap.name                                                                                     string  Reference to the configmap containing the registry ca cert set as ca_cert_data
      prisma.projectName                                                                                              string  Twistlock target project
      resources.limits.cpu                          1000m                                                             string  Limits describes the maximum amount of cpu resources allowed.
      resources.requests.cpu                        250m                                                              string  Requests describes the minimum amount of cpu resources required.
      resources.requests.memory                     128Mi                                                             string  Requests describes the minimum amount of memory resources
      scanner.docker.password                                                                                         string  <nil>
      scanner.docker.server                                                                                           string  <nil>
      scanner.docker.username                                                                                         string  <nil>
      scanner.pullSecret                                                                                              string  <nil>
      scanner.serviceAccount                        prisma-scanner                                                    string  Name of scan pod's service ServiceAccount
      scanner.serviceAccountAnnotations                                                                               string  Annotations added to ServiceAccount
      targetImagePullSecret                                                                                           string  Reference to the secret used for pulling images from private
      metadataStore.authSecret.importFromNamespace                                                                    string  Namespace from which to import the Insight Metadata Store auth_token
      metadataStore.authSecret.name                                                                                   string  Name of deployed Secret with key auth_token
      metadataStore.caSecret.importFromNamespace    metadata-store                                                    string  Namespace from which to import the Insight Metadata Store CA Cert
      metadataStore.caSecret.name                   app-tls-cert                                                      string  Name of deployed Secret with key ca.crt holding the CA Cert of the Insight
                                                                                                                              Metadata Store
      metadataStore.clusterRole                     metadata-store-read-write                                         string  Name of the deployed ClusterRole for read/write access to the Insight Metadata
                                                                                                                              Store deployed in the same cluster
      metadataStore.url                             https://metadata-store-app.metadata-store.svc.cluster.local:8443  string  Url of the Insight Metadata Store
      namespace                                     default                                                           string  Deployment namespace for the Scan Templates
    ```

1. Define the `--values-file` flag to customize the default configuration:

    The `values.yaml` file you created earlier is referenced with the `--values-file` flag when running your Tanzu install command:

    ```console
    tanzu package install REFERENCE-NAME \
      --package-name SCANNER-NAME \
      --version VERSION \
      --namespace tap-install \
      --values-file PATH-TO-VALUES-YAML
    ```

    Where:

    * `REFERENCE-NAME` is the name referenced by the installed package. For example, `prisma-scanner`.
    * `SCANNER-NAME` is the name of the scanner package you retrieved earlier. For example, `prisma.scanning.apps.tanzu.vmware.com`.
    * `VERSION` is your package version number. For example, `0.1.0-beta.8`.
    * `PATH-TO-VALUES-YAML` is the path that points to the `values.yaml` file created earlier.

    For example:

    ```console
    $ tanzu package install prisma-scanner \
      --package-name primsa.scanning.apps.tanzu.vmware.com \
      --version 0.1.0-beta.8 \
      --namespace tap-install \
      --values-file values.yaml
    / Installing package 'prisma.scanning.apps.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'prisma.scanning.apps.tanzu.vmware.com'
    | Creating service account 'prisma-scanner-tap-install-sa'
    | Creating cluster admin role 'prisma-scanner-tap-install-cluster-role'
    | Creating cluster role binding 'prisma-scanner-tap-install-cluster-rolebinding'
    / Creating package resource
    - Package install status: Reconciling

    Added installed package 'prisma-scanner' in namespace 'tap-install'
    ```

### Verify Installation

To verify the installation create an `ImageScan` or `SourceScan` referencing one of the newly added `ScanTemplates` for the scanner.

1. (Optional) Create a `ScanPolicy` formatted for the output specific to the scanner you are installing, to reference in the `ImageScan` or `SourceScan`.

    ```console
    kubectl apply -n $DEV_NAMESPACE -f SCAN-POLICY-YAML
    ```

    Where:

    - `DEV-NAMESPACE` is the name of the developer namespace you want to use.
    - `SCAN-POLICY-YAML` is the name of your SCST - Scan YAML.

    > **Note:**
    > As vulnerability scanners output different formats, the `ScanPolicies` can vary. For more information about policies and samples, see [Enforce compliance policy using Open Policy Agent](./policies.hbs.md).

2. Retrieve available `ScanTemplates` from the namespace where the scanner is installed:

    ```console
    kubectl get scantemplates -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the developer namespace where the scanner is installed.

    For example:

    ```console
    $ kubectl get scantemplates
    NAME                                AGE
    prisma-blob-source-scan-template    10d
    primsa-public-source-scan-template  10d
    prisma-private-image-scan-template  10d
    prisma-public-image-scan-template   10d
    prisma-private-source-scan-template 10d
    ```

1. Create the following ImageScan YAML:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-scanner-public-image-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: SCAN-TEMPLATE
      scanPolicy: SCAN-POLICY # Optional
    ```

    Where:

    * `SCAN-TEMPLATE` is the name of the installed `ScanTemplate` in the `DEV-NAMESPACE` you retrieved earlier.
    * `SCAN-POLICY` is an optional reference to an existing `ScanPolicy` in the same `DEV-NAMESPACE`.

    For example:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ImageScan
    metadata:
      name: sample-prisma-public-image-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: prisma-public-image-scan-template
      scanPolicy: prisma-scan-policy
    ```

1. Create the following SourceScan YAML:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-scanner-public-source-scan
    spec:
      registry:
        image: "nginx:1.16"
      scanTemplate: SCAN-TEMPLATE
      scanPolicy: SCAN-POLICY # Optional
    ```

    Where:

    * `SCAN-TEMPLATE` is the name of the installed ScanTemplate in the `DEV-NAMESPACE` you retrieved earlier.
    * `SCAN-POLICY` it’s an optional reference to an existing ScanPolicy in the same `DEV-NAMESPACE`.

    For example:

    ```yaml
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: SourceScan
    metadata:
      name: sample-prisma-public-source-scan
    spec:
      git:
        url: "https://github.com/houndci/hound.git"
        revision: "5805c650"
      scanTemplate: prisma-public-source-scan-template
      scanPolicy: scan-policy
    ```


2. Apply the ImageScan and Source YAMLs:

    To run the scans, apply them to the cluster by running these commands:

    `ImageScan`:

    ```console
    kubectl apply -f PATH-TO-IMAGE-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-IMAGE-SCAN-YAML` is the path to the YAML file created earlier.

    `SourceScan`:

    ```console
    kubectl apply -f PATH-TO-SOURCE-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-SOURCE-SCAN-YAML` is the path to the YAML file created earlier.

    For example:

    ```console
    $ kubectl apply -f imagescan.yaml -n my-apps
    imagescan.scanning.apps.tanzu.vmware.com/sample-prisma-public-image-scan created

    $ kubectl apply -f sourcescan.yaml -n my-apps
    sourcescan.scanning.apps.tanzu.vmware.com/sample-prisma-public-source-scan created
    ```

1. To verify the integration, get the scan to see if it completed by running:

    For `ImageScan`:

    ```console
    kubectl get imagescan IMAGE-SCAN-NAME -n DEV-NAMESPACE
    ```

    Where `IMAGE-SCAN-NAME` is the name of the `ImageScan` as defined in the YAML file created earlier.

    For `SourceScan`:

    ```console
    kubectl get sourcescan SOURCE-SCAN-NAME -n DEV-NAMESPACE
    ```

    Where SOURCE-SCAN-NAME is the name of the SourceScan as defined in the YAML file created earlier.

    For example:

    ```console
    $ kubectl get imagescan sample-prisma-public-image-scan -n my-apps
    NAME                            PHASE       SCANNEDIMAGE   AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sample-primsa-public-image-scan   Completed   nginx:1.16     26h   0          114    58       314   0         486

    $ kubectl get sourcescan sample-prisma-public-source-scan -n my-apps
    NAME                                                                      PHASE       SCANNEDREVISION   SCANNEDREPOSITORY                      AGE     CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sourcescan.scanning.apps.tanzu.vmware.com/prisma-sourcescan-sample-public   Completed   5805c650          https://github.com/houndci/hound.git   8m34s   21         121    112      9
    ```

    > **Note:**
    > If you define a `ScanPolicy` for the scans and the evaluation finds a violation, the `Phase` is `Failed` instead of `Completed`. In both cases the scan finished successfully.

1. Clean up:

    ```console
    kubectl delete -f PATH-TO-SCAN-YAML -n DEV-NAMESPACE
    ```

    Where `PATH-TO-SCAN-YAML` is the path to the YAML file created earlier.

### Configure Tanzu Application Platform Supply Chain to use new scanner

In order to scan your images with the new scanner installed in the [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md), you must update your Tanzu Application Platform installation.

Add the `ootb_supply_chain_testing_scanning.scanning` section to your `tap-values.yaml` and perform a [Tanzu Application Platform update](../upgrading.hbs.md#perform-the-upgrade-of-tanzu-application-platform).

In this file you can define which `ScanTemplates` is used for both `SourceScan` and `ImageScan`. The default values are the Grype Scanner `ScanTemplates`, but it can be overwritten by any other `ScanTemplate` present in your `DEV-NAMESPACE`. The same applies to the `ScanPolicies` applied to each kind of scan.

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: IMAGE-SCAN-TEMPLATE
      policy: IMAGE-SCAN-POLICY
    source:
      template: SOURCE-SCAN-TEMPLATE
      policy: SOURCE-SCAN-POLICY
```

> **Note:**
> For the Supply Chain to work properly, the `SOURCE-SCAN-TEMPLATE` must support blob files and the `IMAGE-SCAN-TEMPLATE` must support private images.

For example:

```yaml
ootb_supply_chain_testing_scanning:
  scanning:
    image:
      template: prisma-private-image-scan-template
      policy: prisma-scan-policy
    source:
      template: prisma-blob-source-scan-template
      policy: scan-policy
```

### Uninstall Scanner

To replace the scanner in the Supply Chain, follow the steps mentioned in [Configure TAP Supply Chain to Use New Scanner](#configure-tanzu-application-platform-supply-chain-to-use-new-scanner). After the scanner is no longer required by the Supply Chain, you can remove the package by running:

```console
tanzu package installed delete REFERENCE-NAME \
    --namespace tap-install
```

Where `REFERENCE-NAME` is the name you identified the package with, when installing in the [Install](#install-another-scanner-for-supply-security-tools---scan-prisma) section. For example, `prisma-scanner`.

For example:

```console
$ tanzu package installed delete prisma-scanner \
    --namespace tap-install
```
