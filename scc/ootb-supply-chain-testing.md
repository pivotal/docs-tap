---
title: Out of The Box Supply Chain with Testing (ootb-supply-chain-testing)
weight: 2
---

This Cartographer Supply Chain ties a series of Kubernetes resources which,
when working together, drives a developer-provided Workload from source code
all the way to a Kubernetes configuration ready to be deployed to a cluster,
passing forward the source code to image building if and only if the testing
pipeline supplied by the developers run successfully.


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
- Running tests from a developer-provided Tekton orPipeline
- Building a container image out of the source code with Buildpacks
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## Prerequisites

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



## Developer namespace

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

- (optional) **git credentials secret**: when using GitOps for managing the
  delivery of applications (or a private git source), provides the required
  credentials for interacting with the git repository (see Supply Chain Basic 
  for details).

- **Tekton pipeline** (_new_): a pipeline to be ran whenever the supply chain
  hits the stage of testing the source code


Below you'll find details about the new objects compared to Out of The Box
Supply Chain Basic.


### Updates to the developer namespace

In order for source code testing to be present in the supply chain, a Tekton
Pipeline must exist in the same namespace as the Workload so that, at the right
moment, the Tekton PipelineRun object that gets created to run the tests can
reference such developer-provided Pipeline.

So, aside from the objects previously defined in the Out of The Box Supply
Chain Basic section, we need to include one more:

- `tekton/Pipeline`: the definition of a series of tasks to run against the
  source code that has been found by earlier resources in the Supply Chain.


#### Tekton/Pipeline

Despite the full liberty around tasks to run, the Tekton or pipeline object
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

ps.: at this point, changes to the developer-provided Tekton Pipeline _will
not_ automatically trigger a re-run of the pipeline (i.e., a new Tekton
PipelineRun will not be automatically created if a field in the Pipeline object
is changed). As a workaround, the latest PipelineRun created can be deleted,
which will trigger a re-run.


## Developer workload

With the Tekton Pipeline object (following the label and parameter requirements
mentioned above) submitted to the same namespace as the one where the Workload
will be submitted to, we're ready to submit our Workload.

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
