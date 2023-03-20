# Carvel Package Workflow (Experimental)

The [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package
introduces a variation of the OOTB Basic supply chains that output Carvel
Packages. Carvel packages enable configuring for each runtime environment. This
feature is experimental and is used alongside the existing Out of the Box Basic
workflow.

This experimental feature has the following limits:

1. Only the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package is supported. The Testing and Scanning supply chains are not supported.
2. Only workloads of type `server` are supported.

## How To: Operator

This section describes operator tasks for installing Carvel package.

### Prerequisites

To install Carvel package, you need access to a GitOps repository and credentials. See [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).

### Installation

In `tap-values`, configure the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package with the following parameters:

1. (Required) Enable the Carvel Package workflow.

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
    ```

2. (Optional) Set a GitOps subpath. This verifies the path in your GitOps repository to which Carvel Packages are written. See [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental).

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
        gitops_subpath: path/to/my/dir
    ```

3. (Optional) Set a name suffix. This verifies the suffix of the name of the Carvel Package. See [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental).

    ```yaml
    ootb_supply_chain_basic:
      carvel_package:
        workflow_enabled: true
        gitops_subpath: path/to/my/dir
        name_suffix: vmware.com
    ```

4. In `tap-values`, configure the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package with your GitOps parameters, as described in [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).

5. Install the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package.

## How To: Developer

This section describes developer tasks for installing Carvel package.

### Prerequisites

To install Carvel package, your operator must enable the Carvel Package workflow for the [Out of the Box Basic Supply Chain](ootb-supply-chain-basic.hbs.md) package.

### Creating a Workload

To use the Carvel Package workflow, you must add the label `apps.tanzu.vmware.com/carvel-package-workflow=true` to your workload.

Use the following Tanzu CLI flag:

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

To override two parameters set by the operator:

1. (Optional) Set a GitOps subpath. This verifies the path in your GitOps repository to which Carvel Packages are written. See [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental).

Set this parameter by modifying `workload.spec.params.carvel_package_gitops_subpath`. With the Tanzu CLI, you can do so by using the following flag:

   - `--param carvel_package_gitops_subpath=path/to/my/dir`

1. (Optional) Set a name suffix. This verifies the suffix of the name of the Carvel Package. See [Carvel Package template](ootb-template-reference.hbs.md#carvel-package-experimental).

Set this parameter by modifying `workload.spec.params.carvel_package_name_suffix`. With the Tanzu CLI, you can do so by using the following flag:

   - `--param carvel_package_name_suffix=vmware.com`

>**Note** (Optional) You can override GitOps parameters as described in [GitOps versus RegistryOps](gitops-vs-regops.hbs.md#gitops).