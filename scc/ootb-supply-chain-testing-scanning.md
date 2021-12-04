---
title: Out of The Box Supply Chain with Testing and Scanning (ootb-supply-chain-testing-scanning)
weight: 2
---

This [cartographer] Supply Chain ties a series of Kubernetes resources which,
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
Testing, but adds on top source and image scanning using [Grype]:

- Watching a Git Repository or local directory for changes
- Running tests from a developer-provide tekton/Pipeline
- Scanning the source code for known vulnerabilities using Grype
- Building a container image out of the source code with Buildpacks
- Scaning the image for known vulnerabilities
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


### Prerequisites

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



#### Developer namespace

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


#### Updates to the developer namespace

In order for source and image scans to happen, scan templates and scan policies
must exist in the same namespace as the Workload. These define:

- `ScanTemplate`: how to run a scan, allowing one to tweak details about the
  execution of the scan (either for images or source code)
- `ScanPolicy`: how to evaluate whether the artifacts scanned are compliant,
  e.g., allowing one to be either very strict, or restrictive about particular
  vulnerabilities found.

Note that the names of the objects **must** match the ones in the example.


##### ScanPolicy

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


##### ScanTemplate

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


##### Developer Workload

With the ScanPolicy and ScanTemplate objects (with the required names set)
submitted to the same namespace as the one where the Workload will be submitted
to, we're ready to submit our Workload.

We can configure the Workload with two scenarios in mind:

- local iteration: takes source code from the filesystem and
  drives is through the supply chain making no use of external git repositories

- local iteration with code from git: takes source code from a git repository
  and drives it through the supply chain without persisting the final
configuration in git

- gitops: source code is provided by an external git repository (public _or_
  private), and the final kubernetes configuration to deploy the application is
  persisted in a repository


###### Local iteration

For local iteration, all we need is the source code (in the example below,
assuming the current directory `.` as the location of the source code we want
to send through the supply chain), and a container image registry to use as the
mean for making the source code available inside the Kubernetes cluster.


```
tanzu apps workload create tanzu-java-web-app \
  --local-path . \
  --source-image $REGISTRY/source \
  --label apps.tanzu.vmware.com/has-tests=true \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/has-tests: "true"
      7 + |    apps.tanzu.vmware.com/workload-type: web
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    image: 10.188.0.3:5000/source:latest@sha256:1cb23472fcdcce276c316d9bed6055625fbc4ac3e50a971f8f8004b1e245981e

? Do you want to create this workload? Yes
Created workload "tanzu-java-web-app"
```

With the Workload submitted, we should be able to keep track of the resulting
series of Kubernetes objects created to drive the source code all the way to a
deployed application by making use of the `tail` command:

```
tanzu apps workload tail tanzu-java-web-app
```


###### Local iteration with code from git

Similar to local iteration with local code, here we make use of the same type
(`web`), but instead of pointing at source code that we have locally, we can
make use of a git repository to feed the supply chain with new changes as they
are pushed to a branch.


```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
  --label apps.tanzu.vmware.com/has-tests=true \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/has-tests: "true"
      7 + |    apps.tanzu.vmware.com/workload-type: web
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```

In the example above, we make use of a public repository, but, if you want to
make use of a private repository instead, make sure you create a Secret in the
same namespace as the one where the Workload is being submitted to, and add the
`--param source_git_ssh_secret=<>` parameter to the set of parameters above.

```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo git@github.com:sample-accelerators/tanzu-java-web-app.git \
  --param source_git_ssh_secret=git-ssh \
  --label apps.tanzu.vmware.com/has-tests=true \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/has-tests: "true"
      7 + |    apps.tanzu.vmware.com/workload-type: web
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  params:
     12 + |  - name: source_git_ssh_secret
     13 + |    value: git-ssh
     14 + |  source:
     15 + |    git:
     16 + |      ref:
     17 + |        branch: main
     18 + |      url: git@github.com:sample-accelerators/tanzu-java-web-app.git
```

For more information of how to set up that secret, check out this section on
Out of The Box Supply Chain Basic.



###### gitops

Differently from local iteration, the GitOps approach requires a secret
containing credentials to a git provider (e.g., GitHub) to be exist in the same
namespace as the Workload, and a couple parameters to be set with details about
the commit to be pushed to the repository where Kubernetes configuration is
delivered to.

Before proceeding, make sure you have a secret with following shape fields and
annotations set:

```
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
  annotations:
    tekton.dev/git-0: github.com  # git server host
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions
  known_hosts: string             # git server public keys
  identity:                       # private key with pull permissions
  identity.pub:                   # public of the `identity` private key
```

With the Secret created, we can move on to the Workload:


```
tanzu apps workload create tanzu-java-web-app \
  --git-repo git@github.com:sample-accelerators/tanzu-java-web-app.git \
  --git-branch main \
  --param "delivery_git_branch=main" \
  --param "delivery_git_commit_message=bump" \
  --param "delivery_git_repository=git@github.com:my-team/staging-repository.git" \
  --param "delivery_git_user_email=team@team.com" \
  --param "delivery_git_user_name=team" \
  --param "delivery_git_ssh_secret=git-ssh" \
  --param "source_git_ssh_secret=git-ssh" \
  --label apps.tanzu.vmware.com/has-tests=true \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/has-tests: "true"
      7 + |    apps.tanzu.vmware.com/workload-type: web
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  params:
     12 + |  - name: delivery_git_branch
     13 + |    value: main
     14 + |  - name: delivery_git_commit_message
     15 + |    value: bump
     16 + |  - name: delivery_git_repository
     17 + |    value: git@github.com:my-team/staging-repository.git
     18 + |  - name: delivery_git_user_email
     19 + |    value: team@team.com
     20 + |  - name: delivery_git_user_name
     21 + |    value: team
     22 + |  - name: delivery_git_ssh_secret
     23 + |    value: git-ssh
     24 + |  - name: source_git_ssh_secret
     25 + |    value: git-ssh
     26 + |  source:
     27 + |    git:
     28 + |      ref:
     29 + |        branch: main
     30 + |      url: git@github.com:sample-accelerators/tanzu-java-web-app.git

? Do you want to create this workload? Yes
Created workload "tanzu-java-web-app"
```

Where:

-  `delivery_git_ssh_secret` (required): name of the secret in the same
   namespace as the Workload where SSH credentials exist for pushing the
   configuration produced by the supply chain to a git repository.
   e.g.: "ssh-secret"

-  `delivery_git_repository` (required): SSH url of the git repository to push
   the kubernete configuration produced by the supply chain to.
   e.g.: "ssh://git@foo.com/staging.git"

-  `delivery_git_branch`: name of the branch to push the configuration to.
   e.g.: "main"

-  `delivery_git_commit_message`: message to write as the body of the commits
   produced for pushing configuration to the git repository.
   e.g.: "ci bump"

-  `delivery_git_user_name`: user name to use in the commits.
   e.g.: "Alice Lee"

-  `delivery_git_user_email`: user email to use for the commits.
   e.g.: "foo@example.com"

-  `source_git_ssh_secret` (required, if source is private): name of the secret
   in the same namespace as the Workload where SSH credentials exist for
   fetching the source code of `workload.spec.source.git`.


### Known Issues

#### Scanning logs

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
