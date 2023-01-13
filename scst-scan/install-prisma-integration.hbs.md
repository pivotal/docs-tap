# Prerequisites for Prisma Scanner (Alpha)

This topic describes prerequisites for installing SCST - Scan (Prisma) from the VMware package repository.

>**Note** This integration is in Alpha, which means that it is still in active
>development by the Tanzu Practices Global Tech Team and might be subject to
>change at any point. Users might encounter unexpected behavior.

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

2. Log in to your container image registry by running:

    ```console
    docker login MY-REGISTRY
    ```

    Where `MY-REGISTRY` is your own registry.

3. Log in to the VMware Tanzu Network registry with your VMware Tanzu Network credentials by running:

    ```console
    docker login registry.tanzu.vmware.com
    ```

4. Set up environment variables for installation by running:

    ```console
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    - `MY-REGISTRY-USER` is the user with write access to MY-REGISTRY.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is your own registry.
    - `VERSION` is your Prisma Scanner version. For example, `0.1.4-alpha.3`.
    - `TARGET-REPOSITORY` is your target repository, a directory or repository on `MY-REGISTRY` that serves as the location for the installation files for Prisma Scanner.

5. [Install the Carvel tool imgpkg CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.4/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path-6).

6. Relocate the images with the imgpkg CLI by running:

    ```console
    imgpkg copy -b projects.registry.vmware.com/tanzu_practice/tap-scanners-package/prisma-repo-scanning-bundle:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/prisma-repo-scanning-bundle
    ```

## Add the Prisma Scanner package repository

Tanzu CLI packages are available on repositories. Adding the Prisma Scanning
package repository makes the Prisma Scanning bundle and its packages available
for installation.

> **Note**
> VMware recommends, but does not require, relocating images to a registry for installation. This section required that you relocate images to a registry. See the earlier section to fill in the variables.

VMware recommends installing the Prisma Scanner objects in the existing `tap-install` namespace to keep the Prisma Scanner grouped logically with the other Tanzu Application Platform components.

1. Add the Prisma Scanner package repository to the cluster by running:

    ```console
    tanzu package repository add prisma-scanner-repository \
      --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/prisma-repo-scanning-bundle:$VERSION \
      --namespace tap-install
    ```

1. Get the status of the Prisma Scanner package repository, and ensure that the status updates to Reconcile succeeded by running:

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
    TAG:           0.1.4-alpha.3
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

## Prepare the Prisma Scanner configuration

To prepare the Prisma configuration before you install any scanners:

1. Obtain your Prisma Compute Console url and Access Keys and Token. See [Access keys](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/authentication/access_keys) in the Prisma documentation. 
   >**Note** Generated tokens expire after an hour.
2. Create a Prisma secret YAML file and insert the base64 encoded Prisma API token into the `prisma_token`:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: PRISMA-TOKEN-SECRET
      namespace: APP-NAME
    data:
      prisma_token: BASE64-PRISMA-API-TOKEN
    ```

    Where:

    - `PRISMA-TOKEN-SECRET` is the name of your Prisma token secret.
    - `APP-NAME` is the namespace you want to use.
    - `BASE64-PRISMA-API-TOKEN` is the name of your base64 encoded Prisma API token.

3. Apply the Prisma secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Prisma secret YAML file you created.

4. Define the `--values-file` flag to customize the default configuration. You
   must define the following fields in the `values.yaml` file for the Prisma
   Scanner configuration. You can add fields as needed to activate or deactivate
   behaviors. You can append the values to this file as shown later in this
   topic. Create a `values.yaml` file by using the following configuration:

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
    > **Note** To use a namespace other than the default namespace, ensure that
    > the namespace exists before you install. If the namespace does not exist,
    > the scanner installation fails.
  - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
    credentials to pull an image from a private registry for scanning.
  - `PRISMA-URL` is the FQDN of your Twistlock server.
  - `PRISMA-CONFIG-SECRET` is the name of the secret you created that contains the
    Prisma configuration to connect to Prisma. This field is required.

The Prisma integration can work with or without the SCST - Store integration.
The values.yaml file is slightly different for each configuration.

## Supply Chain Security Tools - Store integration

When using SCST - Store integration, to persist the results
found by the Prisma Scanner, you can enable the SCST -
Store integration by appending the fields to the `values.yaml` file.

The Grype, Snyk, and Prisma Scanner Integrations enable the Metadata Store. To
prevent conflicts, the configuration values are slightly different based on
whether the Grype Scanner Integration is installed or not. If Tanzu Application
Platform is installed using the Full Profile, the Grype Scanner Integration is
installed, unless it is explicitly excluded.

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
- `AUTH-SECRET-NAME` is the name of the secret that contains the authentication token to
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

- `STORE-URL` is the URL where the Store deployment is accessible.
- `CA-SECRET-NAME` is the name of the secret that contains the ca.crt to connect to the Store Deployment. Default is `app-tls-cert`.
- `STORE-SECRETS-NAMESPACE` is the namespace where the secrets for the Store Deployment live. Default is `metadata-store`.
- `AUTH-SECRET-NAME` is the name of the secret that contains the authentication token to authenticate to the Store Deployment.

**Without Supply Chain Security Tools - Store Integration:** If you don’t want
to enable the SCST - Store integration, explicitly deactivate the integration by
appending the following fields to the values.yaml file that is enabled by
default:

```yaml
# ...
metadataStore:
  url: "" # Configuration is moved, so set this string to empty
```

## Sample ScanPolicy for CycloneDX Format

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

## Install Prisma Scanner

After all prerequisites are completed, install the Prisma Scanner. See [Install another scanner for Supply Chain Security Tools - Scan](install-scanners.hbs.md).

## Known Limitations

- AWS ECR is not supported.
- OpenShift is not supported.