# Install Trivy (alpha)

This topic describes how to install SCST - Scan (Trivy) from the VMware package repository.

>**Important** This integration is in Alpha, which means that it is still in active
>development by the Tanzu Practice Global Tech Team and might be subject to
>change at any point. Users might encounter unexpected behavior.

## <a id='verify'></a> Verify the latest alpha package version

Run the following command to output a list of available tags.

```shell
imgpkg tag list -i projects.registry.vmware.com/tanzu_practice/tap-scanners-package/trivy-repo-scanning-bundle | sort -V
```

For example:

``` shell
imgpkg tag list -i projects.registry.vmware.com/tanzu_practice/tap-scanners-package/trivy-repo-scanning-bundle | sort -V

0.1.4-alpha.6
0.1.4-alpha.1
0.1.4-alpha.3
0.1.4-alpha.5
0.1.4-alpha.6
```

In this topic, use the latest version returned by the command above.

## <a id='relocate'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to
your own container image registry before installing.

Trivy is in the Alpha development phase, is not packaged as part of
the Tanzu Application Platform package, and is hosted on the VMware Project
Repository instead of VMware Tanzu Network. If you relocated the Tanzu
Application Platform images, you might also want to relocate the Trivy
package.

If you don’t relocate the images, Trivy installation depends on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no
uptime guarantees. The option to skip relocation is documented for evaluation
and proof-of-concept only.

For information about supported registries, see the registry's documentation.

To relocate images from the VMware Project Registry to your registry:

1. Install Docker if it is not already installed.

1. Set up environment variables for installation by running:

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
  - `VERSION` is your Trivy version. For example, `0.1.4-alpha.6`.
  - `TARGET-REPOSITORY` is your target repository, a directory or repository on
    `MY-REGISTRY` that serves as the location for the installation files for
    Trivy.

2. Install the Carvel tool imgpkg CLI. See [Deploying Cluster Essentials v1.4](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.4/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path-6).

3. Relocate the images with the imgpkg CLI by running:

  ```shell
  imgpkg copy -b projects.registry.vmware.com/tanzu_practice/tap-scanners-package/trivy-repo-scanning-bundle:${VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/trivy-repo-scanning-bundle
  ```

> **Note**
> The VMware project repository does not require authentication, so you don't need to perform a Docker login.

## <a id='trivy-repo'></a> Add Trivy package repository

Tanzu CLI packages are available on repositories. Adding the Trivy scanning
package repository makes the Trivy scanning bundle and its packages available
for installation.

> **Note** VMware recommends, but does not require, relocating images to a
> registry for installation. The following section requires that you relocated
> images to a registry. See the earlier section to fill in the variables.

VMware recommends installing Trivy objects in the existing `tap-install`
namespace to keep Trivy grouped logically with the other Tanzu Application
Platform components.

1. Add Trivy package repository to the cluster by running:

  ```shell
  tanzu package repository add trivy-scanner-repository \
    --url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/trivy-repo-scanning-bundle:$VERSION \
    --namespace tap-install
  ```

2. Get the status of Trivy package repository, and ensure that the status updates to `Reconcile succeeded` by running:

  ```shell
  tanzu package repository get trivy-scanner-repository --namespace tap-install
  ```

  For example:

  ```console
  tanzu package repository get trivy-scanner-repository --namespace tap-install

  NAME:          trivy-scanner-repository
  VERSION:       7750726
  REPOSITORY:    projects.registry.vmware.com/tanzu_practice/tap-scanners-package/trivy-repo-scanning-bundle
  TAG:           0.1.4-alpha.6
  STATUS:        Reconcile succeeded
  REASON:
  ```

3. List the available packages by running:

  ```shell
  tanzu package available list --namespace tap-install
  ```

  For example:

  ```console
  $ tanzu package available list --namespace tap-install
  / Retrieving available packages...
    NAME                                                 DISPLAY-NAME                       SHORT-DESCRIPTION
    trivy.scanning.apps.tanzu.vmware.com                   trivy                              Default scan templates using Trivy
  ```

## <a id='prepare'></a> Prepare Trivy configuration

Before installing the Trivy, you must create the configuration necessary to install Trivy.

