# Install Tanzu Application Platform through GitOps with HashiCorp Vault

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

<!-- TODO: use markdown-generated anchor values to ease navigating within VS Code (and validating links). -->

This topic tells you how to install Tanzu Application Platform (commonly known as TAP) 
through GitOps with secrets managed in an external secrets store. 
To decide which approach to use, see [Choosing SOPS or ESO](../reference.hbs.md#choosing-sops-or-eso).

Tanzu GitOps Reference Implememtation (RI) does not support changing the secrets management strategy for a cluster, for example, SOPs to ESO. However, changing between AWS Secrets Manager and HashiCorp Vault is supported.
The External Secrets Operator integration in this release of Tanzu GitOps RI is verified to support Kubernetes integration with HashiCorp Vault.

## <a id='prerequisites'></a>Prerequisites

Before installing Tanzu Application Platform, ensure you have:

- Completed the [Prerequisites](../../prerequisites.hbs.md).
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](../../install-tanzu-cli.hbs.md) with any required plug-ins.
- Installed [Cluster Essentials for Tanzu](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html).
- Installed [eksctl CLI](https://github.com/weaveworks/eksctl#installation).

## <a id='relocate-images-to-a-registry'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before attempting installation. If you don't relocate the images, Tanzu Application Platform depends on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

The supported registries are Harbor, Azure Container Registry, Google Container Registry,
and Quay.io.
See the following the documentation for instructions on setting up a registry:

- [Harbor documentation](https://goharbor.io/docs/2.5.0/)
- [Google Container Registry documentation](https://cloud.google.com/container-registry/docs)
- [Quay.io documentation](https://docs.projectquay.io/welcome.html)

To relocate images from the VMware Tanzu Network registry to your registry:

1. Set up environment variables for installation use by running:

    ```console
    export IMGPKG_REGISTRY_HOSTNAME_0=registry.tanzu.vmware.com
    export IMGPKG_REGISTRY_USERNAME_0=MY-TANZUNET-USERNAME
    export IMGPKG_REGISTRY_PASSWORD_0=MY-TANZUNET-PASSWORD
    export IMGPKG_REGISTRY_HOSTNAME_1=MY-REGISTRY
    export IMGPKG_REGISTRY_USERNAME_1=MY-REGISTRY-USER
    export IMGPKG_REGISTRY_PASSWORD_1=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export TAP_VERSION=VERSION-NUMBER
    export INSTALL_REPO=TARGET-REPOSITORY
    ```

    Where:

    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is your own container registry.
    - `MY-TANZUNET-USERNAME` is the user with access to the images in the VMware Tanzu Network registry `registry.tanzu.vmware.com`.
    - `MY-TANZUNET-PASSWORD` is the password for `MY-TANZUNET-USERNAME`.
    - `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.
    - `TARGET-REPOSITORY` is your target repository, a folder or repository on `MY-REGISTRY` that serves as the location for the installation files for Tanzu Application Platform.

    VMware recommends using a JSON key file to authenticate with Google Container Registry.
    In this case, the value of `INSTALL_REGISTRY_USERNAME` is `_json_key` and
    the value of `INSTALL_REGISTRY_PASSWORD` is the content of the JSON key file.
    For more information about how to generate the JSON key file,
    see [Google Container Registry documentation](https://cloud.google.com/container-registry/docs/advanced-authentication).

1. [Install the Carvel tool `imgpkg` CLI](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#optionally-install-clis-onto-your-path).

    To query for the available versions of Tanzu Application Platform on VMWare Tanzu Network Registry, run:

    ```console
    imgpkg tag list -i registry.tanzu.vmware.com/tanzu-application-platform/tap-packages | sort -V
    ```

1. Relocate the images with the `imgpkg` CLI by running:

    ```console
    imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages
    ```

## <a id='create-a-new-git-repository'></a>Create a new Git repository

1. In a hosted Git service, for example, GitHub or GitLab, create a new respository.

    This version of Tanzu GitOps RI supports authenticating to a hosted Git repository by using SSH as well as Basic Authentication.

2. Initialize a new Git repository:

    ```console
    mkdir -p $HOME/tap-gitops
    cd $HOME/tap-gitops

    git init
    git remote add origin git@github.com:my-organization/tap-gitops.git
    ```

3. For authentication with SSH, create a read-only deploy key for this new repository (recommended) or SSH key for an account with read access to this repository.

    The private portion of this key is referred to as `GIT_SSH_PRIVATE_KEY`.

4. For Basic Authentication, have a username with read access to the Git repository and password or personal access token for the same user.

>**Important** Only use one of `ssh` or `Basic Authentication`, not both.

## <a id='download-and-unpack-tanzu-gitops-ri'></a>Download and unpack Tanzu GitOps Reference Implementation (RI)

1. Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com).

1. Go to the [Tanzu Application Platform product page](https://network.tanzu.vmware.com/products/tanzu-application-platform).

1. Select **Release {{ vars.tap_version }}** from the release drop-down menu.

1. Click **Tanzu GitOps Reference Implementation**.

1. Unpack the downloaded TGZ file into the `$HOME/tap-gitops` directory by running:

    ```console
    tar -xvf tanzu-gitops-ri-*.tgz -C $HOME/tap-gitops
    ```

1. Commit the initial state:

    ```console
    cd $HOME/tap-gitops

    git add . && git commit -m "Initialize Tanzu GitOps RI"
    git push -u origin
    ```

## <a id='create-cluster-configuration'></a>Create cluster configuration

1. Seed configuration for a cluster using Vault through the provided convenience script:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh CLUSTER-NAME vault
    ```

    Where:

    - `CLUSTER-NAME` is the name for your cluster. Typically, this is the same as your EKS cluster's name, the name of the cluster as it appears in `eksctl get clusters`.
    - `vault` selects the Vault external Secret Store.

    For example, if the name of your cluster is `iterate-green`:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh iterate-green vault
    ```

    This script creates the directory `clusters/iterate-green/` and copies in the
    configuration required to sync this Git repository with the cluster and installing Tanzu Application Platform.

2. Commit and push:

    ```console
    git add . && git commit -m 'Add "iterate-green" cluster'
    git push
    ```

    Saving the base configuration in an initial commit makes it easier to review customizations in the future.

## <a id='customize-cluster-configuration'></a>Customize cluster configuration

Configuring the Tanzu Application Platform installation involves setting up two components:

- An installation of Tanzu Application Platform.
- An instance of Tanzu Sync, the component that implements the GitOps workflow,
fetching configuration from Git and applying it to the cluster.

Follow these steps to customize your Tanzu Application Platform cluster configuration:

1. Navigate to the created directory:

    ```console
    cd clusters/CLUSTER-NAME
    ```

    For example, if the name of your cluster is `iterate-green`:

    ```console
    cd clusters/iterate-green
    ```

1. Define the following environment variables:

    ```console
    export VAULT_ADDR=MY-VAULT-ADDR
    export CLUSTER_NAME=CLUSTER-NAME
    export TAP_PKGR_REPO=TAP-PACKAGE-OCI-REPOSITORY
    ```

    Where:

    - `MY-VAULT-ADDR` is the accessible URL of your vault instance (Vault must be reachable by the kubernetes cluster).
    - `CLUSTER-NAME` is the name of the target cluster.
    - `TAP-PACKAGE-OCI-REPOSITORY` is the fully-qualified path to the OCI repository hosting the Tanzu Application Platform images.
    If they are relocated to a different registry as described in [Relocate images to a registry](#relocate-images-to-a-registry),
    the value is `${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages`.

### <a id='connect-vault-to-kubernetes'></a>Connect Vault to a Kubernetes cluster

Tanzu GitOps RI uses the Vault Kubernetes authentication method for establishing trust between the kubernetes cluster and Vault, see [Vault Kubernetes auth](https://developer.hashicorp.com/vault/docs/auth/kubernetes) for more. This authetication method uses the Kubernetes Control Plane [TokenReview API](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/token-review-v1/) to authenticate the kubernetes service accounts with Vault. For this reason, the clusters control plane must be able to commuicate over the network to the Vault instance.

To configure Kubernetes authentication for Vault, you can create a new Kubernetes authentication engine instance on Vault and two IAM Roles by using the supplied script:

```console
tanzu-sync/scripts/setup/create-kubernetes-auth.sh
```

>**Important** If you use an Enterprise Vault Server with namespaces, run `export VAULT_NAMESPACE=MY-VAULT-NAMESPACE` before using the script. Also, if you are using token to access server, run `export VAULT_TOKEN=MY-VAULT-TOKEN` before using the script.

This creates a new vault kubernetes authentication instance using the information for the current context in your `KUBECONFIG`.

Example:

```console
vault write auth/iterate-green/config \
  kubernetes_host="MY-KUBERNETES-API-URL" \
  kubernetes_ca_cert="MY-KUBERNETES-CA-CERT" \
  ttl=1h
```

### <a id='grant-read-access-to-secret-data'></a>Grant read access to secret data

Vault secrets store all sensitive configurations, which are accessed by both 
Tanzu Sync and the Tanzu Application Platform installation.

Follow these step to configure Roles in Vault:

1. Create two Policies, one to read the Tanzu Sync secrets and another to read the 
Tanzu Application Platform installation secrets by using the supplied script:

    ```console
    tanzu-sync/scripts/setup/create-policies.sh
    ```

2. Create two Roles, one to read the Tanzu Sync secrets and another to read the 
Tanzu Application Platform installation secrets by using the supplied script:

    ```console
    tanzu-sync/scripts/setup/create-roles.sh
    ```

### <a id='generate-default-configuration'></a>Generate default configuration

You can use the following script to generate default configuration for both
Tanzu Sync and Tanzu Application Platform installation:

```console
tanzu-sync/scripts/configure.sh
```

The following sections tell you how to edit the configuration
values to suit your specific needs.

### <a id='reviewstore-tanzu-sync-config'></a>Review and store Tanzu Sync config

Configuration for Tanzu is stored in two locations:

- Sensitive configuration is stored in Vault.
- Non-sensitive configuration are stored in YAML files in the Git repository.

Follow these steps to create the sensitive configuration and review the non-sensitive configuration:

>**Important** You must enable a key-value secret engine named `secret`.

1. Save the credentials that Tanzu Sync uses to authenticate with the Git repository. There are two supported authentication methods:

    1. SSH

        Create a secret named `secret/dev/CLUSTER-NAME/tanzu-sync/sync-git/ssh` containing
        the following information as plaintext:

        ```json
        {
          "privatekey": "... (private key portion here) ...",
          "knownhosts": "... (known_hosts for git host here) ..."
        }
        ```

        Where `CLUSTER-NAME` is the name of your cluster.

        For example, if the Git repository is hosted on GitHub, and the private key
        created in [Create a new Git repository](#create-a-new-git-repository) is stored in the file `~/.ssh/id_ed25519`:

        ```console
        export GIT_SSH_PRIVATE_KEY_FILE=~/.ssh/id_ed25519
        export GIT_KNOWN_HOSTS=$(ssh-keyscan github.com)
        printf '%s\n'  "$(cat <<EOF
        {
            "privatekey": "$(cat $GIT_SSH_PRIVATE_KEY_FILE | awk '{printf "%s\\\\n", $0}')",
            "knownhosts": "$(echo $GIT_KNOWN_HOSTS | awk '{printf "%s\\\\n", $0}')"
        }
        EOF
        )" | vault kv put secret/dev/${CLUSTER_NAME}/tanzu-sync/sync-git/ssh -
        ```

        Where:

        - The content of `~/.ssh/id_ed25519` is the private portion of the SSH key.
        - `ssh-keyscan` obtains the public keys for the SSH host.
        - `awk '{printf "%s\\\\n", $0}'` converts a multiline string into a single-line
        string with embedded newline chars (`\n`). JSON does not support multiline strings.

    2. Basic Authentication

          Create a secret named `secret/dev/CLUSTER-NAME/tanzu-sync/sync-git/basic_auth` containing
          the following information as plaintext:

          ```json
          {
            "username": "... (username) ...",
            "password": "... (password) ..."
          }
          ```

          Where:

          - `CLUSTER-NAME` is the name of your cluster.
          - `username` is the username of a user account with read access to the Git repository.
          - `password` is the password or personal access token for the user.

2. To securely store the authentication credentials required for accessing the OCI registry hosting the Tanzu Application Platform images, create a secret called `dev/CLUSTER-NAME/tanzu-sync/install-registry-dockerconfig`. This secret contains the following information in plaintext:

    ```json
    {
      "auths": {
        "MY-REGISTRY": {
          "username": "MY-REGISTRY-USER",
          "password": "MY-REGISTRY-PASSWORD"
        }
      }
    }
    ```

    Where:

    - `CLUSTER-NAME` is the name of your cluster.
    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is the container registry where the Tanzu Application Platform images are located.

    For example:

    ```console
    printf '%s\n'  "$(cat <<EOF
    {
      "auths": {
          "${INSTALL_REGISTRY_HOSTNAME}": {
              "username": "${INSTALL_REGISTRY_USERNAME}",
              "password": "${INSTALL_REGISTRY_PASSWORD}"
          }
      }
    }
    EOF
    )" | vault kv put secret/dev/${CLUSTER_NAME}/tanzu-sync/install-registry-dockerconfig -
    ```

3. Review the hosted Git URL and branch used by Tanzu Sync.

    This configuration was generated by the `configure.sh` script. It reported:

    ```console
    ...
    wrote non-sensitive Tanzu Sync configuration to: tanzu-sync/app/values/tanzu-sync.yaml
    ...
    ```

    For example, for the `iterate-green` cluster, if the Git repository is hosted
    on GitHub at `my-organization/tap-gitops` on the `main` branch, `tanzu-sync.yaml`
    contains the following information:

    ```yaml
    ---
    git:
     url: git@github.com:my-organization/tap-gitops.git
     ref: origin/main
     sub_path: clusters/iterate-green/cluster-config
    ```

    You can review and edit these values as needed.

4. Review the integration with External Secrets Operator.

    This configuration was generated by the `configure.sh` script. It reported:

    ```console
    ...
    wrote ESO configuration for Tanzu Sync to: tanzu-sync/app/values/tanzu-sync-vault-values.yaml
    ...
    ```

    For example, for the `iterate-green` cluster, if the Vault URL is `https://vault.example.com`,
    `tanzu-sync-vault-values.yaml` contains the following information:

    ```yaml
    ---
    secrets:
     eso:
      vault:
        server: https://vault.example.com
        namespace: ""
        auth:
          kubernetes:
            mountPath: iterate-green
            role: iterate-green--tanzu-sync-secrets
      remote_refs:
        sync_git:
        # TO DO: Fill in your configuration for ssh or basic authentication here. See tanzu-sync/app/config/.tanzu-managed/schema--eso.yaml for details.
        install_registry_dockerconfig:
          dockerconfigjson:
            key: secret/dev/iterate-green/tanzu-sync/install-registry-dockerconfig
    ```

    Where:

    - `kubernetes.role` is the IAM role that grants permission to Tanzu Application Platform installation to read its associated secrets. This role was created in the
    [Grant read access to secret data](#grant-read-access-to-secret-data) section.
    - `install_registry_dockerconfig` contains the Vault secret name that contains the Docker config authentication to 
    the OCI registry hosting the Tanzu Application Platform images created earlier.

5. Replace any `TO DO` sections from line 12 in the earlier example with the relevant values.

    Configuration example for SSH authentication:

    ```yaml
    ---
    secrets:
     eso:
      vault:
        server: https://vault.example.com
        namespace: ""
        auth:
          kubernetes:
            mountPath: iterate-green
            role: iterate-green--tanzu-sync-secrets
      remote_refs:
        sync_git:
          ssh:
            private_key:
              key: secret/dev/iterate-green/tanzu-sync/sync-git/ssh
              property: privatekey
            known_hosts:
              key: secret/dev/iterate-green/tanzu-sync/sync-git/ssh
              property: knownhosts
        install_registry_dockerconfig:
          dockerconfigjson:
            key: secret/dev/iterate-green/tanzu-sync/install-registry-dockerconfig
    ```

    Configuration example for basic authentication:

    ```yaml
    ---
    secrets:
     eso:
      vault:
        server: https://vault.example.com
        namespace: ""
        auth:
          kubernetes:
            mountPath: iterate-green
            role: iterate-green--tanzu-sync-secrets
      remote_refs:
        sync_git:
          basic_auth:
            username:
              key: secret/dev/iterate-green/tanzu-sync/sync-git/basic_auth
              property: username
            password:
              key: secret/dev/iterate-green/tanzu-sync/sync-git/basic_auth
              property: password
        install_registry_dockerconfig:
          dockerconfigjson:
            key: secret/dev/iterate-green/tanzu-sync/install-registry-dockerconfig
    ```

6. Commit the Tanzu Sync configuration.

    For example, for the "iterate-green" cluster, run:

    ```console
    git add tanzu-sync/
    git commit -m 'Configure Tanzu Sync on "iterate-green"'
    ```

### <a id='reviewstore-tap-installation-config'></a>Review and store the Tanzu Application Platform installation config

Configuration for the Tanzu Application Platform installation are stored in two places:

- Sensitive configuration is stored in Vault.
- Non-sensitive configuration is stored in YAML files in the Git repository.

Follow these steps to create the sensitive configuration and review the non-sensitive configuration:

1. Create a secret named `secret/dev/${CLUSTER_NAME}/tap/sensitive-values.yaml` that
stores the sensitive data such as username, password, private key from the `tap-values.yaml` file:

    ```console
    printf '%s\n'  "$(cat <<EOF
    ---
    # this document is intentionally initially blank.
    EOF
    )" | vault kv put secret/dev/${CLUSTER_NAME}/tap/sensitive-values.yaml -
    ```

    You can start with an empty document and edit it later on as described in
    the [Configure and push the Tanzu Application Platform values](#configure-and-push-tap-values) section.

    Vault does not support storing YAML files, all secrets must be in `key-value` format. 
    You must convert your sensitive-values YAML file to `json` before storage.

1. Review the integration with External Secrets Operator.

    This configuration was generated by the `configure.sh` script. It reported:

    ```console
    ...
    wrote Vault configuration for TAP Install to: cluster-config/values/tap-install-vault-values.yaml
    ...
    ```

    For example, for the `iterate-green` cluster `tap-install-vault-values.yaml` contains the following information:

    ```yaml
    ---
    tap_install:
     secrets:
       eso:
        vault:
          server: https://vault.example.com
          namespace: ""
          auth:
            kubernetes:
              mountPath: iterate-green
              role: iterate-green--tap-install-secrets
         remote_refs:
           tap_sensitive_values:
             sensitive_tap_values_yaml:
               key: secret/dev/iterate-green/tap/sensitive-values.yaml
    ```

    Where:

    - `kubernetes.role` is the IAM role that grants permission to Tanzu Application Platform
    installation to read its associated secrets. This role was created in the
    [Grant read access to secret data](#grant-read-access-to-secret-data) section.
    - `sensitive_tap_values_yaml.key` is the Vault secret name that
    contains the sensitive data from the `tap-values.yaml` file for this cluster in a YAML format.

2. Commit the Tanzu Application Platform installation configuration.

    For example, for the `iterate-green` cluster, run:

    ```console
    git add cluster-config/
    git commit -m 'Configure installer for TAP 1.6.0 on "iterate-green"'
    ```

## <a id='configure-and-push-tap-values'></a>Configure and push the Tanzu Application Platform values

The configuration for the Tanzu Application Platform is divided into two separate locations:

- Sensitive configuration is stored in a Vault secret created
  in the [Review and store Tanzu Application Platform installation config](#reviewstore-tap-installation-config) section.
- Non-sensitive configuration is stored in a plain YAML file `cluster-config/values/tap-values.yaml`

Follow these steps to split the Tanzu Application Platform values:

1. Create the file `cluster-config/values/tap-values.yaml` by using the [Full Profile sample](../../install-online/profile.hbs.md#full-profile) as a guide:

    The Tanzu Application Platform values are input configurations to the Tanzu Application Platform installation and are placed under the `tap_install.values` path.

    ```yaml
    tap_install:
      values:
        # Tanzu Application Platform values go here.
        shared:
          ingress_domain: "INGRESS-DOMAIN"
        ceip_policy_disclosed: true
    ...
    ```

    For more information, see [Components and installation profiles](../../about-package-profiles.hbs.md).

1. Review the contents of `tap-values.yaml` and move all the sensitive values into
the Vault secret created in the [Review and store Tanzu Application Platform installation config](#reviewstore-tap-installation-config) section.

    For example, if the `iterate-green` cluster is configured with the basic Out of the Box Supply Chain,
    this might include a passphrase for that supply chain's GitOps flow:

    ```yaml
    ---
    tap_install:
     values:
       ...
       ootb_supply_chain_basic:
         registry:
           server: "SERVER-NAME"
           repository: "REPO-NAME"
         gitops:
           ssh_secret: "SSH-SECRET-KEY"   # Sensitive value. Do not commit to Git repository.
       ...
    ```

    To maintain the secrecy of `ootb_supply_chain_basic.gitops.ssh_secret`,
    move this value from the `tap-values.yaml` file:

    ```yaml
    ---
    tap_install:
     values:
       ...
       ootb_supply_chain_basic:
         registry:
           server: "SERVER-NAME"
           repository: "REPO-NAME"
       ...
    ```

    Add it to the Vault secret named `secret/dev/iterate-green/tap/sensitive-values.yaml`,
    by default, without the `tap_install.values` root:

    ```yaml
    ---
    ...
    ootb_supply_chain_basic:
     gitops:
       ssh_secret: "SSH-SECRET-KEY"
    ...
    ```

    When moving values, you must omit the `tap_install.values` root,
    but keep the remaining structure.
    All of the parent keys, such as `ootb_supply_chain_basic.gitops` and `ssh_secret`, 
    must be copied to the sensitive value YAML.

1. Commit and push the Tanzu Application Platform values:

    ```console
    git add cluster-config/
    git commit -m "Configure initial values for TAP 1.6.0"
    git push
    ```

    Tanzu Sync fetches configuration from the hosted clone of the Git repository.
    For changes to take effect on the cluster, they must be pushed to that clone of the Git repository.

## <a id='deploy-tanzu-sync'></a>Deploy Tanzu Sync

Deploying Tanzu Sync starts the GitOps workflow that initiates the Tanzu Application Platform installation.

After deployed, Tanzu Sync periodically polls the Git repository for changes.
The following deployment process is only required once per cluster:

1. Install the Carvel tools `kapp` and `ytt` onto your `$PATH`:

    ```console
    sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
    sudo cp $HOME/tanzu-cluster-essentials/ytt /usr/local/bin/ytt
    ```

    This step is required to ensure the successful deployment of the `tanzu-sync` App.

1. Ensure the Kubernetes cluster context is set to the correct cluster.

    1. List the existing contexts:

        ```console
        kubectl config get-contexts
        ```

    1. Set the context to the cluster that you want to deploy:

        ```console
        kubectl config use-context CONTEXT-NAME
        ```

        Where `CONTEXT-NAME` can be retrieved from the outputs of the previous step.

1. Bootstrap the deployment.

    External Secrets Operator is installed from the package included in the
    Tanzu Application Plaform package repository.
    That repository must be fetched from the OCI registry initially.

    1. Set the following environment variables:

        ```console
        export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
        export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
        export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
        ```

        Where:

        - `MY-REGISTRY` is your container registry.
        - `MY-REGISTRY-USER` is the user with read access to `MY-REGISTRY`.
        - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.

    1. Create a secret containing credentials to fetch from that OCI registry by using the provided script:

        ```console
        tanzu-sync/scripts/bootstrap.sh
        ```

        These credentials are used exactly once to install the External Secrets Operator (ESO) package.

1. Install Tanzu Sync and start the GitOps workflow by deploying it to the cluster using `kapp` and `ytt`.

    ```console
    tanzu-sync/scripts/deploy.sh
    ```

    Depending on the profile and components included, it may take 5-10 minutes for the Tanzu Application Platform to install.
    During this time, `kapp` waits for the deployment of Tanzu Sync to reconcile successfully. This is normal.

    You can track the progress of the installation by watching the installation of those packages in a separate terminal window:

    ```console
    watch kubectl get pkgi -n tap-install
    ```
