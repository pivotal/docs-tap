# Authoring Supply Chains

The Out of the Box Supply Chain, Delivery Basic and Templates packages provide
a set of Kubernetes objects aiming at covering a reference path to production
prescribed by VMware, but recognizing that each organization has their
own needs, any of those objects are customizable, from the individual
templates for each resource, to the whole supply chains, and delivery objects.

Depending on how Tanzu Application Platform is installed, there are different ways of
customizing the out of the box supply chains.

Below you will find sections covering different ways that supply chains and
templates are authored within the context of profile-based Tanzu Application Platform
installations.


## <a id="own-sup-chain"></a> Providing your own supply chain

To create a new supply chain and make it available for Workloads, make sure that the supply chain does not conflict with the
ones that are installed on the cluster, as those objects are
cluster-scoped.

If this is your first time creating one, follow the tutorials from
the [Cartographer documentation](https://cartographer.sh/docs/v0.3.0/tutorials/first-supply-chain/).

Any supply chain installed in a Tanzu Application Platform
cluster might with two possible cases of collisions:

- **object name**: supply chains are cluster scoped, such as any Cartographer resource prefixed
  with `Cluster`, so the name of the custom supply chain must be different
  from the ones the Out of the Box packages provide.

  Either create a supply chain whose name is different, or remove the
  installation of the corresponding `ootb-supply-chain-*` from the Tanzu Application Platform.

- **workload selection**: a Workload is reconciled against a particular
  supply chain based on a set of selection rules as defined by the supply
  chains. If the rules for the supply chain to match a Workload are ambiguous,
  the Workload does not make any progress.

  Either create a supply chain whose selection rules are different from the
  ones used by the Out of the Box Supply Chain packages, or remove the
  installation of the corresponding `ootb-supply-chain-*` from Tanzu Application Platform.

  See [Selectors](https://cartographer.sh/docs/v0.3.0/architecture/#selectors).

For Tanzu Application Platform 1.1, the following selection rules are in place for the
supply chains of the corresponding packages:

- _ootb-supply-chain-basic_
  - ClusterSupplyChain/**basic-image-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` field set
  - ClusterSupplyChain/**source-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`

- _ootb-supply-chain-testing_
  - ClusterSupplyChain/**testing-image-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` field set
  - ClusterSupplyChain/**source-test-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - label `apps.tanzu.vmware.com/has-test: true`

- _ootb-supply-chain-testing-scanning_
  - ClusterSupplyChain/**scanning-image-scan-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - `workload.spec.image` field set
  - ClusterSupplyChain/**source-test-scan-to-url**
     - label `apps.tanzu.vmware.com/workload-type: web`
     - label `apps.tanzu.vmware.com/has-test: true`

For details about how to edit an existing supply chain, see [Modifying
an Out of the Box Supply Chain](#modifying-an-out-of-the-box-supply-chain)
section.

In case a supply chain package must not be in the installation to
prevent any of the conflicts earlier, such as any other package, using Tanzu Application Platform profiles
you can prevent supply chains from being installed you can use the
`excluded_packages` property in `tap-values.yml`. For example:

```yaml
# add to exclued_packages `ootb-*` packages you DON'T want to install
#
excluded_packages:
  - ootb-supply-chain-basic.apps.tanzu.vmware.com
  - ootb-supply-chain-testing.apps.tanzu.vmware.com
  - ootb-supply-chain-testing-scanning.apps.tanzu.vmware.com
# comment out remove the `supply_chain` property
#
# supply_chain: ""
```


## <a id="templates"></a> Providing your own templates

Similar to supply chains, Cartographer templates (`Cluster*Template` resources)
are cluster-scoped, so we must make sure that the new templates being submitted
to the cluster do not conflict with the ones installed by the `ootb-templates`
package.

Currently, the following set of objects are provided by `ootb-templates`:

- ClusterConfigTemplate/**config-template**
- ClusterConfigTemplate/**convention-template**
- ClusterDeploymentTemplate/**app-deploy**
- ClusterImageTemplate/**image-provider-template**
- ClusterImageTemplate/**image-scanner-template**
- ClusterImageTemplate/**kpack-template**
- ClusterRole/**ootb-templates-app-viewer**
- ClusterRole/**ootb-templates-deliverable**
- ClusterRole/**ootb-templates-workload**
- ClusterRunTemplate/**tekton-source-pipelinerun**
- ClusterRunTemplate/**tekton-taskrun**
- ClusterSourceTemplate/**delivery-source-template**
- ClusterSourceTemplate/**source-scanner-template**
- ClusterSourceTemplate/**source-template**
- ClusterSourceTemplate/**testing-pipeline**
- ClusterTask/**git-writer**
- ClusterTask/**image-writer**
- ClusterTemplate/**config-writer-template**
- ClusterTemplate/**deliverable-template**

Before submitting your own, ensure that either the name and resource has no
conflicts with the ones installed by `ootb-templates`, or exclude from the
installation the template you want to override making use of the
`excluded_templates` property of `ootb-templates`.

For example, if you want to override the `ClusterConfigTemplate` named
`config-template` to provide your own with the same name, so that you don't
need to edit the supply chain. In `tap-values.yml`, exclude the Tanzu Application Platform-provided
template:

```yaml
ootb_templates:
  excluded_templates:
    - 'config-writer'
```

For details about how to edit an existing template, see
[Modifying an Out of the Box Supply template](#modifying-an-out-of-the-box-template)
section.


## <a id="modify-sc"></a> Modifying an Out of the Box Supply Chain

In case either the shape of a supply chain or the templates that it points to must be changed, VMware recommends the following:

1. Copy one of the reference supply chains
1. Remove the old supply chain. See [preventing Tanzu Application Platform supply chains from being
   installed](#preventing-tap-supply-chains-from-being-installed).
1. Edit the supply chain object
1. Submit the modified supply chain to the cluster

### <a id="NAME"></a> Example

If you have a new `ClusterImageTemplate` object named `foo` that you
want use for building container images instead of the out of the box one that
makes use of Kpack for that, and the supply chain that you want to apply such
modification to is the `source-to-url` provided by the
`ootb-supply-chain-basic` package.

1. Find out the image that contains the supply chain definition

    ```bash
    kubectl get app ootb-supply-chain-basic \
      -n tap-install \
      -o jsonpath={.spec.fetch[0].imgpkgBundle.image}
    ```
    ```console
    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:f2ad401bb3e850940...
    ```

1. Pull the contents of the bundle into a directory named `ootb-supply-chain-basic`

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

1. Inspect the files obtained

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

1. Edit the desired supply chain to swap the template with another

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

4. Submit the supply chain to Kubernetes

    The supply chain definition found in the bundle expects some values (the
    ones one provide through `tap-values.yml`) to be interpolated through YTT before
    being submitted to Kubernetes, so before applying the modified supply chain
    to the cluster, use YTT to interpolate those values and then apply:

    ```bash
    ytt \
      --ignore-unknown-comments \
      --file ./ootb-supply-chain-basic/config \
      --data-value registry.server=REGISTRY-SERVER \
      --data-value registry.repository=REGISTRY-REPOSITORY |
      kubectl apply -f-
    ```

    >**Note:** The modified supply chain does not outlive the destruction of the cluster. VMware recommends that it gets saved somewhere, such as a git repository, to install on every cluster where the supply chain is expected to exist.


## a id="modify-ootb-sc"></a> Modifying an Out of the Box Supply template

The Out of the Box Templates package (`ootb-templates`) concentrates all the
templates and shared Tekton tasks used by the supply chains shipped through
`ootb-supply-chain-*` packages.

Any templates that you want to edit, such as to change details about
the resources that are created based on them, are found as part of this
package.

The workflow for getting any of them updated goes as follows:

1. Copy one of the reference templates from `ootb-templates`
1. Exclude that template from set of objects provided by `ootb-templates` (see
   `excluded_templates` in [Providing your Own
   Templates](#providing-your-own-templates))
1. Edit the template
1. Submit the modified template to the cluster

>**Note:** That in this case you don't need to< change anything related to supply
chains - because we're preserving the name of the object (which is referenced
 by the supply chain), no changes to the supply chain would be necessary.


### <a id="example"></a> Example

If that you want to update the `ClusterImageTemplate` object called
`kpack-template` that provides a template for `kpack/Image`s to be created to
hardcode some environment variable.

1. Exclude the `kpack-template` from the set of templates that `ootb-templates`
installs by upating `tap-values.yml`

    ```
    ootb_templates:
      excluded_templates: ['kpack-template']
    ```

1. Find out the image that contains the templates

    ```bash
    kubectl get app ootb-templates \
      -n tap-install \
      -o jsonpath={.spec.fetch[0].imgpkgBundle.image}
    ```
    ```console
    registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a5e177f38d7287f2ca7ee2afd67ff178645d8f1b1e47af4f192a5ddd6404825e
    ```

1. Pull the contents of the bundle into a directory named `ootb-templates`

    ```bash
    imgpkg pull \
      -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:a5e177f38d7.. \
      -o ootb-templates
    ```
    ```
    Pulling bundle 'registry.tanzu.vmware.com/tanzu-...
      Extracting layer 'sha256:a5e177f38d7...

    Locating image lock file images...
    The bundle repo (registry.tanzu.vmware.com/tanzu...

    Succeeded
    ```

1. Observe that you've downloaded all the templates

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

1. Change the property you want to change

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

1. Submit the template


With the template now submitted, because the name of the template is
preserved but the contents changed, the supply chains are now all embed to the
build of the application container images that `FOO` environment variable.


## <a id="live-mod"></a> Live modification of supply chains and templates

In the sections earlier, you covered how one can update the supply chains or
templates that are installed in a cluster, but haven't touched on how you can experiment with them making small changes in a live setup with plain
`kubectl edit`, covered in this section.

When installing Tanzu Application Platform making use of profiles, a `PackageInstall` object is
created, which in turn creates a whole set of children `PackageInstall` objects
for the installation of each individual component that makes up the platform.

```
PackageInstall/tap
└─App/tap
  ├─ PackageInstall/cert-manager
  ├─ PackageInstall/cartographer
  ├─ ...
  └─ PackageInstall/tekton-pipelines
```

Being the installation based on Kubernetes primitives, PackageInstall tries to achieve the state of having all the packages installed.

This is great in overall, but it presents some challenges for modifying the
contents of some of the objects that the installation submits to the cluster:
any live modifications to them result in the original definition being
persisted instead of the changes.

Given that, before you perform any customizations to what is provided out of
the box through the Out of the Box packages, you must pause the top-level
`PackageInstall/tap` object:


```bash
kubectl edit -n tap-install packageinstall tap
```
```console
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

With the installation of Tanzu Application Platform paused, all of the currently installed components
are still there, but any changes to those children PackageInstall objects
are not overwritten.

Now you can move on to pausing the PackageInstall objects that relate to the
templates/supply chains you want to edit.

For example:

- to edit templates: `kubectl edit -n tap-install packageinstall
  ootb-templates`

- to edit the basic supply chains: `kubectl edit -n tap-install
  packageinstall ootb-supply-chain-basic`

setting `packageinstall.spec.paused: true`.

With the installations now paused, any further live changes to templates/supply
chains are persisted until the PackageInstalls are reverted to not being
paused. To persist the changes, follow the steps outlined in the sections
earlier.