1. Define the `--values-file` flag to customize the default configuration. You
must define the following fields in the `values.yaml` file for the Trivy Scanner
configuration. You can add fields as needed to activate or deactivate behaviors.
You can append the values to the `values.yaml` file. Create a `values.yaml` file
by using the following configuration:

  ```yaml
      ---
      namespace: DEV-NAMESPACE
      targetImagePullSecret: TARGET-REGISTRY-CREDENTIALS-SECRET
      targetSourceSshSecret: TARGET-SOURCE-SSH-SECRET
  ```

  Where:

  - `DEV-NAMESPACE` is your developer namespace.
  > **Note** To use a namespace other than the default namespace, ensure that
  the namespace exists before you install. If the namespace does not exist, the
  scanner installation fails.
  - `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains
  the credentials to pull an image from a private registry for scanning.
  - `TARGET-SOURCE-SSH-SECRET` is the name of the secret containing SSH
    credentials for cloning private repositories

1. To see all available values, run the following command using the version that you want:

  ```shell
  VERSION="0.1.4-alpha.6"
  tanzu package available get trivy.scanning.apps.tanzu.vmware.com/$VERSION --values-schema -n tap-install
  ```

  Example output:

  ```console
    KEY                                           DEFAULT                                                           TYPE    DESCRIPTION
    environmentVariables                          <nil>                                                             <nil>   Environment Variables you want added to the scan container to impact trivy behavior
    resources.limits.cpu                          1000m                                                             string  Limits describes the maximum amount of cpu resources allowed.
    resources.requests.cpu                        250m                                                              string  Requests describes the minimum amount of cpu resources required.
    resources.requests.memory                     128Mi                                                             string  Requests describes the minimum amount of memory resources
    scanner.docker.server                                                                                           string  <nil>
    scanner.docker.username                                                                                         string  <nil>
    scanner.docker.password                                                                                         string  <nil>
    scanner.pullSecret                                                                                              string  <nil>
    scanner.serviceAccount                        trivy-scanner                                                     string  Name of scan pod's service ServiceAccount
    scanner.serviceAccountAnnotations             <nil>                                                             <nil>   Annotations added to ServiceAccount
    trivy.cli.image.additionalArguments                                                                             string  additional arguments to be appended to the image scan command
    trivy.cli.plugins.aqua.repositoryUrl                                                                            string  location of the aqua plugin tar in an OCI registry to be used in place of the embedded version
    trivy.cli.repositoryUrl                                                                                         string  location of the CLI tar in an OCI registry to be used in place of the embedded version
    trivy.cli.source.additionalArguments                                                                            string  additional arguments to be appended to the fs scan command
    trivy.db.repositoryUrl                                                                                          string  location of the vulnerability database in an OCI registry to be used as the download location prior to running a scan
    caCertSecret                                                                                                    string  Reference to the secret containing the registry ca cert set as ca_cert_data
    metadataStore.authSecret.importFromNamespace                                                                    string  Namespace from which to import the Insight Metadata Store auth_token
    metadataStore.authSecret.name                                                                                   string  Name of deployed Secret with key auth_token
    metadataStore.caSecret.importFromNamespace    metadata-store                                                    string  Namespace from which to import the Insight Metadata Store CA Cert
    metadataStore.caSecret.name                   app-tls-cert                                                      string  Name of deployed Secret with key ca.crt holding the CA Cert of the Insight Metadata Store
    metadataStore.clusterRole                     metadata-store-read-write                                         string  Name of the deployed ClusterRole for read/write access to the Insight Metadata Store deployed in the same cluster
    metadataStore.url                             https://metadata-store-app.metadata-store.svc.cluster.local:8443  string  Url of the Insight Metadata Store
    namespace                                     default                                                           string  Deployment namespace for the Scan Templates
    targetImagePullSecret                                                                                           string  Reference to the secret used for pulling images from private registry
    targetSourceSshSecret                                                                                           string  Reference to the secret containing SSH credentials for cloning private repositories
  ```

## <a id='store-integration'></a> SCST - Store integration

Trivy integration can work with or without the SCST - Store integration. The
`values.yaml` file is slightly different for each configuration.

To persist the results found by the Trivy, enable the SCST -
Store integration by appending the SCST- scan fields to Trivy`values.yaml` file.

The Grype, Snyk, Prisma, Carbon Black, and Trivy integrations enable the Metadata Store. To
prevent conflicts, the configuration values are slightly different based on
whether another scanner integration is installed or not. If Tanzu Application
Platform is installed using the Full Profile, the Grype Scanner Integration is
installed unless it is explicitly excluded.

### <a id='multiple-scan'></a> Multiple scanners installed

When installing Trivy, find your CA secret name and authentication token secret
name for your `values.yaml` ny looking at the configuration of a prior installed
scanner in the same namespace as it already exists.

For information about how the scanner was initially created, see [Multicluster Setup](../scst-store/multicluster-setup.hbs.md).

The following example `values.yaml` has other scanners already installed in the
same `dev-namespace` where Trivy is installed:

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
    importFromNamespace: "" #! since both Trivy and Grype/Snyk both enable store, one must leave importFromNamespace blank
  #! authSecret is for multicluster configurations.
  authSecret:
    #! The name of the secret that contains the auth token to authenticate to the Store Deployment.
    name: "AUTH-SECRET-NAME"
    importFromNamespace: "" #! since both Trivy and Grype/Snyk both enable store, one must leave importFromNamespace blank
```

