# Example Cartographer Supply Chain including Source and Image Scans

From the [Cartographer](https://github.com/vmware-tanzu/cartographer) project page:

> Cartographer is a Kubernetes native Choreographer. It allows users to configure K8s resources into re-usable Supply Chains that can be used to define all of the stages that an Application Workload must go through to get to an environment.

> Cartographer also allows for separation of controls between a user who is responsible for defining a Supply Chain (known as a App Operator) and a user who is focused on creating applications (Developer). These roles are not necessarily mutually exclusive, but provide the ability to create a separation concern.

## Prerequisites

The following is an extension of the [Cartographer: Source to Knative Service Example](https://github.com/vmware-tanzu/cartographer/tree/main/examples/source-to-knative-service) and makes use of the same prerequisites. As such, follow the prerequisite instructions in that example to ensure the following are setup (excluding `knative-serving`, but note the inclusion of `imgpkg`):

  - kind cluster (or alternative Kubernetes (v1.19+) cluster)
  - carvel tools (`imgpkg`, `ytt` and `kapp`)
  - `cert-manager`
  - `cartographer`
  - `kpack`
  - `source-controller`
  - `kapp-controller`
  - (Optional) `kubectl tree`

## Install the Scan controller and Grype scanner

The Source to Knative Service example takes every source code commit, rebuilds and redeploys the application. This example will inject a source code scan before building and then perform an image scan after building. Additionally, this example will use a private source code repository instead of a public one.

To install the scan controller and scanner into the cluster, perform the following steps:

```bash
# pull the bundles
imgpkg pull \
  -b harbor-repo.vmware.com/supply_chain_security_tools/scan-controller:v1.0.0-alpha.1 \
  -o /tmp/scan-controller

imgpkg pull \
  -b harbor-repo.vmware.com/supply_chain_security_tools/grype-templates:v1.0.0-alpha.1 \
  -o /tmp/grype-templates

# set image pull creds
echo "$(tput setaf 3)Please enter your VMware credentials to access https://harbor-repo.vmware.com$(tput sgr0)"
read -p "Username: " REGISTRY_USERNAME
read -p "Password: " -s REGISTRY_PASSWORD

# deploy scan controller
ytt \
    -f /tmp/scan-controller/config \
    -v docker.server=harbor-repo.vmware.com \
    -v docker.username="${REGISTRY_USERNAME}" \
    -v docker.password="${REGISTRY_PASSWORD}" \
  | kbld -f /tmp/scan-controller/.imgpkg/images.yml -f- \
  | kapp deploy -a scan-link -f- -y

# deploy grype templates
ytt \
    -f /tmp/grype-templates/config \
    -v docker.server=harbor-repo.vmware.com \
    -v docker.username="${REGISTRY_USERNAME}" \
    -v docker.password="${REGISTRY_PASSWORD}" \
  | kbld -f /tmp/grype-templates/.imgpkg/images.yml -f- \
  | kapp deploy -a grype-templates -f- -y

# verify templates deployed
kubectl get scantemplates
```

## Configure the Example

To make the example easy to set up, ytt is used for templating Kubernetes objects.

Create `values.yaml` with credentials for the source code repository, kpack image builder and image registry. This example is set to use the Java Buildpack, so point the source repository url at something like a Spring Boot app.

These values will be interpolated into the subsequent yaml files.

```yaml
#@data/values

---
workload: spring-petclinic
source:
  repository:
    url: ssh://gitlab.eng.vmware.com/vulnerability-scanning-enablement/spring-petclinic.git
    branch: test-branch
    # ssh keys for pulling from the source repository specified in developer/workload.yaml
    privatekey: |+
      <private-key-content>
    publickey: <public-key-content>
image:
  # the workload (app) name, registry server and prefix settings will result in the app image being pushed to something like: dev.registry.pivotal.io/nedenwalker/demo-spring-petclinic
  prefix: /<harbor-project>/demo-
  registry:
    # eg harbor-repo.vmware.com, dev.registry.pivotal.io, https://index.docker.io/v1/, gcr.io
    server: dev.registry.pivotal.io
    dockerconfigjson: <docker-config-json>
kpack:
  builder:
    # the registry server setting will result in kpack pulling the buildpack from something like: harbor-repo.vmware.com/kontinuedemo/java-builder
    registry:
      # eg harbor-repo.vmware.com, dev.registry.pivotal.io, https://index.docker.io/v1/, gcr.io
      server: harbor-repo.vmware.com
      username: <username>
      password: <password>
```

## Cluster-Wide Deployments for Configuring Secrets, Service Accounts and an Image Builder

Create `00-cluster/kpack.yaml` to configure `kpack` for building the image.

```yaml
#@ load("@ytt:data", "data")

---
apiVersion: v1
kind: Secret
metadata:
  name: builder-registry-credentials
  namespace: kpack
  annotations:
    kpack.io/docker: #@ data.values.kpack.builder.registry.server
type: kubernetes.io/basic-auth
stringData:
  username: #@ data.values.kpack.builder.registry.username
  password: #@ data.values.kpack.builder.registry.password

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: builder-service-account
  namespace: kpack
secrets:
  - name: builder-registry-credentials
imagePullSecrets:
  - name: builder-registry-credentials

---
apiVersion: kpack.io/v1alpha1
kind: ClusterStore
metadata:
  name: java-store
spec:
  sources:
    - image: gcr.io/paketo-buildpacks/java:5.8.0

---
apiVersion: kpack.io/v1alpha1
kind: ClusterStack
metadata:
  name: stack
spec:
  id: "io.buildpacks.stacks.bionic"
  buildImage:
    image: "harbor-repo.vmware.com/dockerhub-proxy-cache/paketobuildpacks/build:1.0.24-base-cnb"
  runImage:
    image: "harbor-repo.vmware.com/dockerhub-proxy-cache/paketobuildpacks/run:1.0.24-base-cnb"

---
apiVersion: kpack.io/v1alpha1
kind: ClusterBuilder
metadata:
  name: java-builder
spec:
  serviceAccountRef:
    name: builder-service-account
    namespace: kpack
  tag: harbor-repo.vmware.com/kontinuedemo/java-builder
  stack:
    name: stack
    kind: ClusterStack
  store:
    name: java-store
    kind: ClusterStore
  order:
    - group:
        - id: paketo-buildpacks/java
```

Create `00-cluster/repository.yaml` to configure a Kubernetes secret to access the source repository.

```yaml
#@ load("@ytt:data", "data")

---
# secret for fluxcd source controller to clone the repo
apiVersion: v1
kind: Secret
metadata:
  name: repository-credentials
stringData:
  identity: #@ data.values.source.repository.privatekey
  identity.pub: #@ data.values.source.repository.publickey

  # run ssh-keyscan to get host fingerprint
  known_hosts: gitlab.eng.vmware.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIW3CobFtjtaGAbNvW1w7Z1+nOV131I2GQ4T/v6elt8caUxo+NK8w4R0ywLc5FiIa3RQ6CuyHfkO6cnJGQm3n3Q=
```

Create `00-cluster/scanner.yaml` to configure a Kubernetes secret and service account to access the artifact registry. An additional Scan Template is configured for the Source Scan to work within the context of a Supply Chain (as opposed to using a Scan Template included in the Grype Templates bundle). The pre-installed Scan Template for the Image Scan will be used though. Also, we add a Scan Policy to show some vulnerabilities found.

```yaml
#@ load("@ytt:data", "data")

---
apiVersion: v1
kind: Secret
metadata:
  name: image-secret
  annotations:
    kpack.io/docker: #@ data.values.image.registry.server
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: #@ data.values.image.registry.dockerconfigjson

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-account
secrets:
  - name: image-secret
imagePullSecrets:
  - name: image-secret

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: blob-source-scan-template
spec:
  template:
    restartPolicy: Never
    volumes:
      - name: workspace
        emptyDir: {}
    initContainers:
      - name: repo
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args:
          - "-c"
          - "./source/untar-gitrepository.sh $REPOSITORY /workspace"
    containers:
      - name: scanner
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args:
          - "-c"
          - "./source/scan-source.sh /workspace/source scan.xml"

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: sample-scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical","High"]
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
```

## App Operator Deployments for Defining the Supply Chain

Create `app-operator/supply-chain-templates.yaml` to configure each of the components in the Supply Chain. Each Cartographer template references the cluster resources we already defined. And as mentioned above, the pre-installed Scan Template for the Image Scan will be used instead.

```yaml
#@ load("@ytt:data", "data")

---
# Define a Git Repository to watch for new code commits
apiVersion: carto.run/v1alpha1
kind: ClusterSourceTemplate
metadata:
  name: source
spec:
  # Outputs
  urlPath: .status.artifact.url
  revisionPath: .status.artifact.revision

  template:
    apiVersion: source.toolkit.fluxcd.io/v1beta1
    kind: GitRepository
    metadata:
      name: $(workload.metadata.name)$-source
    spec: # Inputs
      interval: 1m
      url: $(workload.spec.source.git.url)$
      ref: $(workload.spec.source.git.ref)$
      ignore: |
        !.git
      secretRef:
        name: repository-credentials

---
# Define a Source Code Scan
# - Accepts a URL to scan and
# - Accepts a Scan Template defining the Scanner to use
# - Outputs the URL and digest if the scan passed
apiVersion: carto.run/v1alpha1
kind: ClusterSourceTemplate
metadata:
  name: scanned-source
spec:
  # Outputs
  urlPath: .status.artifact.blob.url
  revisionPath: .status.artifact.blob.url

  template:
    apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
    kind: SourceScan
    metadata:
      name: $(workload.metadata.name)$-source-scan
    spec: # Inputs
      blob:
        url: $(sources[0].url)$
      scanTemplate: blob-source-scan-template
      scanPolicy: sample-scan-policy

---
# Define an Image
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: image
spec:
  # Outputs
  imagePath: .status.latestImage

  template:
    apiVersion: kpack.io/v1alpha1
    kind: Image
    metadata:
      name: $(workload.metadata.name)$-image
    spec: # Inputs
      tag: #@ data.values.image.registry.server + data.values.image.prefix + "$(workload.metadata.name)$"
      serviceAccount: service-account
      builder:
        kind: ClusterBuilder
        name: java-builder
      source:
        blob:
          url: $(sources[0].url)$

---
# Define an Image Scan
# - Accepts an Image Path to scan and
# - Accepts a Scan Template defining the Scanner to use
# - Outputs the Image Path if the scan passed
apiVersion: carto.run/v1alpha1
kind: ClusterImageTemplate
metadata:
  name: scanned-image
spec:
  # Outputs
  imagePath: .status.scannedImage

  template:
    apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
    kind: ImageScan
    metadata:
      name: $(workload.metadata.name)$-image-scan
    spec: # Inputs
      registry:
        image: $(images[0].image)$
      scanTemplate: private-image-scan-template
      scanPolicy: sample-scan-policy
```

Create `app-operator/supply-chain.yaml` to configure the Supply Chain.

```yaml
# Define Supply Chain
apiVersion: carto.run/v1alpha1
kind: ClusterSupplyChain
metadata:
  name: supply-chain
spec:
  selector:
    app.tanzu.vmware.com/workload-type: web

  #
  #
  # source-provider <--[src]-- source-scanner <--[src]-- image-builder <--[img]--- image-scanner
  #  GitRepository               SourceScan                  Image                   ImageScan
  #
  #
  components:

    # Get the source from a source code repository and output a blob.
    # Source Provider
    #   Input: Url (defined in template)
    #   Output: Source
    - name: source-provider
      templateRef:
        kind: ClusterSourceTemplate
        name: source

    # Use scan-link to scan the source code from the repository.
    # Source Scanner
    #   Input: Source
    #   Output: Scanned Source
    - name: source-scanner
      templateRef:
        kind: ClusterSourceTemplate
        name: scanned-source
      sources:
      - component: source-provider
        name: source

    # Use kpack to build the source blob and output a container image to Harbor.
    # Image Builder
    #   Input: Scanned Source
    #   Output: Image
    - name: image-builder
      templateRef:
        kind: ClusterImageTemplate
        name: image
      sources:
        - component: source-scanner
          name: scanned-source

    # Use scan-link to scan the container image from the kpack build.
    # Image Scanner
    #   Input: Image
    #   Output: Scanned Image
    - name: image-scanner
      templateRef:
        kind: ClusterImageTemplate
        name: scanned-image
      images:
        - component: image-builder
          name: image
```

## Developer Deployment for Defining the Workload

Create `developer/workload.yaml` to configure the Workload to process through the Supply Chain.

```yaml
#@ load("@ytt:data", "data")

---
# Sample Workload to process through Supply Chain
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: #@ data.values.workload
  labels:
    app.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: #@ data.values.source.repository.url
      ref:
        branch: #@ data.values.source.repository.branch
```

## Deploy Everything!

At this point, executing `tree` at the command line should display the following directories and files:

```bash
$ tree
.
├── 00-cluster
│   ├── kpack.yaml
│   ├── repository.yaml
│   └── scanner.yaml
├── app-operator
│   ├── supply-chain-templates.yaml
│   └── supply-chain.yaml
├── developer
│   └── workload.yaml
└── values.yaml
```

Similar to the Source to Knative Service example, the three directories: `00-cluster`, for cluster-wide configuration, `app-operator`, with cartographer-specific files that an App Operator would submit, and `developer`, containing Kubernetes objects that a developer
would submit (yes, just a [Workload](https://github.com/vmware-tanzu/cartographer/blob/main/site/content/docs/reference.md#Workload)!)

**NOTE:** If you updated the `workload` name in the `values.yaml` file, then do so in both the `kapp deploy` and `kubectl tree` commands. (And the `kapp delete` command when tearing down the example.)

We will deploy all the cluster resources, the supply chain and the workload all at once, however we could also do so in steps (as would be the real world experience... where cluster resources and supply chains would be deployed and available for different teams to deploy workloads to).

```bash
ytt \
  --ignore-unknown-comments \
  -f 00-cluster/ \
  -f app-operator/ \
  -f developer/ \
  -f values.yaml \
  | kapp deploy -a spring-petclinic -f- -y

watch kubectl tree workload spring-petclinic
```

Or watch using `kubectl get`:
```bash
watch kubectl get workload,scantemplate,scanpolicy,gitrepository,sourcescan,image.kpack.io,imagescan,pod
```

**NOTE:** There will be some periods where resources take some time to run to completion. In particular, the build image step with kpack will take a number of minutes to build the non-trivial spring boot application.

Notice the resources be created:
1. `workload`: Workload is defined
1. `scantemplate`: Scan Templates will display as each scan type occurs
1. `gitrepository`: `STATUS` Fetched revision fills in
1. `sourcescan`: The source scan displays `SCANNEDREPOSITORY` once completed
1. `image.kpack.io`: The build image appears in `LATESTIMAGE`
1. `imagescan`: The image scan displays `SCANNEDIMAGE` once completed
1. `pod`: Pods appear during scans and when the image is being built

During processing and upon completion, try performing `kubectl describe` on the `sourcescan` and `imagescan` resources to see the `Status` section.

**NOTE:** Information pertaining to vulnerabilities found will not display in the output from `kubectl describe`, it is instead sent to the Metadata Store, where it can be queried there.

## Tearing Down the Example

```bash
kapp delete -a spring-petclinic
```

## Uninstalling the Dependencies

Refer to the [Cartographer: Source to Knative Service Example](https://github.com/vmware-tanzu/cartographer/tree/main/examples/source-to-knative-service)
