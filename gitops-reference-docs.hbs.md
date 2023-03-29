# Tanzu GitOps RI Reference Documentation

## Component Overview

The following diagram shows the components that are installed as part of Tanzu GitOps RI and how they work together to automate the installation of Tanzu Application Platform:

<!-- TODO DIAGRAM -->

### <a id="tanzu-sync-carvel-app"></a>Tanzu Sync Carvel Application

Tanzu Sync consists of a [Carvel](https://carvel.dev/kapp-controller/docs/latest/app-overview/) application named `sync` that is installed in the `tanzu-sync` namespace. The sync application:

1. Fetches a Git repository that contains configuration for Tanzu Application Platform.
2. Templates with ytt a set of resources and data values.
3. Deploys with kapp a set of resources to install Tanzu Application Platform, alongside any other user specified confiuration in the Git Repository.

<!-- TODO DIAGRAM -->

## <a id="sops-vs-eso"></a>Choosing SOPS or ESO

### Supported Kubernetes Distributions and Secret Management Solutions:

|SOPS or ESO|IaaS|Secrets Manager|
|----|----|---|
| SOPS | Any TAP supported IaaS | N/A|
| ESO  | AWS (EKS) | AWS Secrets Manager|

>**Note** Future release will include additional Secrets Managers for ESO.

### Use Cases

|I want ...|SOPS|ESO|
|----|:----:|:----:|
|Sensitive data encrypted inside the git repository | ✅ | ❌ |
|Sensitive data to be stored outside the git repository | ❌ | ✅ |
|Minimal setup. No external secret storage system | ✅ | ❌ |
|To manage sensitive data myself (storing keys, rotation, usage auditing) | ✅ | ❌ |
|To utilize sensitive data management (storage, rotation, usage auditing) by a third-party solution | ❌ | ✅ |

## <a id="git-repo-structure"></a>Git Repository structure

Tanzu Sync Application fetches our deployable content from a Git repository that must match the following structure:

Git repository for a cluster named `full-tap-cluster`:
    
  ```console
  ├── .catalog
  │   ├── tanzu-sync
  │   │   └── 0.0.3
  │   └── tap-install
  │       └── 1.5.0
  ├── README.md
  ├── clusters
  │   └── full-tap-cluster
  │       ├── README.md
  │       ├── cluster-config
  │       │   ├── config
  │       │   │   └── tap-install
  │       │   │       └── .tanzu-managed
  │       │   └── values
  │       └── tanzu-sync
  │           ├── app
  │           │   ├── config
  │           │   │   └── .tanzu-managed
  │           │   └── values
  │           ├── bootstrap
  │           └── scripts
  └── setup-repo.sh
  ```

  Where:

  - `.catalog`: VMware supplied directory of resources and configuration to install Tanzu Sync and Tanzu Application Platform.
    - `tanzu-sync`: Contains the Carvel Packaging App which supports a GitOps workflow for fetching, templating and deploying the `clusters/full-tap-cluster/cluster-config` directory of this repository.
    - `tap-install`: Contains the configuration to install Tanzu Application Platform.
  - `clusters/full-tap-cluster`
    - `cluster-config`
      - `config`: Contains the Tanzu Application Platform installation configuration. This directory can be extended to include any resources we want managed via GitOps to our cluster.
        - `.tanzu-managed`: Contains VMware managed kubernetes resource files to install Tanzu Application Platform. This should not be altered by users!
      - `values`: Contains the plain YAML data files which configure the application.
    - `tanzu-sync`
      - `app`: Contains the main Carvel Packaging App that runs on cluster. It will fetch, template and deploy our TAP installation from `clusters/full-tap-cluster/cluster-config`.
      - `boostrap`: Contains secret provider specific bootstrapping if required.
      - `scripts`: Contains [useful helper scripts](#tanzu-sync-scripts) which can be run to aid in the configuration and deployment of Tanzu GitOps RI.

## <a id="configure-values"></a>Configuration of Tanzu Sync without helper scripts

1. The following plain YAML values files are required to run Tanzu Sync:

    - Tanzu Sync App:

        `clusters/full-tap-cluster/tanzu-sync/app/values/values.yaml` adhering to the following schema:

        ```yaml
        #@data/values-schema
        #@overlay/match-child-defaults missing_ok=True
        ---
        git:
          url: ""
          ref: ""
          sub_path: ""

        tap_package_repository:
          oci_repository: ""
        ```

        Example:
        
        ```yaml
        ---
        git:
          url: git@github.com:my-org/gitops-tap.git
          ref: origin/main
          sub_path: clusters/full-tap-cluster/cluster-config

        tap_package_repository:
          oci_repository: registry.example.com/tanzu-application-platform/tap-packages
        ```
      

    - Tanzu Application Platform Install:

        `clusters/full-tap-cluster/cluster-config/config/values/install-values.yaml` adhering to the following schema:

        ```yaml
        #@data/values-schema
        #@overlay/match-child-defaults missing_ok=True
        ---
        tap_install:
          package_repository:
            oci_repository: ""
          #@schema/type any=True
          values: {}
        ```

        Example:

        ```yaml
        tap_install:
          package_repository:
            oci_repository: registry.example.com/tanzu-application-platform/tap-packages
          values:
            shared:
              ingress_domain: example.vmware.com
            ceip_policy_disclosed: true
        ```

        `clusters/full-tap-cluster/cluster-config/config/values/sensitive-values.sops.yaml` adhering to the following schema:

        ```yaml
        #@data/values-schema
        #@overlay/match-child-defaults missing_ok=True
        ---
        tap_install:
          #@schema/nullable
          #@schema/validation not_null=True 
          #@schema/type any=True
          sensitive_values: {}
        ```

        Example:

        ```yaml
        tap_install:
          sensitive_values:
            shared:
              image_registry:
                project_path: example.registry.com/my-project/my-user/tap
                username: my-username
                password: my-password
        ```

2. The following is used to deploy the application using `kapp`:

    ```terminal
    kapp deploy --app tanzu-sync --file <(ytt \ 
        --file tanzu-sync/app/config \
        --file cluster-config/config/tap-install/.tanzu-managed/version.yaml \
        --data-values-file tanzu-sync/app/values/ \
        --data-value secrets.sops.age_key=$(cat $HOME/key.txt) \
        --data-value secrets.sops.registry.hostname="hostname" \
        --data-value secrets.sops.registry.username="foo@example.com" \
        --data-value secrets.sops.registry.password="password" \
        --data-value secrets.sops.git.ssh.private_key=$(cat $HOME/.ssh/my_private_key) \
        --data-value secrets.sops.git.ssh.known_hosts=$(ssh-keyscan github.com) \
    )
    ```
    
## <a id="tanzu-sync-scripts"></a> Tanzu Sync Scripts

>**Caution** 
>
> The provided scripts are intended to help with the setup of your Git repository to work with a GitOps approach, they are subject to change and/or removal between releases.


Provided in `clusters/MY-CLUSTER/tanzu-sync/scripts` are a set of convenience bash scripts.

These scripts help to setup your Git repository and configure the values as described in the previous section:

- `setup-repo.sh`: Populates a Git repository with the structure described in section [Git Repository structure](gitops-reference-docs.md#git-repo-structure)
- `configure.sh`: Generates the values files described in section [Configuration of values without helper scripts](gitops-reference-docs.md#configure-values).
- `deploy.sh`: A light wrapper around a simple `kapp deploy` given the data values from above, and sensitive values which should not be stored on disk.

## Troubleshoot Tanzu GitOps RI

This section provides information to help troubleshoot Tanzu GitOps RI.

## <a id="tanzu-sync-app-error"></a>Tanzu Sync application error

After the Tanzu Sync application is installed in the cluster, the main
resource to check is the [sync app]() in the `tanzu-sync` namespace.

```terminal
kubectl -n tanzu-sync get app/sync --template='\{{.status.usefulErrorMessage}}'
```

Example error:

```terminal
kapp: Error: waiting on reconcile packageinstall/tap (packaging.carvel.dev/v1alpha1) namespace: tap-install:
  Finished unsuccessfully (Reconcile failed:  (message: Error (see .status.usefulErrorMessage for details)))
```

This indicates that the resource `packageinstall/tap` in namespace `tap-install` has failed. Please see below for details on how to fix this issue.

## <a id="tanzu-sync-app-error"></a>Tanzu Application Platform install error

After the Tanzu Sync application is installed in the cluster, the tap installation commences. The
resource to check is the [tap package install]() in the `tap-install` namespace.

```terminal
kubectl -n tap-install get packageinstall/tap --template='\{{.status.usefulErrorMessage}}'
```


## <a id="common-errors"></a>Common errors

You might encounter one of the following errors:

### <a id="data-value-not-declared"></a>Given data value is not declared in schema

**Error:** Reconciliation fails with `Given data value is not declared in schema`:

```terminal
^ Reconcile failed:  (message: ytt: Error: Overlaying data values (in following order: tap-install/.tanzu-managed/version.yaml, additional data values):
One or more data values were invalid
====================================

Given data value is not declared in schema
tap-values.yaml:
    |
  1 | shared:
    |

    = found: shared
    = expected: a map item with the key named "tap_install" (from tap-install/.tanzu-managed/schema--tap-sensitive-values.yaml:3)
```

**Problem:** The values files were not generated according to the expected schema.

**Solution:** Ensure both non-sensitive and sensitive tap values files to adhere to the schema described in [configure values](gitops-reference-docs.md#configure-values).

Incorrect values example:

```yaml
shared:
  ingress_domain: example.vmware.com
```

Correct values example:

```yaml
tap_install:
  values:
    ingress_domain: example.vmware.com
```
