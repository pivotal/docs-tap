# Out of the Box Supply Chain with Testing

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


It includes all the capabilities of the Out of the Box Supply Chain Basic, but
adds on top testing with Tekton:

- Watching a Git Repository or local directory for changes
- Running tests from a developer-provided Tekton or Pipeline
- Building a container image out of the source code with Buildpacks
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## <a id="prerequisite"></a> Prerequisites

To make use this supply chain, it is required that:

- Out of the Box Templates is installed
- Out of the Box Delivery Basic is installed
- Out of the Box Supply Chain With Testing **is installed**
- Out of the Box Supply Chain With Testing and Scanning **is NOT installed**
- Developer namespace is configured with the objects per Out of the Box Supply
  Chain Basic guidance. This supply chain is additive to the basic one.

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



## <a id="developer-namespace"></a> Developer Namespace

As mentioned in the prerequisites section, this supply chain builds on the
previous Out of the Box Supply Chain, so only additions are included here.

To make sure you have configured the namespace correctly, it is important that
the namespace has the following objects in it (including the ones marked with
'_new_' whose explanation and details are provided below):

- **image secret**: A Kubernetes secret of type
  `kubernetes.io/dockerconfigjson` filled with credentials for pushing the
   container images built by the supply chain.
   For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **service account**: The identity to be used for any interaction with the
  Kubernetes API made by the supply chain.
  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **role**: The set of capabilities that you want to assign to the service
  account. It must provide the ability to manage all of the resources that the
  supplychain is responsible for.
  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **rolebinding**: Binds the role to the service account.
  It grants the capabilities to the identity.
  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- (Optional) **git credentials secret**: When using GitOps for managing the
  delivery of applications or a private git source, this secret provides the
  credentials for interacting with the git repository.
  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **Tekton pipeline** (_new_): A pipeline runs whenever the supply chain
  hits the stage of testing the source code.


Below you will find details about the new objects compared to Out of the Box
Supply Chain Basic.


### <a id="updates-to-developer-namespace"></a> Updates to the Developer Namespace

In order for source code testing to be present in the supply chain, a Tekton
Pipeline must exist in the same namespace as the Workload so that, at the right
moment, the Tekton PipelineRun object that gets created to run the tests can
reference such developer-provided Pipeline.

So, aside from the objects previously defined in the Out of the Box Supply
Chain Basic section, you need to include one more:

- `tekton/Pipeline`: the definition of a series of tasks to run against the
  source code that has been found by earlier resources in the Supply Chain.


#### <a id="tekton-pipeline"></a> Tekton/Pipeline

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
              wget -qO- $(params.source-url) | tar xvz -m
              ./mvnw test
```

At this point, changes to the developer-provided Tekton Pipeline do
not automatically trigger a re-run of the pipeline. That is, a new Tekton
PipelineRun is not automatically created if a field in the Pipeline object
is changed. As a workaround, the latest PipelineRun created can be deleted,
which triggers a re-run.


## <a id="developer-workload"></a> Developer Workload

With the Tekton Pipeline object
submitted to the same namespace as the one where the Workload
will be submitted to, you can submit your Workload.

Regardless of the workflow being targeted (local development or gitops), the
Workload configuration details are the same as in Out of the Box Supply Chain
Basic, except that you mark the Workload as having tests enabled.

For example:

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
