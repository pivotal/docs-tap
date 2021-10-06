# Example Supply Chain Choreographer for Tanzu including Source and Image Scans

This example takes every source code commit, scans the source code for vulnerabilities, builds an image, and then scans the image for vulnerabilities.

## Prerequisites

Follow the steps listed in [Installing Part I: Prerequisites, EULA, and CLI](https://github.com/pivotal/docs-tap/blob/main/install-general.md).

Next, in [Installing Part II: Packages](https://github.com/pivotal/docs-tap/blob/main/install.md), ensure the following packages and their dependencies are installed:
- [Supply Chain Choreographer](https://github.com/pivotal/docs-tap/blob/main/install.md#-install-supply-chain-choreographer)
- [Tanzu Build Service](https://github.com/pivotal/docs-tap/blob/main/install.md#install-tbs)
- [Supply Chain Security Tools - Store](https://github.com/pivotal/docs-tap/blob/main/install.md#install-scst-store)
- [Supply Chain Security Tools - Scan](https://github.com/pivotal/docs-tap/blob/main/install.md#install-scst-scan)
- (Optional) [Kubectl `tree` Plugin](https://github.com/ahmetb/kubectl-tree)

The following versions were used in preparing this example:
```console
$ tanzu package installed list -n tap-install
| Retrieving installed packages...
  NAME             PACKAGE-NAME                          PACKAGE-VERSION  STATUS
  cartographer     cartographer.tanzu.vmware.com         0.0.6            Reconcile succeeded
  grype-scanner    grype.scanning.apps.tanzu.vmware.com  1.0.0-beta       Reconcile succeeded
  metadata-store   scst-store.tanzu.vmware.com           1.0.0-beta.0     Reconcile succeeded
  scan-controller  scanning.apps.tanzu.vmware.com        1.0.0-beta       Reconcile succeeded
  tbs              buildservice.tanzu.vmware.com         1.3.0            Reconcile succeeded
```

## Configure the Example

The following environment variables are required to set configuration for the image registry where Tanzu Build Service will push images. The Image Scan will also pull from the same registry.

```bash
REGISTRY_SERVER=
REGISTRY_USERNAME=
REGISTRY_PASSWORD=
REGISTRY_PROJECT=
```

## Cluster-Wide Resources

### Tanzu Network Image Pull Secret

The following secrets will be used by each product to pull from Tanzu Network. This secret will be replicated into necessary namespaces where it will overwrite the empty placeholder secrets that were defined by each product.

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

Deploy the following to configure Tanzu Build Service to build an image and push it to a registry. `registry-credentials` is an empty placeholder secret that will be populated with the credentials used to access the registry.

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

Deploy the following to configure the source and image scans. `image-secret` is an empty placeholder secret that will be populated with the credentials used to access the registry where TBS will push built images.

When installing the Grype Scanner, five scan templates were pre-installed for various use cases. This example will use two of them, `blob-source-scan-template` for performing a source scan within the context of a supply chain (where the source code is delivered as a tar file) and `private-image-scan-template` for performing an image scan against a private registry. Since they were pre-installed, they are not defined here, but will be referenced later in the supply chain templates.

What is defined here other than the placeholder secret is a Scan Policy indicating how to perform a policy compliance check against severity of vulnerabilities found. This particular Scan Policy will fail compliance if a `Critical`, `High` or `UnknownSeverity` vulnerability is found in either the Source or Image Scan. As it is, this Supply Chain is naive in that it will continue to the next supply chain step regardless of the compliance check.

```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
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

## App Operator Deployments for Defining the Supply Chain

Configure and deploy the following Supply Chain Components. Some components will reference cluster resources deployed above. The scanning components will make use of the Scan Policy but will also reference pre-installed Scan Templates installed with the Grype Scanner.

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
    apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
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
    apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
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
    app.tanzu.vmware.com/workload-type: web

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

## Developer Deployment for Defining the Workload

With all the Supply Chain components in place, it is time for a Developer to deploy a workload through the Supply Chain!

But first, set up a couple watches to see different views into the supply chain progressing. In one terminal (if the optional [Kubectl `tree` Plugin](https://github.com/ahmetb/kubectl-tree) is installed):
```bash
watch kubectl tree workload tanzu-java-web-app
```

And in another terminal using `kubectl get`:
```bash
watch kubectl get workload,scantemplate,scanpolicy,gitrepository,sourcescan,image.kpack,imagescan,pod
```

Deploy a workload that references a public code repository:
```bash
kubectl apply -f - -o yaml << EOF
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    app.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/sample-accelerators/tanzu-java-web-app
      ref:
        branch: main
EOF
```

**NOTE:** There will be some periods where resources take some time to run to completion. In particular, the build image step with Tanzu Build Service will take some minutes to build.

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

## Querying the Metadata Store for Vulnerability Results using the Insight CLI

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
