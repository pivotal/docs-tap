# Carvel Package Workflow (Experimental)

The [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package can be configured to output Carvel Packages to a GitOps repository. This feature is experimental and can be used alongside the existing Out of the Box Basic workflow.

This document provides instructions for both an operator and developer on make use of the Carvel Package workflow.

Note that as this feature is experimental, there are some limitations:
1. Only the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package is supported. The Testing and Scanning supply chains are not supported.
2. Only workloads of type `server` are supported.

## How To: Operator

### Prerequisites

- You will need access to a GitOps repository and credentials, as described in [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).

### Installation

In `tap-values`, configure the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package with the following parameters:

1. (Required) Enable the Carvel Package workflow.

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
    ```

2. (Optional) Set a GitOps subpath. This will determine the path in your GitOps repository to which Carvel Packages are written. See the [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental) for more information.

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
        gitops_subpath: path/to/my/dir
    ```

3. (Optional) Set a name suffix. This will determine the suffix of the name of the Carvel Package. See the [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental) for more information.

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
        gitops_subpath: path/to/my/dir
        name_suffix: vmware.com
    ```

Then, in `tap-values`, configure the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package with your GitOps parameters, as described in [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).

Finally, install the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package.

## How To: Developer

### Prerequisites

- Your operator will need to enable the Carvel Package workflow for the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package, as described above.

### Creating a Workload

To utilize the Carvel Package workflow, you must add the label `apps.tanzu.vmware.com/carvel-package-workflow=true` to your workload.
With the `tanzu` CLI, you can do so by using the following flag:

- `--label apps.tanzu.vmware.com/carvel-package-workflow=true`

For example:

  ```bash
  tanzu apps workload create tanzu-java-web-app \
    --app tanzu-java-web-app \
    --type server \
    --label apps.tanzu.vmware.com/carvel-package-workflow=true \
    --image IMAGE
  ```

Expect to see the following output:

  ```console
  Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      7 + |    apps.tanzu.vmware.com/carvel-package-workflow: "true"
      8 + |    apps.tanzu.vmware.com/workload-type: server
      9 + |  name: tanzu-java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  image: IMAGE
  ```

You can override two parameters set by the operator:

1. (Optional) Set a GitOps subpath. This will determine the path in your GitOps repository to which Carvel Packages are written. See the [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental) for more information.

Set this parameter by modifying `workload.spec.params.carvel_package_gitops_subpath`. With the `tanzu` CLI, you can do so by using the following flag:

- `--param carvel_package_gitops_subpath=path/to/my/dir`

1. (Optional) Set a name suffix. This will determine the suffix of the name of the Carvel Package. See the [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental) for more information.

Set this parameter by modifying `workload.spec.params.carvel_package_name_suffix`. With the `tanzu` CLI, you can do so by using the following flag:

- `--param carvel_package_name_suffix=vmware.com`

>**Note** You can optionally override GitOps parameters as described in [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).