Where:

- `STORE-URL` is the URL where the Store deployment is accessible.
- `CA-SECRET-NAME` is the name of the secret that contains the ca.crt to connect
  to the Store Deployment. Default is `app-tls-cert`.
- `AUTH-SECRET-NAME` is the name of the secret that contains the authentication token to
  authenticate to the Store Deployment.

### <a id='trivy-only'></a> Trivy is the only scanner installed

For a walk through of creating and exporting secrets for the Metadata Store CA
and authentication token which referenced in the data values, see [Multicluster
Setup](../scst-store/multicluster-setup.hbs.md).

The following example `values.yaml` has no other scanner integrations installed
in the same `dev-namespace` where Trivy is installed:

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
- `CA-SECRET-NAME` is the name of the secret that contains the `ca.crt` to
  connect to the Store Deployment. Default is `app-tls-cert`.
- `STORE-SECRETS-NAMESPACE` is the namespace where the secrets for the Store
  Deployment live. Default is `metadata-store`.
- `AUTH-SECRET-NAME` is the name of the secret that contains the authentication
  token to authenticate to the Store Deployment.

### <a id='no-store'></a> No store integration

If you do not want to enable the SCST - Store integration, deactivate the
integration by appending the following fields to the `values.yaml` file that is
enabled by default:

```yaml
# ...
metadataStore:
  url: "" # Configuration is moved, so set this string to empty
```

## <a id='prep-scanpolicy'></a> Prepare the ScanPolicy

The following sample ScanPolicy allows you to control whether the SupplyChain
passes or fails based on the CycloneDX vulnerability results returned from the
Trivy.

```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanPolicy
metadata:
   name: trivy-scan-policy
   labels:
      app.kubernetes.io/part-of: enable-in-gui
spec:
   regoFile: |
      package main

      import future.keywords.in
      import future.keywords.every

      # Accepted Values: "critical", "high", "medium", "low", unknown"
      notAllowedSeverities := ["critical", "high", "unknown"]
      notAllowedSet := {x | x := notAllowedSeverities[_]}
      ignoreCves := []

      isSafe(match) {
        severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
        every severity in severities {
            not severity in notAllowedSet
        }
      }

      isIgnored(match) {
        match.id in ignoreCves
      }

      deny[msg] {
        notAllowedVulnerabilities := { vulnerability |
          vulnerabilities := {e | e := input.bom.vulnerabilities.vulnerability} | {e | e := input.bom.vulnerabilities.vulnerability[_]}
          some vulnerability in vulnerabilities
          not isIgnored(vulnerability)
          not isSafe(vulnerability)
        }
        formattedVulnerabilityMessages := { message |
          some vulnerability in notAllowedVulnerabilities
          ratings := {e | e := vulnerability.ratings.rating.severity} | {e | e := vulnerability.ratings.rating[_].severity}
          formattedRatings := concat(", ", ratings)
          affectedComponents := {e | e := vulnerability.affects.target.ref} | {e | e := vulnerability.affects.target[_].ref}
          formattedComponents := concat("\\\n", affectedComponents)
          message = sprintf("CVE: %s \\\nRatings: %s\\\nAffected Components: \\\n%s", [vulnerability.id, formattedRatings, formattedComponents])
        }
        some formattedVulnerabilityMessage in formattedVulnerabilityMessages
        msg := formattedVulnerabilityMessage
      }
```

To prepare the ScanPolicy:

