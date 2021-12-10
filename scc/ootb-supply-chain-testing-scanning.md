---
title: Out of The Box Supply Chain with Testing and Scanning (ootb-supply-chain-testing-scanning)
weight: 2
---

This Cartographer Supply Chain ties a series of Kubernetes resources which,
when working together, drives a developer-provided Workload from source code
all the way to a Kubernetes configuration ready to be deployed to a cluster,
having not only passed that source code through testing and vulnerability
scanning, but also the container image produced.


```
SUPPLYCHAIN
  source-provider                          flux/GitRepository|vmware/ImageRepository
    <--[src]-- source-tester               carto/Runnable        : tekton/PipelineRun
      <--[src]-- source-scanner            scst/SourceScan       : v1/Job
       <--[src]-- image-builder            kpack/Image           : kpack/Build
          <--[img]-- image-scanner         scst/ImageScan        : v1/Job
           <--[img]-- convention-applier   convention/PodIntent
             <--[config]-- config-creator  corev1/ConfigMap
              <--[config]-- config-pusher  carto/Runnable        : tekton/TaskRun

DELIVERY
  config-provider                           flux/GitRepository|vmware/ImageRepository
    <--[src]-- app-deployer                 kapp-ctrl/App
```


It includes all the capabilities of the Out of The Box Supply Chain With
Testing, but adds on top source and image scanning using Grype:

- Watching a Git Repository or local directory for changes
- Running tests from a developer-provided Tekton or Pipeline
- Scanning the source code for known vulnerabilities using Grype
- Building a container image out of the source code with Buildpacks
- Scanning the image for known vulnerabilities
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## Prerequisites

To make use this supply chain, it's required that:

- Out of The Box Templates is installed
- Out of The Box Delivery Basic is installed
- Out of The Box Supply Chain With Testing **is NOT installed** (!!)
- Out of The Box Supply Chain With Testing and Scanning **is installed**
- Developer namespace is configured with the objects per Out of The Box Supply
  Chain With Testing guidance (this supply chain is additive to the testing
  one)

You can verify that you have the right set of supply chains installed (i.e. the
one with Scanning and _not_ the one with testing) by running the following
command:

```
tanzu apps cluster-supply-chain list
```
```
NAME                      LABEL SELECTOR
source-test-scan-to-url   apps.tanzu.vmware.com/has-tests=true,apps.tanzu.vmware.com/workload-type=web
source-to-url             apps.tanzu.vmware.com/workload-type=web
```

If you see `source-test-to-url` in the list, the setup is wrong: you **must not
have the _source-test-to-url_ installed** at the same time as
_source-test-scan-to-url_.



## Developer namespace

As mentioned in the prerequisites section, this example builds on the previous
Out of The Box Supply Chain examples, so only additions are included here.

To make sure you have configured the namespace correctly, it's important that
the namespace has the following objects in it (including the ones marked with
'_new_' whose explanation and details are provided below):

- **image secret**: a Kubernetes secret of type
  `kubernetes.io/dockerconfigjson` filled with credentials for pushing the
container images built by the supply chain (see Supply Chain Basic for details)

- **service account**: the identity to be used for any interaction with the
  Kubernetes API made by the supply chain (see Supply Chain Basic for details)

- **role**: the set of capabilities that we want to assign to the service
  account - it must provide the ability to manage all of the resources that the
supplychain is responsible for (see Supply Chain Basic for details)

- **rolebinding**: binds the role to the service account, i.e., grants the
  capabilities to the identity (see Supply Chain Basic for details)

- (optional) **git credentials secret**: when using GitOps for managing the
  delivery of applications (or a private git source), provides the required
  credentials for interacting with the git repository (see Supply Chain Basic 
  for details).

- **tekton pipeline**: a pipeline to be ran whenever the supply chain hits the
  stage of testing the source code (see Supply Chain With Testing for details)

- **scan policy** (_new_): defines what to do with the results taken from
  scanning the source code and image produced (see below)

- **source scan template** (_new_): a template of how Jobs should be created
  for scanning the source code (see below)

- **image scan template** (_new_): a template of how Jobs should be created for
  scanning the image produced by the supply chain (see below)

Below you'll find details about the new objects (compared to Out of The Box
Supply Chain With Testing).


### Updates to the developer namespace

In order for source and image scans to happen, scan templates and scan policies
must exist in the same namespace as the Workload. These define:

- `ScanTemplate`: how to run a scan, allowing one to tweak details about the
  execution of the scan (either for images or source code)
- `ScanPolicy`: how to evaluate whether the artifacts scanned are compliant,
  e.g., allowing one to be either very strict, or restrictive about particular
  vulnerabilities found.

