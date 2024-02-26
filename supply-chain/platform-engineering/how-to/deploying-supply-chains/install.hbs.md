# Install an authored Supply Chain

{{> 'partials/supply-chain/beta-banner' }}

This section details how to install the SupplyChain authored using the tanzu `supplychain` CLI. 

## Installing from a local machine

### Prerequisite

- Ensure you created a SupplyChain by following the tutorial [Build your first SupplyChain](./../../tutorials/my-first-supply-chain.hbs.md).
- The `make install` command requires `kapp` CLI to be installed on the local machine. Install [kapp CLI](https://carvel.dev/kapp/docs/latest/install/).

### Installation

1. Create a namespace where you want to install the `SupplyChain`:

```bash
$ kubectl create namespace mysupplychains 
```

2. Use the `Makefile` generated as part of the `SupplyChain` authoring process in the tutorial to install the `SupplyChain` along with required `Components` as well as Tekton resources like `Pipelines` and `Tasks` to execute the logic of the components.

```bash
$ NAMESPACE=mysupplychains make install

...

Changes

Namespace       Name                       Kind       Age  Op      Op st.  Wait to    Rs  Ri  
mysupplychains  app-config-server          Pipeline   -    create  -       reconcile  -   -  
^               app-config-server-1.0.0    Component  -    create  -       reconcile  -   -  
^               buildpack-build            Pipeline   -    create  -       reconcile  -   -  
^               buildpack-build-1.0.0      Component  -    create  -       reconcile  -   -  
^               calculate-digest           Task       -    create  -       reconcile  -   -  
^               carvel-package             Pipeline   -    create  -       reconcile  -   -  
^               carvel-package             Task       -    create  -       reconcile  -   -  
^               carvel-package-1.0.0       Component  -    create  -       reconcile  -   -  
^               carvel-package-git-clone   Task       -    create  -       reconcile  -   -  
^               check-builders             Task       -    create  -       reconcile  -   -  
^               conventions                Pipeline   -    create  -       reconcile  -   -  
^               conventions-1.0.0          Component  -    create  -       reconcile  -   -  
^               fetch-tgz-content-oci      Task       -    create  -       reconcile  -   -  
^               git-writer                 Pipeline   -    create  -       reconcile  -   -  
^               git-writer                 Task       -    create  -       reconcile  -   -  
^               git-writer-pr-1.0.0        Component  -    create  -       reconcile  -   -  
^               gitops-git-clone           Task       -    create  -       reconcile  -   -  
^               prepare-build              Task       -    create  -       reconcile  -   -  
^               source-git-check           Task       -    create  -       reconcile  -   -  
^               source-git-clone           Task       -    create  -       reconcile  -   -  
^               source-git-provider        Pipeline   -    create  -       reconcile  -   -  
^               source-git-provider-1.0.0  Component  -    create  -       reconcile  -   -  
^               store-content-oci          Task       -    create  -       reconcile  -   -  

Op:      23 create, 0 delete, 0 update, 0 noop, 0 exists
Wait to: 23 reconcile, 0 delete, 0 noop

1:47:20PM: ---- applying 23 changes [0/23 done] ----
1:47:20PM: create task/store-content-oci (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/git-writer (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/app-config-server (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create task/carvel-package (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create task/gitops-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create task/calculate-digest (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/source-git-provider (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/carvel-package (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/buildpack-build (tekton.dev/v1) namespace: mysupplychains
1:47:20PM: create pipeline/conventions (tekton.dev/v1) namespace: mysupplychains
1:47:21PM: create component/app-config-server-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:21PM: create component/carvel-package-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:21PM: create component/buildpack-build-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:21PM: create component/git-writer-pr-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:21PM: create task/fetch-tgz-content-oci (tekton.dev/v1) namespace: mysupplychains
1:47:21PM: create task/check-builders (tekton.dev/v1) namespace: mysupplychains
1:47:21PM: create task/carvel-package-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:21PM: create component/conventions-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:22PM: create task/source-git-check (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: create task/prepare-build (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: create task/git-writer (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: create task/source-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: create component/source-git-provider-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:22PM: ---- waiting on 23 changes [0/23 done] ----
1:47:22PM: ok: reconcile component/source-git-provider-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:22PM: ok: reconcile component/app-config-server-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:22PM: ok: reconcile task/prepare-build (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: ok: reconcile task/gitops-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:22PM: ok: reconcile task/carvel-package-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/store-content-oci (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/git-writer (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/carvel-package (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/git-writer (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/app-config-server (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/calculate-digest (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/source-git-provider (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/buildpack-build (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile pipeline/conventions (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile component/git-writer-pr-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:23PM: ok: reconcile component/carvel-package-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:23PM: ok: reconcile component/buildpack-build-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/source-git-check (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile component/conventions-1.0.0 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/source-git-clone (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/fetch-tgz-content-oci (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/carvel-package (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ok: reconcile task/check-builders (tekton.dev/v1) namespace: mysupplychains
1:47:23PM: ---- applying complete [23/23 done] ----
1:47:23PM: ---- waiting complete [23/23 done] ----

Succeeded

...

Changes

Namespace       Name        Kind         Age  Op      Op st.  Wait to    Rs  Ri  
mysupplychains  appbuildv1  SupplyChain  -    create  -       reconcile  -   -  

Op:      1 create, 0 delete, 0 update, 0 noop, 0 exists
Wait to: 1 reconcile, 0 delete, 0 noop

1:47:24PM: ---- applying 1 changes [0/1 done] ----
1:47:25PM: create supplychain/appbuildv1 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:25PM: ---- waiting on 1 changes [0/1 done] ----
1:47:25PM: ok: reconcile supplychain/appbuildv1 (supply-chain.apps.tanzu.vmware.com/v1alpha1) namespace: mysupplychains
1:47:25PM: ---- applying complete [1/1 done] ----
1:47:25PM: ---- waiting complete [1/1 done] ----

Succeeded
```

>**Note** By default, the `make install` command, installs to the default namespace in your kubeconfig.

## Installing via GitOps

For information about how to manage and install Supply Chains in your build or full clusters, see [GitOps managed SupplyChains](./../deploying-supply-chains/gitops-managed.hbs.md).