1. Apply the following to the YAML:

  ```console
  kubectl apply -n $DEV-NAMESPACE -f SCAN-POLICY-YAML
  ```

  Where:

  - `DEV-NAMESPACE` is the name of the developer namespace you want to use.
  - `SCAN-POLICY-YAML` is the name of your SCST - Scan YAML.

## <a id='install-trivy'></a> Install Trivy

After the following prerequisites are completed, install the Trivy:

- Prerequisites listed in [Install another scanner for Supply Chain Security Tools - Scan](install-scanners.hbs.md).
- Install the ORAS CLI. See [the ORAS documentation](https://oras.land/cli/).

## <a id='airgap-config'></a> Air-gap configuration

This section explains how to configure Trivy in an air-gapped environment.

For information about additional flags and configuration, see [Air-Gapped Environment](https://aquasecurity.github.io/trivy/latest/docs/advanced/air-gap/) in the Trivy documentation.

### <a id='relocate-db'></a> Relocate a Trivy database to your registry

>**Note** Using a relocated database means you are taking responsibility for
>keeping it up to date to ensure that security scans are relevant. Stale
>databases weaken your security posture.

If you have a host with access, you can use the ORAS CLI to perform a copy.

```shell
oras copy -r ghcr.io/aquasecurity/trivy-db:2 registry.company.com/project_name/trivy-db:2 # the tag of 2 is required

Copying 4a39b38cf2fd db.tar.gz
Copied  4a39b38cf2fd db.tar.gz
Copied ghcr.io/aquasecurity/trivy-db:2 => registry.company.com/project_name/trivy-db:2
Digest: sha256:ed57874a80499e858caac27fc92e4952346eb75a2774809ee989bcd2ce48897a
```

If not, you can use the ORAS CLI to download the database and manifest and then push to your registry.

1. Download the trivy-db.

  ```shell
  oras pull ghcr.io/aquasecurity/trivy-db:2
  ```

  Example output:

  ```console
  oras pull ghcr.io/aquasecurity/trivy-db:2
  Downloading 1612cc15d377 db.tar.gz
  Downloaded  1612cc15d377 db.tar.gz
  Pulled ghcr.io/aquasecurity/trivy-db:2
  Digest: sha256:af903c7ddbe7516f18b06254b6297cf53c0ece918def07322925c71d2f694860
  ```

2. Download the manifest for trivy-db.

  ```shell
  oras manifest fetch ghcr.io/aquasecurity/trivy-db:2 > trivy-db-manifest.json
  ```

3. Add the media type to the manifest.

  ```shell
  jq '.mediaType="application/vnd.oci.image.manifest.v1+json"' trivy-db-manifest.json > updated-trivy-db-manifest.json
  ```

4. Push the prior downloaded trivy-db to your registry.

  ```shell
  oras push registry.company.com/project_name/trivy-db:2 ./db.tar.gz
  ```

  Example output:

  ```console
  oras push registry.company.com/project_name/trivy-db:2 \
    ./db.tar.gz

  Uploading 1612cc15d377 db.tar.gz
  Uploaded  1612cc15d377 db.tar.gz
  Pushed registry.company.com/project_name/trivy-db:2
  Digest: sha256:41a7eeab8837e90d8a5afd56cfce73936e15d3db04c5294f992ecff9492971dc
  ```

5. Push the updated trivy-db manifest to your registry

  ```shell
  oras manifest push registry.company.com/project_name/trivy-db:2 updated-trivy-db-manifest.json
  ```

  Example output:

  ```console
  oras manifest push registry.company.com/project_name/trivy-db:2 updated-trivy-db-manifest.json
  Pushed registry.company.com/project_name/trivy-db:2
  Digest: sha256:b51a2fccf38e723aac1a7217ba36ca52398b2b20e3d74c9d5089dfdcd9bb2f11
  ```

6. Cleanup files

  ```shell
  rm trivy-db-manifest.json updated-trivy-db-manifest.json db.tar.gz
  ````

7. Update data values with the database repository URL. Edit your `values.yaml` to add the following:

  ```yaml
  trivy:
    db:
      repositoryUrl: "registry.company.com/project_name/trivy-db"
  ```

  The URL leaves off the tag of `2`.

## <a id='alt-version'></a> Use another Trivy version

This section describes how to use a different Trivy CLI version than what is bundled with the package.

To use another Trivy version:

1. Install the ORAS CLI. See [the ORAS documentation](https://oras.land/cli/).

2. Download the version of the CLI you are interested in from their [GitHub releases page](https://github.com/aquasecurity/trivy/releases).
For example: https://github.com/aquasecurity/trivy/releases/download/v0.36.0/trivy_0.36.0_Linux-64bit.tar.gz

  ```console
  wget -c https://github.com/aquasecurity/trivy/releases/download/v0.36.0/trivy_0.36.0_Linux-64bit.tar.gz -O trivy.tar.gz
  Length: 48363295 (46M) [application/octet-stream]
  Saving to: ‘trivy.tar.gz’

  trivy.tar.gz 100%[==>]  46.12M  50.7MB/s    in 0.9s

  2023-01-25 10:47:55 (50.7 MB/s) - ‘trivy.tar.gz’ saved [48363295/48363295]
  ```

3. Relocate the CLI to your registry.

  Run the following to relocate the CLI to your registry:

  ```console
  oras push registry.company.com/project_name/trivy-cli:0.36.0 \
  --artifact-type trivy/cli \
  ./trivy.tar.gz:application/gzip

  Uploading 121f4d8282aa trivy.tar.gz
  Uploaded  121f4d8282aa trivy.tar.gz
  Pushed registry.company.com/project_name/trivy-cli:0.36.0
  Digest: sha256:5bdb18378e8f66a72f4bef4964edeccfcc2f21883e7a6caca6dbf7a3d7233696
  ```

1. Edit your `values.yaml` to add the location of your CLI.

  ```yaml
  trivy:
    cli:
      repositoryUrl: "registry.company.com/project_name/trivy-cli:0.36.0"
  ```

## <a id='aqua-version'></a> Use another Trivy Aqua plug-in version

Trivy Aqua plug-in enables Aqua SaaS integration with your Trivy scans.

To use another Trivy Aqua plug-in version:

1. Install the ORAS CLI. See [the ORAS documentation](https://oras.land/cli/).

2. Download the version of Trivy Aqua plug-in you want from the GitHub releases page. See [trivy-plugin-aqua](https://github.com/aquasecurity/trivy-plugin-aqua/releases) in GitHub.

  For example,
  [v0.115.14](https://github.com/aquasecurity/trivy-plugin-aqua/releases/download/v0.115.5/linux_amd64_v0.115.5.tar.gz)
  in GitHub:

  ```console
  TRIVY-AQUA-PLUGIN-VERSION="v0.115.6"
  wget -c "https://github.com/aquasecurity/trivy-plugin-aqua/releases/download/${TRIVY-AQUA-PLUGIN-VERSION}/linux_amd64_${TRIVY-AQUA-PLUGIN-VERSION}.tar.gz" -O trivy-aqua-plugin.tar.gz

  --2023-01-30 10:44:05--  https://github.com/aquasecurity/trivy-plugin-aqua/releases/download/v0.115.6/linux_amd64_v0.115.6.tar.gz
  HTTP request sent, awaiting response... 200 OK
  Length: 50915539 (49M) [application/octet-stream]
  Saving to: ‘trivy-aqua-plugin.tar.gz’

  trivy-aqua-plugin.tar.gz 100%[==>]  48.56M  35.3MB/s    in 1.4s

  2023-01-30 10:44:07 (35.3 MB/s) - ‘trivy-aqua-plugin.tar.gz’ saved [50915539/50915539]
  ```

1. The YAML file is a necessary component to tell Trivy it has the plug-in already installed.
Download the plugin.yml file associated with Trivy Aqua plug-in version you downloaded.

  ```console
  TRIVY-AQUA-PLUGIN-VERSION="v0.115.6"
  wget -c "https://raw.githubusercontent.com/aquasecurity/trivy-plugin-aqua/${TRIVY-AQUA-PLUGIN-VERSION}/plugin.yaml" -O plugin.yaml

  --2023-01-30 10:46:32--  https://raw.githubusercontent.com/aquasecurity/trivy-plugin-aqua/v0.115.6/plugin.yaml
  HTTP request sent, awaiting response... 200 OK
  Length: 909 [text/plain]
  Saving to: ‘plugin.yaml’
  plugin.yaml 100%[==>]     909  --.-KB/s    in 0s

  2023-01-30 10:46:32 (54.2 MB/s) - ‘plugin.yaml’ saved [909/909]
  ```

1. Relocate the plug-in and YAML to your registry:

  ```console
  TRIVY-AQUA-PLUGIN-VERSION="v0.115.6"
  REPOSITORY-URL="registry.company.com/project_name/trivy-aqua-plugin:$TRIVY-AQUA-PLUGIN-VERSION"

  oras push ${REPOSITORY-URL} \
  --artifact-type trivy/aqua-plugin \
  ./trivy-aqua-plugin.tar.gz:application/gzip \
  ./plugin.yaml:text/yaml

  Uploading 6fb65adbfde2 plugin.yaml
  Uploading 7340855e31ff trivy-aqua-plugin.tar.gz
  Uploaded  6fb65adbfde2 plugin.yaml
  Uploaded  7340855e31ff trivy-aqua-plugin.tar.gz
  Pushed registry.company.com/project_name/trivy-aqua-plugin:v0.115.6
  Digest: sha256:791274e44b97fad98edf570205fddc1b0bc21c56d3d54565ad9475fd4da969ae
  ```

  Where:

  - `TRIVY-AQUA-PLUGIN-VERSION` is the version of Trivy Aqua plug-in you are using.
  - `REPOSITORY-URL` is the repository where you want to relocate the plug-in.

1. Edit your `values.yaml` to add the location of your CLI.

  ```yaml
  trivy:
    plugins:
      aqua:
        repositoryUrl: "registry.company.com/project_name/trivy-aqua-plugin:v0.115.6"
  ```

## <a id='integrate-aqua'></a> Integrate with the Aqua SaaS platform

To integrate with the Aqua SaaS platform:

1. In order to connect to the SaaS Platform you must have an API key. To create an API key:

  1. Log into Aqua SaaS.
  2. Enter CSPM.
  3. Click **Settings** -> **API Keys**.
  4. Click **Generate Key**.
  5. Save the information for the next steps.

1. To integrate with the Aqua SaaS Platform you must have an API key. You pass
   this to the scanner through environment variables, referenced in a secret.
   Create an auth secret:

  Example secret:

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: aqua-creds
    namespace: APP-NAMESPACE
  stringData:
    aqua-key: API-KEY
    aqua-secret: API-KEY-SECRET
  ```

  Where:

  - `APP-NAMESPACE` is the developer namespace your app uses.
  - `API-KEY` is the Aqua Platform API key.
  - `API-KEY-SECRET` is the Aqua Platform API key’s Secret.

1. Set environment variables to tell Trivy to connect and report to Aqua SaaS.

You can find plug-in options in the [README.md](https://github.com/aquasecurity/trivy-plugin-aqua/blob/master/README.md) in GitHub.

Here is an example of referencing your API key and secret from a Kubernetes Secret created earlier:

  ```yaml
  namespace: dev
  targetImagePullSecret: registry-credentials
  environmentVariables:
    - name: TRIVY-RUN-AS-PLUGIN
      value: aqua
    - name: AQUA-KEY
      valueFrom:
        secretKeyRef:
          name: aqua-creds
          key: aqua-key
    - name: AQUA-SECRET
      valueFrom:
        secretKeyRef:
          name: aqua-creds
          key: aqua-secret
  ```

  Where:

  - `TRIVY-RUN-AS-PLUGIN` is the Trivy plug-in you want to enable without using the subcommand.
  - `AQUA-KEY` is the Aqua Platform API key.
  - `AQUA-SECRET` is the Aqua Platform API key’s Secret.

## <a id='ss-cert'></a> Self-signed registry certificate

You need additional configuration when attempting to pull an image from a
registry with a self-signed certificate during image scans.

1. If your `tap-values.yaml` used during install has the following shared
   section filled out, Trivy uses this to connect to your registry without
   additional configuration. Use the following YAML with a Tanzu Application
   Platform values shared CA:

  ```yaml
  shared:
    ca_cert_data: | # To be passed if using custom certificates.
        -----BEGIN CERTIFICATE-----
        MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
        -----END CERTIFICATE-----
  ```

1. Create a secret that holds the registry's CA certificate data.

  An example secret:

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: trivy-registry-cert
   namespace: dev
  type: Opaque
  data:
   ca_cert_data: BASE64_CERT
   ```

2. Update your Trivy install `trivy-values.yaml`.

  Add `caCertSecret` to the root of your `trivy-values.yaml`.

  For example:
   
  ```yaml
  namespace: dev
  targetImagePullSecret: tap-registry
  caCertSecret: trivy-registry-cert
  ```
