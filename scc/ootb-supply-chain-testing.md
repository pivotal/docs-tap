---
title: Out of The Box Supply Chain with Testing and Scanning (ootb-supply-chain-testing)
weight: 2
---

This [cartographer] Supply Chain ties a series of Kubernetes resources which,
when working together, drives a developer-provided Workload from source code
all the way to a Kubernetes configuration ready to be deployed to a cluster,
passing forward the source code to image building if and only if the testing
pipeline supplied by the developers run succesfully.


```
SUPPLYCHAIN
  source-provider                          flux/GitRepository|vmware/ImageRepository
    <--[src]-- source-tester               carto/Runnable        : tekton/PipelineRun
       <--[src]-- image-builder            kpack/Image           : kpack/Build
           <--[img]-- convention-applier   convention/PodIntent
             <--[config]-- config-creator  corev1/ConfigMap
              <--[config]-- config-pusher  carto/Runnable        : tekton/TaskRun

DELIVERY
  config-provider                           flux/GitRepository|vmware/ImageRepository
    <--[src]-- app-deployer                 kapp-ctrl/App
```


It includes all the capabilities of the Out of The Box Supply Chain Basic, but
adds on top testing with Tekton:

- Watching a Git Repository or local directory for changes
- Running tests from a developer-provide tekton/Pipeline
- Building a container image out of the source code with Buildpacks
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


### Prerequisites

To make use this supply chain, it's required that:

- Out of The Box Templates is installed
- Out of The Box Delivery Basic is installed
- Out of The Box Supply Chain With Testing **is installed**
- Out of The Box Supply Chain With Testing and Scanning **is NOT installed** (!!)
- Developer namespace is configured with the objects per Out of The Box Supply
  Chain Basic guidance (this supply chain is additive to the basic one)

You can verify that you have the right set of supply chains installed (i.e. the
one with Scanning and _not_ the one with testing) by running the following
command:

```
tanzu apps cluster-supply-chain list
```
```
NAME                      LABEL SELECTOR
source-test-to-url        apps.tanzu.vmware.com/has-tests=true,apps.tanzu.vmware.com/workload-type=web
source-to-url             apps.tanzu.vmware.com/workload-type=web
```

If you see `source-test-scan-to-url` in the list, the setup is wrong: you
**must not have the _source-test-scan-to-url_ installed** at the same time as
_source-test-to-url_.



#### Developer namespace

As mentioned in the prerequisites section, this supply chain builds on the
previous Out of The Box Supply Chain, so only additions are included here.

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

- **tekton pipeline** (_new_): a pipeline to be ran whenever the supply chain
  hits the stage of testing the source code (see below)


Below you'll find details about the new objects (compared to Out of The Box
Supply Chain Basic).


#### Updates to the developer namespace

In order for source code testing to be present in the supply chain, a Tekton
Pipeline must exist in the same namespace as the Workload so that, at the right
moment, the Tekton PipelineRun object that gets created to run the tests can
reference such developer-provided Pipeline.

So, aside from the objects previously defined in the Out of The Box Supply
Chain Basic section, we need to include one more:

- `tekton/Pipeline`: the definition of a series of tasks to run against the
  source code that has been found by earlier resources in the Supply Chain.


##### tekton/Pipeline

Despite the full liberty around tasks to run, the [tekton/Pipeline] object
**must** be labelled with `apps.tanzu.vmware.com/pipeline: test`, and define
that it expects to take two params:

- `source-url`, an HTTP address where a `.tar.gz` file containing all the
  source code to be tested can be found
- `source-revision`, the revision of the commit or image reference (in case of
  `workload.spec.source.image` being set instead of `workload.spec.source.git`)

For example:

```
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
  labels:
    apps.tanzu.vmware.com/pipeline: test      # (!) required
spec:
  params:
    - name: source-url                        # (!) required
    - name: source-revision                   # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: gradle
            script: |-
              cd `mktemp -d`
              wget -qO- $(params.source-url) | tar xvz
              ./mvnw test
```

ps.: at this point, changes to the developer-provided [tekton/Pipeline] _will
not_ automatically trigger a re-run of the pipeline (i.e., a new
[tekton/PipelineRun] will not be automatically created if a field in the
tekton/Pipeline object is changed). As a workaround, the latest
tekton/PipelineRun created can be deleted, which will trigger a re-run.


##### Developer Workload

With the tekton/Pipeline object (following the label and parameter requirements
mentioned above) submitted to the same namespace as the one where the Workload
will be submitted to, we're ready to submit our Workload.

We can configure the Workload with two scenarios in mind:

- local iteration: takes source code from the filesystem and makes no use of
  external git repositories,

- gitops: source code is provided by an external git repository (public _or_
  private), and the final kubernetes configuration to deploy the application is
  persisted in a repository.


###### Local iteration with local code

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


###### GitOps

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
  identity: string                # private key with pull permissions
  identity.pub: string            # public of the `identity` private key
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

where:

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
