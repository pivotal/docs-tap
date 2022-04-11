# Authoring Supply Chains

The Out of the Box Supply Chain, Delivery Basic and Templates packages provide
a set of Kubernetes objects aiming at covering a reference path to production
prescribed by VMware, but recognizing that each organization will have their
own needs, any of those objects can be customized, from the individual
templates for each resource, to the whole supply chains and delivery objects.

Depending on how TAP has been installed, there will be different ways of
achieving such customization of the out of the box supply chains.

Below you'll find sections covering diffent ways that supply chains and
templates can be authored within the context of profile-based TAP
installations.


## Providing your own supply chain

To create a supply chain from scratch and make it available for Workloads, all
that's required is making sure that the supply chain does not conflict with the
ones that are installed in the cluster, after all, those objects are
cluster-scoped.

If this is your first time creating one, make sure to follow the tutorials from
the Cartographer documentation:
https://cartographer.sh/docs/v0.3.0/tutorials/first-supply-chain/

That said, it's important to observe that any supply chain installed in a TAP
cluster might suffer with two possible cases of collisions:

- **object name**: as mentioned before, supply chains (ClusterSupplyChain
  resource) are cluster scoped (just like any Cartographer resource prefixed
  with `Cluster`), so the name of the custom supply chain must be different
  from the ones the Out of the Box packages provide.

  Either create a supply chain whose name is different, or remove the
  installation of the corresponding `ootb-supply-chain-*` from the TAP.

- **workload selection**: a Workload gets reconciled against a particular
  supply chain based on a set of selection rules as defined by the supply
  chains. If the rules for the supply chain to match a Workload is ambiguous,
  the Workload will not make any progress.

  Either create a supply chain whose selection rules are different from the
  ones used by the Out of the Box Supply Chain packages, or remove the 
  installation of the corresponding `ootb-supply-chain-*` from TAP.
  
  See [Selectors](https://cartographer.sh/docs/v0.3.0/architecture/#selectors)
  to know more about it.

Currently (TAP 1.1), the following selection rules are in place for the
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

For details on how to modify an existing supply chain, check out the [Modifying
an Out of the Box Supply Chain](#modifying-an-out-of-the-box-supply-chain)
section.

In case a supply chain package must not be included in the installation to
prevent any of the conflicts above, like any other package, using TAP profiles
we can prevent supply chains from being installed you can make use of the
`excluded_packages` property in `tap-values.yml`. For instance:

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


## Providing your own templates

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

Before submitting your own, make sure that either the name and resource has no
conflicts with the ones installed by `ootb-templates`, or exclude from the
installation the template you want to override making use of the
`excluded_templates` property of `ootb-templates`.

For instance, if we wanted to override the `ClusterConfigTemplate` named
`config-template` to provide our own with the very same name (so that we don't
need to modify the supply chain), in `tap-values.yml` exclude the TAP-provided
template:

```yaml
ootb_templates:
  excluded_templates:
    - 'config-writer'
```

For details on how to modify an existing template, check out the [Modifying
an Out of the Box Supply template](#modifying-an-out-of-the-box-template)
section.


## Modifying an Out of the Box Supply Chain

In case either the shape of a supply chain or the templates that it points at
should be slightly changed, we recommend following the steps below:

1. Copy one of the reference supply chains
1. Remove the old one (see [preventing TAP supply chains from being
   installed](#preventing-tap-supply-chains-from-being-installed))
1. Modify the supply chain object
1. Submit the modified supply chain to the cluster

### Example

Suppose that we have a new `ClusterImageTemplate` object named `foo` that we
want use for building container images instead of the out of the box one that
makes use of Kpack for that, and the supply chain that we want to apply such
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

1. Modify the desired supply chain to swap the template with another

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
    ones one provide via `tap-values.yml`) to be interpolated via YTT before
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

    > **Note:** the modified supply chain will not outlive the destruction of
    > the cluster. It's recommended that it gets saved somewhere (e.g., a git
    > repsository) to be installed on every cluster where the supply chain is
    > expected to exist.


## Modifying an Out of the Box Supply template

The Out of the Box Templates package (`ootb-templates`) concentrates all the
templates and shared Tekton Tasks used by the supply chains shipped via
`ootb-supply-chain-*` packages.

Any templates that one wishes to modify (for instance, to change details about
the resources that are created based on them) would be found as part of this
package.

The workflow for getting any of them updated goes as follows:

1. Copy one of the reference templates from `ootb-templates`
1. Exclude that template from set of objects provided by `ootb-templates` (see
   `excluded_templates` in [Providing your Own
   Templates](#providing-your-own-templates))
1. Modify the template
1. Submit the modified template to the cluster

Note that in this case we don't need to change anything related to supply
chains - because we're preserving the name of the object (which is referenced
to by the supply chain), no changes to the supply chain would be necessary.


### Example

Suppose that we want to update the `ClusterImageTemplate` object called
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

1. Observe that we've downloaded all the templates

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

1. Change the property we want to change

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


With the template now submitted, because the name of the template has been
preserved but the contents changed, the supply chains will now all embed to the
build of the application container images that `FOO` environment variable.


## Live modification of supply chains and templates

In the sections above we covered how one can update the supply chains or
templates that have been installed in a cluster, but haven't touched on how one
could experiment with them making small changes in a live setup with plain
`kubectl edit`, covered in this section.

When installing TAP making use of profiles, a `PackageInstall` object is
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

Being the installation based on Kubernetes primitives, PackageInstall will
relentlessly try to achieve the state of having all the packages installed.

This is great in overall, but it presents some challanges for modifying the
contents of some of the objects that the installation submits to the cluster:
any live modifications to them will result in the original definition being
persisted instead of the changes.

Given that, before we perform any customizations to what's been provided out of
the box via the Out of the Box packages, we need to pause the top-level
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

With the installation of TAP paused, all of the currently installed components
will still be there, but any changes to those children PackageInstall objects
will not be overwritten.

Now we can move on to pausing the PackageInstall objects that relate to the
templates/supplychains we want to modify. 

For instance:

- to modify templates: `kubectl edit -n tap-install packageinstall
  ootb-templates`

- to modify the basic supply chains: `kubectl edit -n tap-install
  packageinstall ootb-supply-chain-basic`

setting `packageinstall.spec.paused: true`.

With the installations now paused, any further live changes to templates/supply
chains will be persisted until the PackageInstalls are reverted to not being
paused. To persist the changes, follow the steps outlined in the sections
above.