Note that the names of the objects **must** match the ones in the example.


#### ScanPolicy

The ScanPolicy defines a set of rules to evaluate for a particular scan to
consider the artifacts (image or source code) either compliant or not.

When a ImageScan or SourceScan is created to run a scan, those reference a
policy whose name **must** match the one below (`scan-policy`):

```
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
```


#### ScanTemplate

A ScanTemplate defines the PodTemplateSpec to be used by a Job to run a
particular scan (image or source). When an ImageScan our SourceScan is
instantiated by the supply chain, they reference these templates which must
live in the same namespace as the Workload with the names matching the ones
below:

- source scanning (`blob-source-scan-template`):

```
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: blob-source-scan-template
spec:
  template:
    containers:
    - args:
      - -c
      - ./source/scan-source.sh /workspace/source scan.xml
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: scanner
      resources:
        limits:
          cpu: 1000m
        requests:
          cpu: 250m
          memory: 128Mi
      volumeMounts:
      - mountPath: /workspace
        name: workspace
        readOnly: false
    imagePullSecrets:
    - name: image-secret
    initContainers:
    - args:
      - -c
      - ./source/untar-gitrepository.sh $REPOSITORY /workspace
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: repo
      volumeMounts:
      - mountPath: /workspace
        name: workspace
        readOnly: false
    restartPolicy: Never
    volumes:
    - emptyDir: {}
      name: workspace
```

- image scanning (`private-image-scan-template`):


```
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: private-image-scan-template
spec:
  template:
    containers:
    - args:
      - -c
      - ./image/copy-docker-config.sh /secret-data && ./image/scan-image.sh /workspace
        scan.xml true
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: scanner
      resources:
        limits:
          cpu: 1000m
        requests:
          cpu: 250m
          memory: 128Mi
      volumeMounts:
      - mountPath: /.docker
        name: docker
        readOnly: false
      - mountPath: /workspace
        name: workspace
        readOnly: false
      - mountPath: /secret-data
        name: registry-cred
        readOnly: true
    imagePullSecrets:
    - name: image-secret
    restartPolicy: Never
    volumes:
    - emptyDir: {}
      name: docker
    - emptyDir: {}
      name: workspace
    - name: registry-cred
      secret:
        secretName: image-secret
```

Although they can be customized, we recommend sticking with the examples
above.


## Developer Workload

With the ScanPolicy and ScanTemplate objects, with the required names set,
submitted to the same namespace where the Workload will be submitted
to, we're ready to submit our Workload.

Regardless of the workflow being targgeted (local development or gitops), the
Workload configuration details are the same as in Out of The Box Supply Chain
Basic, except that we mark the Workload as having tests enabled.

For instance:

```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    apps.tanzu.vmware.com/has-tests: "true"
      8 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      9 + |  name: tanzu-java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    git:
     14 + |      ref:
     15 + |        branch: main
     16 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```


## Known Issues

### Scanning logs

At the moment, `tanzu apps workload tail` _will not_ provide the logs of the
Jobs created for source and image scanning. In order to get those, make use of
`kubectl tree` to find the Pods created as children resources and use `kubectl
logs` to visualize them.

For instance, assuming we want to discover the logs of an ImageScan, we can
look at the tree of child objects:

```
kubectl tree workload tanzu-java-web-app
```
```
NAMESPACE     NAME
default       Workload/workload
default       ├─ConfigMap/workload
default       ├─Deliverable/workload
default       │ ├─App/workload
default       │ └─ImageRepository/workload-delivery
default       ├─Image/workload
default       │ ├─Build/workload-build-1
default       │ │ └─Pod/workload-build-1-build-pod
default       │ ├─PersistentVolumeClaim/workload-cache
default       │ └─SourceResolver/workload-source
default       ├─ImageRepository/workload
default       ├─ImageScan/workload											<< !!
default       │ └─Job/scan-workloadw96rc                << !!
default       │   └─Pod/scan-workloadw96rc-6724n        << !!
default       ├─PodIntent/workload
default       ├─Runnable/workload
default       │ └─PipelineRun/workload-hrllc
default       │   └─TaskRun/workload-hrllc-test
default       │     └─Pod/workload-hrllc-test-pod
default       ├─Runnable/workload-image-writer
default       │ └─TaskRun/workload-image-writer-tghr9
default       │   └─Pod/workload-image-writer-tghr9-pod
default       └─SourceScan/workload
```

And then use `kubectl logs` to look at the logs of that pod:


```
kubectl logs scan-workloadw96rc-6724n
```
```
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.o...
  <metadata>
    <timestamp>2021-11-30T17:05:34Z</timestamp>
    <tools>
...
```

[Grype]: https://github.com/anchore/grype
