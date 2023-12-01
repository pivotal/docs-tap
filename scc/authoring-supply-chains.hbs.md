# Author your supply chains

The Out of the Box Supply Chain, Delivery Basic, and Templates Supply Chain
Choreographer packages give you Kubernetes objects that cover a reference path
to production. Because VMware recognizes that you have your own needs, these
objects are customizable, including individual templates for each resource,
whole supply chains, or delivery objects.

Depending on how you installed Tanzu Application Platform, there are different ways to
customize the Out of the Box Supply Chains. The following sections describe the ways
supply chains and templates are authored within the context of profile-based Tanzu Application Platform
installations.


## <a id="own-sup-chain"></a> Providing your own supply chain

To create a new supply chain and make it available for workloads, ensure that the supply chain does not conflict with those installed on the cluster, as those objects are cluster-scoped.

If this is your first time creating a supply chain, follow the tutorials from
the [Cartographer documentation](https://cartographer.sh/docs/v0.3.0/tutorials/first-supply-chain/).

Any supply chain installed in a Tanzu Application Platform
cluster might encounter two possible cases of collisions:

- **object name**: Supply chains are cluster scoped, such as any Cartographer resource prefixed
  with `Cluster`. So the name of the custom supply chain must be different
  from the ones provided by the Out of the Box packages.

  Either create a supply chain whose name is different, or remove the
  installation of the corresponding `ootb-supply-chain-*` from the Tanzu Application Platform.

- **workload selection**: A workload is reconciled against a particular
  supply chain based on a set of selection rules as defined by the supply
  chains. If the rules for the supply chain to match a workload are ambiguous,
  the workload does not make any progress.

  Either create a supply chain whose selection rules are different from the
  ones the Out of the Box Supply Chain packages use, or remove the
  installation of the corresponding `ootb-supply-chain-*` from Tanzu Application Platform.

  See [Selectors](https://cartographer.sh/docs/v0.3.0/architecture/#selectors).

For Tanzu Application Platform 1.2, the following selection rules are in place for the
supply chains of the corresponding packages:

- _ootb-supply-chain-basic_
  - ClusterSupplyChain/**basic-image-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` text box set
  - ClusterSupplyChain/**source-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
  - ClusterSupplyChain/**basic-image-to-url-package (experimental)**
     - label `apps.tanzu.vmware.com/workload-type: server`
     - label `apps.tanzu.vmware.com/carvel-package-workflow: true`
  - ClusterSupplyChain/**source-to-url-package (experimental)**
     - label `apps.tanzu.vmware.com/workload-type: server`
     - label `apps.tanzu.vmware.com/carvel-package-workflow: true`

- _ootb-supply-chain-testing_
  - ClusterSupplyChain/**testing-image-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` text box set
  - ClusterSupplyChain/**source-test-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - label `apps.tanzu.vmware.com/has-test: true`

- _ootb-supply-chain-testing-scanning_
  - ClusterSupplyChain/**scanning-image-scan-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` text box set
  - ClusterSupplyChain/**source-test-scan-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - label `apps.tanzu.vmware.com/has-test: true`

For details about how to edit an existing supply chain, see [Modifying
an Out of the Box Supply Chain](#modifying-an-out-of-the-box-supply-chain)
section.

You can exclude a supply chain package from the installation to
prevent the conflicts mentioned earlier, by using the
`excluded_packages` property in `tap-values.yaml`. For example:

```yaml
# add to exclued_packages `ootb-*` packages you DON'T want to install
# excluded_packages:
  - ootb-supply-chain-basic.apps.tanzu.vmware.com
  - ootb-supply-chain-testing.apps.tanzu.vmware.com
  - ootb-supply-chain-testing-scanning.apps.tanzu.vmware.com
# comment out remove the `supply_chain` property
#
# supply_chain: ""
```

## <a id="templates"></a> Providing your own templates

Similar to supply chains, Cartographer templates (`Cluster*Template` resources)
are cluster-scoped, so you must ensure that the new templates submitted
to the cluster do not conflict with those installed by the `ootb-templates`
package.

The following set of objects are provided by `ootb-templates`:

- ClusterConfigTemplate/**config-template**
- ClusterConfigTemplate/**convention-template**
- ClusterDeploymentTemplate/**app-deploy**
- ClusterImageTemplate/**image-provider-template**
- ClusterImageTemplate/**image-scanner-template**
- ClusterImageTemplate/**kpack-template**
- Task/**kaniko-build**
- ClusterImageTemplate/**kaniko-template**
- ClusterRole/**ootb-templates-app-viewer**
- ClusterRole/**ootb-templates-deliverable**
- ClusterRole/**ootb-templates-workload**
- ClusterRunTemplate/**tekton-source-pipelinerun**
- ClusterSourceTemplate/**delivery-source-template**
- ClusterSourceTemplate/**source-scanner-template**
- ClusterSourceTemplate/**source-template**
- ClusterSourceTemplate/**testing-pipeline**
- Task/**git-writer**
- Task/**image-writer**
- ClusterTemplate/**config-writer-template**
- ClusterTemplate/**deliverable-template**
- Task/**carvel-package (experimental)**
- ClusterConfigTemplate/**carvel-package (experimental)**
- ClusterTemplate/**package-config-writer-and-pull-requester-template (experimental)**
- ClusterTemplate/**package-config-writer-template (experimental)**

Before submitting your own, either ensure that the name and resource has no
conflicts with those installed by `ootb-templates`, or exclude from the
installation the template you want to override by using the
`excluded_templates` property of `ootb-templates`.

For example, perhaps you want to override the `ClusterConfigTemplate` named
`config-template` to provide your own with the same name, so that you don't
need to edit the supply chain. In `tap-values.yaml`, you can exclude template provided by
Tanzu Application Platform:

```yaml
ootb_templates:
  excluded_templates:
    - 'config-writer'
```

For details about how to edit an existing template, see
[Modifying an Out of the Box Supply template](#modifying-an-out-of-the-box-template)
section.

## <a id="modify-sc"></a> Modifying an Out of the Box Supply Chain

To change the shape of a supply chain or the template that it points to, do the following:

1. Copy one of the reference supply chains.
2. Remove the old supply chain. See [preventing Tanzu Application Platform supply chains from being
   installed](#preventing-tap-supply-chains-from-being-installed).
3. Edit the supply chain object.
4. Submit the modified supply chain to the cluster.

### <a id="example-ootb-sc"></a> Example

In this example, you have a new `ClusterImageTemplate` object named `foo` that you
want use for building container images instead of the out of the box object that
makes use of Kpack. The supply chain that you want to apply the
modification to is `source-to-url` provided by the
`ootb-supply-chain-basic` package.

1. Find the image that contains the supply chain definition:

    ```bash
    kubectl get app ootb-supply-chain-basic \
      -n tap-install \
      -o jsonpath={.spec.fetch[0].imgpkgBundle.image}
    ```

    ```console
    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:f2ad401bb3e850940...
    ```

2. Pull the contents of the bundle into a directory named `ootb-supply-chain-basic`:

    ```bash
    imgpkg pull \
      -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:f2ad401bb3e850940... \
      -o ootb-supply-chain-basic
    ```

    ```console
    Pulling bundle 'registry.tanzu.vmware.com/tanzu-...
      Extracting layer 'sha256:542f2bb8eb946fe9d2c8a...

    Locating image lock file images...
    The bundle repo (registry.tanzu.vmware.com/tanzu...

    Succeeded
    ```

3. Inspect the files obtained:

    ```bash
    tree ./ootb-supply-chain-basic/
    ```

    ```console
    ./ootb-supply-chain-basic/
    ├── config
    │   ├── supply-chain-image.yaml
    │   └── supply-chain.yaml
    └── values.yaml
    ```

4. Edit the supply chain that you want to exchange the template with another:

    ```diff
    --- a/supply-chain.yaml
    +++ b/supply-chain.yaml
    @@ -52,7 +52,7 @@ spec:
       - name: image-builder
         templateRef:
           kind: ClusterImageTemplate
    -      name: kpack-template
    +      name: foo
         params:
           - name: serviceAccount
             value: #@ data.values.service_account
    ```

5. Submit the supply chain to Kubernetes:

    The supply chain definition found in the bundle expects the values you provided
    by using `tap-values.yaml` to be interpolated by using YTT before
    they are submitted to Kubernetes. So before applying the modified supply chain
    to the cluster, use YTT to interpolate those values. After that, run:

    ```bash
    ytt \
      --ignore-unknown-comments \
      --file ./ootb-supply-chain-basic/config \
      --data-value registry.server=REGISTRY-SERVER \
      --data-value registry.repository=REGISTRY-REPOSITORY |
      kubectl apply -f-
    ```

    >**Important** The modified supply chain does not outlive the destruction of the cluster. VMware recommends that you save it, for example, in a Git repository to install on every cluster where you expect the supply chain to exist.

## <a id="modify-ootb-sc"></a> Modifying an Out of the Box Supply template

The Out of the Box Templates package (`ootb-templates`) includes all of the
templates and shared Tekton tasks used by the supply chains shipped by using
`ootb-supply-chain-*` packages. Any template that you want to edit, for example, to change details about
the resources that are created based on them, is part of this
package.

The workflow for updating a template is as follows:

1. Copy one of the reference templates from `ootb-templates`.
1. Exclude that template from the set of objects provided by `ootb-templates`.
   For more information, see
   `excluded_templates` in [Providing your Own
   Templates](#providing-your-own-templates).
1. Edit the template.
1. Submit the modified template to the cluster.

>**Note** You don't need to change anything related to supply
chains, because you're preserving the name of the object referenced
by the supply chain.

### <a id="example-ootb-st"></a> Example

In this example, you want to update the `ClusterImageTemplate` object called
`kpack-template`, which provides a template for creating `kpack/Image`s to
hardcode an environment variable.

1. Exclude the `kpack-template` from the set of templates that `ootb-templates`
installs by upating `tap-values.yaml`:

    ```yaml
      ootb_templates:
      excluded_templates: ['kpack-template']
    ```

1. Find the image that contains the templates:

    ```bash
    kubectl get app ootb-templates \
      -n tap-install \
      -o jsonpath={.spec.fetch[0].imgpkgBundle.image}
    ```

    ```console
    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a5e177f38d7287f2ca7ee2afd67ff178645d8f1b1e47af4f192a5ddd6404825e
    ```

1. Pull the contents of the bundle into a directory named `ootb-templates`:

    ```bash
    imgpkg pull \
      -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a5e177f38d7.. \
      -o ootb-templates
    ```

    ```console
    Pulling bundle 'registry.tanzu.vmware.com/tanzu-...
      Extracting layer 'sha256:a5e177f38d7...

    Locating image lock file images...
    The bundle repo (registry.tanzu.vmware.com/tanzu...

    Succeeded
    ```

2. Confirm that you downloaded all the templates:

    ```bash
    tree ./ootb-templates
    ```

    ```console
    ./ootb-templates
    ├── config
    │   ├── cluster-roles.yaml
    │   ├── config-template.yaml
    │   ├── kpack-template.yaml         # ! the one we want to modify
    ...
    │   └── testing-pipeline.yaml
    └── values.yaml
    ```

3. Change the property you want to change:

    ```diff
    --- a/config/kpack-template.yaml
    +++ b/config/kpack-template.yaml
    @@ -65,6 +65,8 @@ spec:
             subPath: #@ data.values.workload.spec.source.subPath
           build:
             env:
    +        - name: FOO
    +          value: BAR
             - name: BP_OCI_SOURCE
               value: #@ data.values.source.revision
             #@ if/end param("live-update"):
    ```

4. Submit the template.


The name of the template is preserved but the contents are changed.
So after the template is submitted, the supply chains are all embedded to the
build of the application container images that have `FOO` environment variable.


## <a id="live-mod"></a> Live modification of supply chains and templates

Preceding sections covered how to update supply chains or
templates installed in a cluster. This section shows how you can experiment by making small changes in a live setup with
`kubectl edit`.

When you install Tanzu Application Platform by using profiles, a `PackageInstall` object is
created. This in turn creates a set of children `PackageInstall` objects
for installing the individual components that make up the platform.

```console
PackageInstall/tap
└─App/tap
  ├─ PackageInstall/cert-manager
  ├─ PackageInstall/cartographer
  ├─ ...
  └─ PackageInstall/tekton-pipelines
```

Because the installation is based on Kubernetes primitives, `PackageInstall` tries to achieve the state where all packages are installed.

This is great but presents challenges for modifying the
contents of some of the objects that the installation submits to the cluster.
Namely, such modifications cause the original definition
persisting instead of the changes.

For this reason, before you perform any customization to
the Out of the Box packages, you must pause the top-level
`PackageInstall/tap` object. Run:


```console
kubectl edit -n tap-install packageinstall tap
```

```yaml
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: tap
  namespace: tap-install
spec:
  paused: true                    # ! set this field to `paused: true`.
  packageRef:
    refName: tap.tanzu.vmware.com
    versionSelection:
# ...
```

With the installation of Tanzu Application Platform paused, all of the installed components
are still there, but changes to those children `PackageInstall` objects
are not overwritten.

Now you can pause the `PackageInstall` objects that relate to the
templates or supply chains you want to edit.

For example:

- To edit templates: `kubectl edit -n tap-install packageinstall
  ootb-templates`

- To edit the basic supply chains: `kubectl edit -n tap-install
  packageinstall ootb-supply-chain-basic`

setting `packageinstall.spec.paused: true`.

With the installations paused, further live changes to templates or supply
chains are persisted until you revert the `PackageInstall`s to not being
paused. To persist the changes, follow the steps outlined in the earlier sections.

## <a id="add-tekton-behavior"></a> Adding custom behavior to Supply Chains

Most behaviors in supply chains are supplied by Kubernetes controllers. For example,
Cloud Native Buildpacks are created by the kpack controller when a kpack Image object
is created. Sometimes there is need for behavior and no controller for it exists.
In these instances, you might want to write a script that uses a CLI tool, or interact
with an external API. To do this, you can bring the behavior to the supply chain
by using Tekton.

You can look at the kaniko image-building as an example. You create a Tekton
Task `kaniko-build` with instructions for how to build a Docker image using kaniko
given a set of parameters.
The Task has a set of steps. Each step refers to a container image and a set of instructions
to run on the image.
For example, it can be a Linux image against which a set of bash instructions are run.
The Task is installed on the cluster in the `tap-tasks` namespace.

You create the ClusterImageTemplate `kaniko-template` to create Tekton TaskRuns. TaskRuns
are immutable, so you add the `lifecycle: tekton` field to the template's specifications.
This ensures two things:

- When inputs to the template change, rather than updating the TaskRun, a new
  TaskRun is created.
- Only the values from the most recently created TaskRun that is successful are
  propagated forward in the supply chain.

To learn more about the `lifecycle: tekton` field, see the Cartographer tutorial
[Lifecycle: Templating Objects That Cannot Update](https://cartographer.sh/docs/v0.6.0/tutorials/lifecycle/).
To learn more about Tekton, see the [Tekton documentation](https://tekton.dev/docs/).

### <a id="tekton-tasks-on-PSA-cluster"></a> Tekton Tasks on a cluster with a Pod Security Admission

Kubernetes administrators may choose to enable the Pod Security Admission controller
"to restrict the behavior of pods in a clear, consistent fashion". (Read more in the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/security/pod-security-admission/))
If this is the case on a cluster, the Tekton Tasks must be altered to adhere to the security context.

#### <a id="PSA-compliant-step-template"> Include a PSA compliant stepTemplate
The Task spec must include a `stepTemplate` field with the following defined:
```yaml
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
```

Read more about `stepTemplate` in the
[Tekton documentation](https://tekton.dev/docs/pipelines/tasks/#specifying-a-step-template).

#### <a id="writing-to-appropriate-directories"> Write to available directories
In order to be PSA compliant, the stepTemplate enforces that it will be run as a
non-root user. Task authors must ensure that there is no attempt to write to
protected directories.

As an example, a user may wish to run a golang test and for their Task use the
[Golang image](https://hub.docker.com/_/golang). In that image, the default value
for the HOME environment variable is `/root`. This means that when running a command
like `go test`, binaries would be created in a subdirectory of the root folder,
which the user does not have permission to do. To address this particular case,
the task author can include a step env to override the default value:

```yaml
      steps:
      - image: golang
        name: test
        env:
        - name: HOME
          value: /go
```

Knowing what directories are safe will depend on the image you use. For example,
the `/go` directory above exists and is not protected on the `golang` image but
the directory does not exist on an [alpine](https://hub.docker.com/_/alpine) image.
