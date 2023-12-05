# Out of the Box Supply Chain with Testing for Supply Chain Choreographer

This topic provides an overview of Out of the Box Supply Chain with Testing for Supply
Chain Choreographer.

This package contains Cartographer Supply Chains that tie together a series of
Kubernetes resources that drive a developer-provided workload from source code
to a Kubernetes configuration ready to be deployed to a cluster. It passes the
source code forward to image building only if the testing pipeline supplied by
the developers runs successfully.

This package includes all the capabilities of the Out of the Box Supply Chain Basic, but
adds testing with Tekton.

For workloads that use either source code or prebuilt images, it
performs the following:

- Building from source code:

  1. Watching a Git Repository or local directory for changes
  1. Running tests from a developer-provided Tekton pipeline
  1. Building a container image out of the source code with Buildpacks
  1. Applying operator-defined conventions to the container definition
  1. Deploying the application to the same cluster

- Using a prebuilt application image:

  1. Applying operator-defined conventions to the container definition
  1. Creating a deliverable object for deploying the application to a cluster


## <a id="prerequisite"></a> Prerequisites

To use this supply chain, ensure:

- Out of the Box Templates is installed.
- Out of the Box Supply Chain With Testing **is installed**.
- Out of the Box Supply Chain With Testing and Scanning **is NOT installed**.
- Developer namespace is configured with the objects per Out of the Box Supply
  Chain Basic guidance. This supply chain is in addition to the basic one.
- (optionally) Install [Out of the Box Delivery
  Basic](ootb-delivery-basic.html), if you are willing to deploy the application to the
same cluster as the workload and supply chains.

To verify that you have the right set of supply chains installed (that is, the
one with Scanning and _not_ the one with testing), run:

```console
tanzu apps cluster-supply-chain list
```

```console
NAME                      LABEL SELECTOR
source-test-to-url        apps.tanzu.vmware.com/has-tests=true,apps.tanzu.vmware.com/workload-type=web
source-to-url             apps.tanzu.vmware.com/workload-type=web
```

If you see `source-test-scan-to-url` in the list, the setup is wrong: you
**must not have the _source-test-scan-to-url_ installed** at the same time as
_source-test-to-url_.

## <a id="developer-namespace"></a> Developer namespace

As mentioned in the prerequisites section, this supply chain builds on the
previous Out of the Box Supply Chain, so only additions are included here.

To make sure you have configured the namespace correctly, it is important that
the namespace has the following objects in it (including the ones marked with
'_new_' whose explanation and details are provided below):

- **registries secrets**: Kubernetes secrets of type
  `kubernetes.io/dockerconfigjson` that contain credentials for pushing and
  pulling the container images built by the supply chain and the
  installation of Tanzu Application Platform.

  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **service account**: The identity to be used for any
  interaction with the Kubernetes API made by the supply chain

  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **rolebinding**: Grant to the identity the necessary roles
  for creating the resources prescribed by the supply chain.

  For more information, see [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.md).

- **Tekton pipeline** (_new_): A pipeline runs whenever the supply chain
  hits the stage of testing the source code.

Below you will find details about the new objects compared to Out of the Box
Supply Chain Basic.

### <a id="updates-to-developer-namespace"></a> Updates to the developer Namespace

For source code testing to be present in the supply chain, a Tekton
Pipeline must exist in the same namespace as the Workload so that, at the right
moment, the Tekton PipelineRun object that gets created to run the tests can
reference such developer-provided Pipeline.

So, aside from the objects previously defined in the Out of the Box Supply
Chain Basic section, you need to include one more:

- `tekton/Pipeline`: the definition of a series of tasks to run against the
  source code that has been found by earlier resources in the Supply Chain.

#### <a id="tekton-pipeline"></a> Tekton/Pipeline

By default, the workload is matched to the corresponding pipeline to run using
labels.  Pipelines must have the label `apps.tanzu.vmware.com/pipeline: test` at
a minimum, but you can add additional labels for granularity.  This provides a
default match in the event that no other labels are provided. The pipeline
expects two parameters:

- `source-url`, an HTTP address where a `.tar.gz` file containing all the
  source code to be tested can be found
- `source-revision`, the revision of the commit or image reference (in case of
  `workload.spec.source.image` being set instead of `workload.spec.source.git`)

For example:

```console
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
        # Remove this step template for Tanzu Application Platform v1.7.0 when running on OpenShift.
        stepTemplate:
          securityContext:
            allowPrivilegeEscalation: false
            runAsUser: 1000
            capabilities:
              drop:
                - ALL
            seccompProfile:
              type: "RuntimeDefault"
            runAsNonRoot: true
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

> **Note** If your cluster has Pod Security Admission enabled, you must update all pipeline tasks to
> adhere to the admission policy. For more information, see
> [Tekton Tasks on a cluster with Pod Security Admission](authoring-supply-chains.hbs.md#tekton-tasks-on-psa-clstr).

#### <a id="multiple-pl"></a> Allow multiple Tekton pipelines in a namespace

{{> 'partials/multiple-pipelines' }}

## <a id="developer-workload"></a> Developer Workload

With the Tekton Pipeline object
submitted to the same namespace as the one where the Workload
will be submitted to, you can submit your Workload.

Regardless of the workflow being targeted (local development or gitops), the
Workload configuration details are the same as in Out of the Box Supply Chain
Basic, except that you mark the workload with tests enabled by means of the
`has-tests` label.

For example:

```console
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
  --sub-path tanzu-java-web-app \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```

```console
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
     16 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     17 + |    subPath: tanzu-java-web-app
```
