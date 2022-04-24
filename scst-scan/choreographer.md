# Sample Supply Chain Choreographer for Tanzu

This example takes every source code commit, scans the source code for vulnerabilities, builds an image, and then scans the image for vulnerabilities.

## Prerequisites

1. Follow the steps listed in [Installing Part I: Prerequisites, EULA, and CLI](../install-general.md).

1. Next, in [Installing Individual Packages](../install-components.md), ensure the following
packages and their dependencies are installed by running `tanzu package installed list -n tap-install`:

    - [Supply Chain Choreographer](../install-components.md#install-scc)
    - [Tanzu Build Service](../install-components.md#install-tbs)
    - [Supply Chain Security Tools - Store](../install-components.md#install-scst-store)
    - [Supply Chain Security Tools - Scan](../install-components.md#install-scst-scan)
    - (Optional) [Kubectl `tree` Plugin](https://github.com/ahmetb/kubectl-tree)

    This example uses the following versions:

    ```console
    $ tanzu package installed list -n tap-install
    | Retrieving installed packages...
      NAME             PACKAGE-NAME                          PACKAGE-VERSION  STATUS
      cartographer     cartographer.tanzu.vmware.com         0.0.6            Reconcile succeeded
      grype-scanner    scst-grype.apps.tanzu.vmware.com      1.0.0            Reconcile succeeded
      metadata-store   scst-store.tanzu.vmware.com           1.0.0-beta.0     Reconcile succeeded
      scan-controller  scst-scan.apps.tanzu.vmware.com       1.0.0            Reconcile succeeded
      tbs              buildservice.tanzu.vmware.com         1.3.0            Reconcile succeeded
    ```

## Configure the example

Set the following environment variables to configure the image registry where Tanzu Build Service will push images.
The Image Scan pulls from the same registry.

```bash
REGISTRY_SERVER=
REGISTRY_USERNAME=
REGISTRY_PASSWORD=
REGISTRY_PROJECT=
```

## Cluster-Wide resources

### Tanzu network image pull secret

The following secrets are used by each product to pull from Tanzu Network. These secrets
are replicated into namespaces where they overwrite the empty placeholder secrets that were defined by each product.

```bash
tanzu imagepullsecret add registry-credentials \
  --registry ${REGISTRY_SERVER} \
  --username ${REGISTRY_USERNAME} \
  --password "${REGISTRY_PASSWORD}" \
  --export-to-all-namespaces

tanzu imagepullsecret add image-secret \
  --registry ${REGISTRY_SERVER} \
  --username ${REGISTRY_USERNAME} \
  --password "${REGISTRY_PASSWORD}" \
  --export-to-all-namespaces
```

### Tanzu Build Service

Configure Tanzu Build Service to build an image and push it to a registry.
`registry-credentials` is an empty placeholder secret that is populated with the credentials used to access the registry.

```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
imagePullSecrets:
  - name: registry-credentials

---
apiVersion: kpack.io/v1alpha1
kind: ClusterStore
metadata:
  name: default
spec:
  sources:
    - image: gcr.io/paketo-buildpacks/go
    - image: gcr.io/paketo-buildpacks/java

---
apiVersion: kpack.io/v1alpha1
kind: ClusterStack
metadata:
  name: stack
spec:
  id: "io.buildpacks.stacks.bionic"
  buildImage:
    image: "paketobuildpacks/build:base-cnb"
  runImage:
    image: "paketobuildpacks/run:base-cnb"

---
apiVersion: kpack.io/v1alpha1
kind: ClusterBuilder
metadata:
  name: default
spec:
  serviceAccountRef:
    name: default
    namespace: default
  tag: ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/tbs
  stack:
    name: stack
    kind: ClusterStack
  store:
    name: default
    kind: ClusterStore
  order:
    - group:
        - id: paketo-buildpacks/go
    - group:
        - id: paketo-buildpacks/java
EOF
```

### Supply Chain Security Tools for VMware Tanzu - Scan

Configure the source and image scans.
`image-secret` is an empty placeholder secret that is populated with the credentials
that are used to access the registry where Tanzu Build Service pushes built images.

When installing the Grype Scanner, five scan templates are preinstalled for various use cases.
This example uses two of them:

- `blob-source-scan-template` for performing a source scan within the context of a supply chain where the source code is delivered as a TAR file.
- `private-image-scan-template` for performing an image scan against a private registry.

Because these scan templates are preinstalled, they are not defined, but are referenced later in the supply chain templates.

A Scan Policy is defined and indicates how to perform a policy compliance check against the severity of vulnerabilities found. This Scan Policy will fail compliance if a `Critical`, `High` or `UnknownSeverity` vulnerability is found in either the Source or Image Scan. This Supply Chain  continues to the next supply chain step regardless of the compliance check.

```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical","High","UnknownSeverity"]
    ignoreCVEs := []

    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }

    isSafe(match) {
      fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
      not fails
    }

    isSafe(match) {
      ignore := contains(ignoreCVEs, match.Id)
      ignore
    }

    isCompliant = isSafe(input.currentVulnerability)
EOF
```

## App operator deployments for defining the Supply Chain

Configure and deploy the following Supply Chain Components. Some components reference cluster resources deployed above. The scanning components use the Scan Policy, and reference pre-installed Scan Templates installed with the Grype Scanner.

```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: carto.run/v1alpha1
kind: ClusterSourceTemplate
metadata:
  name: source-code
spec:
  urlPath: .status.artifact.url
  revisionPath: .status.artifact.revision

  template:
    apiVersion: source.toolkit.fluxcd.io/v1beta1
    kind: GitRepository
    metadata:
      name: $(workload.metadata.name)$-source
    spec:
      interval: 1m
      url: $(workload.spec.source.git.url)$
      ref: $(workload.spec.source.git.ref)$
      ignore: |
        !.git

---
apiVersion: carto.run/v1alpha1
kind: ClusterSourceTemplate
metadata:
  name: scanned-source
spec:
  urlPath: .status.artifact.blob.url
  revisionPath: .status.artifact.blob.url

  template:
    apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
    kind: SourceScan
    metadata:
      name: $(workload.metadata.name)$-source-scan
    spec:
      blob:
        url: $(sources.source-code.url)$
        revision: $(sources.source-code.revision)$
      scanTemplate: blob-source-scan-template
      scanPolicy: scan-policy

---
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: built-image
spec:
  imagePath: .status.latestImage

  template:
    apiVersion: kpack.io/v1alpha1
    kind: Image
    metadata:
      name: $(workload.metadata.name)$-image
    spec:
      tag: ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/$(workload.metadata.name)$
      serviceAccount: default
      builder:
        kind: ClusterBuilder
        name: default
      source:
        blob:
          url: $(sources.scanned-source.url)$
      build:
        env:
        - name: BP_OCI_SOURCE
          value: $(sources.scanned-source.revision)$

---
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: scanned-image
spec:
  imagePath: .status.artifact.registry.image

  template:
    apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
    kind: ImageScan
    metadata:
      name: $(workload.metadata.name)$-image-scan
    spec:
      registry:
        image: $(images.built-image.image)$
      scanTemplate: private-image-scan-template
      scanPolicy: scan-policy
EOF
```

Configure and deploy the Supply Chain connecting all the components in series.

```bash
kubectl apply -f - -o yaml << EOF
apiVersion: carto.run/v1alpha1
kind: ClusterSupplyChain
metadata:
  name: supply-chain
spec:
  selector:
    apps.tanzu.vmware.com/workload-type: web

  components:

    - name: source-provider
      templateRef:
        kind: ClusterSourceTemplate
        name: source-code

    - name: source-scanner
      templateRef:
        kind: ClusterSourceTemplate
        name: scanned-source
      sources:
      - component: source-provider
        name: source-code

    - name: image-builder
      templateRef:
        kind: ClusterImageTemplate
        name: built-image
      sources:
        - component: source-scanner
          name: scanned-source

    - name: image-scanner
      templateRef:
        kind: ClusterImageTemplate
        name: scanned-image
      images:
        - component: image-builder
          name: built-image
EOF
```

## Developer deployment for defining the workload

With the Supply Chain components configured, a Developer can deploy a workload through the Supply Chain.

Set up several watches to view the supply chain progressing. In a terminal, if the optional [Kubectl `tree` Plugin](https://github.com/ahmetb/kubectl-tree) is installed, run:
```bash
watch kubectl tree workload tanzu-java-web-app
```

In another terminal run `kubectl get`:
```bash
watch kubectl get workload,scantemplate,scanpolicy,gitrepository,sourcescan,image.kpack,imagescan,pod
```

Deploy a workload that references a public code repository. Run:
```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    apps.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/sample-accelerators/tanzu-java-web-app
      ref:
        branch: main
EOF
```

**NOTE:** Resources can take time to run to completion. The build image step with Tanzu Build Service takes several minutes to build.

Notice the resources be created:

1. `workload`: Workload is defined
1. `scantemplate`: Scan Templates will display as each scan type occurs
1. `gitrepository`: `STATUS` Fetched revision fills in
1. `sourcescan`: The source scan displays `SCANNEDREPOSITORY` and `SCANNEDREVISION` once completed
1. `image.kpack.io`: The build image appears in `LATESTIMAGE`
1. `imagescan`: The image scan displays `SCANNEDIMAGE` once completed
1. `pod`: Pods appear during scans and when the image is being built

During processing and upon completion, try performing `kubectl describe` on the `sourcescan` and `imagescan` resources to see the `Status` section.

**NOTE:** Detailed information pertaining to vulnerabilities found will not display in the output from `kubectl describe`, it is instead sent to the Metadata Store, where it can be queried there.

## Querying the Metadata Store for vulnerability results using the Insight CLI

1. In a separate terminal, set up a port-forwarding to the Metadata Store by running:

    ```bash
    kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
    ```

1. Using the `MetadataURL` field in the `kubectl describe` `sourcescan` or `imagescan` output, use the `insight` CLI to query the Metadata Store for the scan results that were outputted by the Grype Scanner. Run:

    ```bash
    # Configure Insight CLI to Authenticate to Metadata Store
    export METADATA_STORE_TOKEN=$(kubectl get secrets -n tap-install -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-tap-install-sa')].data.token}" | base64 -d)
    insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 \
      --ca-cert /tmp/storeca.crt \
      --access-token $METADATA_STORE_TOKEN

    # Query Source Scan
    kubectl describe sourcescan tanzu-java-web-app-source-scan
    insight source get \
      --repo <insert repo here> \
      --commit <insert sha here> \
      --org <insert org here>

    # Query Image Scan
    kubectl describe imagescan tanzu-java-web-app-image-scan
    # Note: the `digest` flag has the form: sha256:841abf253a244adba79844219a045958ce3a6da2671deea3910ea773de4631e1
    insight image get \
      --digest <insert digest here>

    # Query By CVE
    # Note: the `cveid` flag has the form: CVE-2021-3711
    insight vulnerabilities get \
      --cveid <insert CVE here>
    ```
