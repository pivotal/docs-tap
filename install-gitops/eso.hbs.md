# Installing Tanzu Application Platform via GitOps with External Secrets Operator (ESO)

>**Caution** Tanzu Application Platform (GitOps)) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

<!-- TODO: use markdown-generated anchor values to ease navigating within VS Code (and validating links). -->

This topic describes how to install Tanzu Application Platform via GitOps with secrets managed in an external secrets store.

>**Caution**
>
> Tanzu GitOps RI does not support changing the secrets management strategy for a cluster. This topic is the ESO based approach to managing secrets in an external secrets store. For help in deciding which approach to use, see [Choosing SoPS or ESO](gitops-reference-docs.hbs.md#choosing-sops-or-eso).
>
> The External Secrets Operator integration in this release of Tanzu GitOps RI has been verified to work with an AWS Elastic Kubernetes Service cluster and AWS Secrets Manager. Other combinations of Kubernetes distribution and ESO Providers have yet to be verified.

## <a id='prerequisites'></a>Prerequisites

Before installing Tanzu Application Platform, ensure you have:

- Completed the [Prerequisites](../prerequisites.html).
- Created [AWS Resources](../aws-resources.hbs.md).
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](../install-tanzu-cli.html) with any required plug-ins.
- Installed [Cluster Essentials for Tanzu](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html).

## <a id='relocate-images-to-a-registry'></a> Relocate images to a registry

VMware recommends relocating the images from VMware Tanzu Network registry to your own container image registry before
attempting installation. If you don't relocate the images, Tanzu Application Platform depends on
VMware Tanzu Network for continued operation, and VMware Tanzu Network offers no uptime guarantees.
The option to skip relocation is documented for evaluation and proof-of-concept only.

The supported registries are Harbor, Azure Container Registry, Google Container Registry,
and Quay.io.
See the following documentation for a registry to learn how to set it up:

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
    - `TARGET-REPOSITORY` is your target repository, a folder/repository on `MY-REGISTRY` that serves as the location
    for the installation files for Tanzu Application Platform.

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

## <a id='create-a-new-git-repository'></a>Create a new git repository

1. In a hosted git service (like GitHub or GitLab), create a new respository.

    This version of Tanzu GitOps RI only supports authenticating to a hosted Git repository via SSH.

1. Initialize a new git repository

    Example:

    ```console
    mkdir -p $HOME/tap-gitops
    cd $HOME/tap-gitops

    git init
    git remote add origin git@github.com:my-organization/tap-gitops.git
    ```

1. Create a read-only "Deploy Key" for this new repo (recommended) or "SSH Key" for an account with read access to this repository.

    The private portion of this key will be referred below as GIT_SSH_PRIVATE_KEY.

## <a id='download-and-unpack-tanzu-gitops-ri'></a>Download and unpack Tanzu GitOps RI

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

1. Seed configuration for a cluster using ESO (e.g. via the convenience script provided):

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh CLUSTER-NAME eso
    ```

    Where:

    - `CLUSTER-NAME` a name for your cluster. Typically, this is the same as your EKS cluster's name -- the name of the cluster as it appears in `eksctl get clusters`.
    - `eso` selects the External Secrets Operator-based secrets management variant.

    For example, if the name of your cluster is "iterate-green":

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh iterate-green eso
    ```

    This script creates the directory `clusters/iterate-green/` and copies in the configuration required to sync this git repository with the cluster as well as installing Tanzu Application Platform.

2. Commit and push:

    Saving the base configuration in an initial commit makes it easier to review customizations, later.

    ```console
    git add . && git commit -m 'Add "iterate-green" cluster'
    git push
    ```

## <a id='customize-cluster-configuration'></a>Customize cluster configuration

The remainder of the setup is performed from within the directory that was just created:

```console
cd clusters/CLUSTER-NAME
```

For example, if the name of your cluster is "iterate-green":

```console
cd clusters/iterate-green
```

Configuring the install of Tanzu Application Platform involves setting up two components:

- an installation of Tanzu Application Platform
- an instance of Tanzu Sync -- the component that implements the GitOps workflow, fetching configuration from Git and applying it to the cluster.

To ease this setup, define the following environment variables

```console
export AWS_ACCOUNT_ID=MY-AWS-ACCOUNT-ID
export AWS_REGION=AWS-REGION
export EKS_CLUSTER_NAME=EKS-CLUSTER-NAME
export TAP_PKGR_REPO=TAP-PACKAGE-OCI-REPOSITORY
```

Where:

- `MY-AWS-ACCOUNT-ID` is your AWS account ID as it appears in the output of `aws sts get-caller-identity`.
- `AWS-REGION` is the region where the Secrets Manager is and EKS cluster has been created.
- `EKS-CLUSTER-NAME` is the name of the target cluster as it appears in the output of `eksctl get clusters`.
- `TAP-PACKAGE-OCI-REPOSITORY` is the fully-qualified path to the OCI repository hosting the Tanzu Application Platform images. If those have been relocated as described above, then this value is `${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}/tap-packages`.

### <a id='grant-read-access-to-secret-data'></a>Grant read access to secret data

All sensitive configuration is stored in AWS Secrets Manager secrets.
Both Tanzu Sync and the TAP installation need a means of accessing sensitive data stored in AWS Secrets Manager.

The following implements the [IAM Role for a Service Account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) configuration:

1. In AWS Identity and Access Manager, create two IAM Policies: one to read Tanzu Sync secrets and another to read TAP installation secrets.

    This can be done using the supplied script:

    ```console
    tanzu-sync/scripts/aws/create-policies.sh
    ```

2. Create two IAM Role-to-Service Account pairs for your cluster: one for Tanzu Sync and anther for the TAP installation.

    For your convenience, this is also scripted:

    ```console
    tanzu-sync/scripts/aws/create-irsa.sh
    ```

    For example, if the name of the EKS cluster is "iterate-green" and using the defaults, there will now be two IAM roles in the AWS account:

    ```json
    $ aws iam list-roles --query 'Roles[?starts_with(RoleName,`iterate-green`)]'
    [
       {
           "RoleName": "iterate-green--tanzu-sync-secrets",
           ...
       },
       {
           "RoleName": "iterate-green--tap-install-secrets",
           ...
       }
    ]
    ```

### <a id='generate-default-configuration'></a>Generate default configuration

To get started quickly, use the following script to generate default configuration for the both Tanzu Sync and Tanzu Application Platform installation:

```console
tanzu-sync/scripts/configure.sh
```

The following sections walk through how to adjust those values (if necessary).

### <a id='reviewstore-tanzu-sync-config'></a>Review/Store Tanzu Sync config

Configuration for Tanzu is stored in two locations:

- sensitive configuration is stored in AWS Secrets Manager;
- non-sensitive configuration are stored in YAML files in the git repository.

Create the sensitive configuration and review the non-sensitive configuration as follows:

1. Save the credentials Tanzu Sync should use to authenticate with the Git repository:

    Create a secret named `dev/EKS-CLUSTER-NAME/tanzu-sync/sync-git-ssh` containing (as plaintext):

    ```json
    {
     "ssh-privatekey": "... (private key portion here) ...",
     "ssh-knownhosts": "... (known_hosts for git host here) ..."
    }
    ```

    Where `EKS-CLUSTER-NAME` is the name as it appears in `eksctl get clusters`

    For example, if the git repository is hosted on GitHub, and the private key created in [Create a new git repository](#create-a-new-git-repository), above, is stored in the file `~/.ssh/id_ed25519`:

    ```console
    aws secretsmanager create-secret \
       --name dev/${EKS_CLUSTER_NAME}/tanzu-sync/sync-git-ssh \
       --secret-string "$(cat <<EOF
    {
     "ssh-privatekey": "$(cat ~/.ssh/id_ed25519 | awk '{printf "%s\\\\n", $0}')",
     "ssh-knownhosts": "$(ssh-keyscan github.com | awk '{printf "%s\\\\n", $0}')"
    }
    EOF
    )"
    ```

    Where:

    - the contents of `~/.ssh/id_ed25519` is the private portion of the SSH key.
    - `ssh-keyscan` obtains the public keys for the SSH host.
    - `awk '{printf "%s\\n", $0}'` converts a multiline string into a single-line string with embedded newline chars (`\n`). JSON does not support multiline strings.

    >**Caution**
    >
    > This version of Tanzu GitOps RI only supports authenticating to a hosted Git repository via SSH. Authenticating via HTTP Basic Authentication is not yet supported.

2. Save credentials used to authenticate with the OCI registry hosting the Tanzu Application Platform images:

    Create a secret named `dev/EKS-CLUSTER-NAME/tanzu-sync/install-registry-dockerconfig` containing (as plaintext):

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

    - `EKS-CLUSTER-NAME` is the name as it appears in `eksctl get clusters`
    - `MY-REGISTRY-USER` is the user with write access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `MY-REGISTRY` is the container registry to which the Tanzu Application Platform images are located.

    For example:

    ```console
    aws secretsmanager create-secret \
       --name dev/${EKS_CLUSTER_NAME}/tanzu-sync/install-registry-dockerconfig \
       --secret-string "$(cat <<EOF
    {
     "auths": {
       "${INSTALL_REGISTRY_HOSTNAME}": {
         "username": "${INSTALL_REGISTRY_USERNAME}",
         "password": "${INSTALL_REGISTRY_PASSWORD}"
       }
     }
    }
    EOF
    )"
    ```

3. Review the hosted git URL and branch Tanzu Sync should use:

    This configuration was generated by the `configure.sh` script.

    It reported:

    ```console
    ...
    wrote non-sensitive Tanzu Sync configuration to: tanzu-sync/app/values/tanzu-sync.yaml
    ...
    ```

    For example, for the "iterate-green" cluster if this git repository is hosted on GitHub at `my-organization/tap-gitops`
    on the `main` branch, `tanzu-sync.yaml` would contain:

    ```yaml
    ---
    git:
     url: git@github.com:my-organization/tap-gitops.git
     ref: origin/main
     sub_path: clusters/iterate-green/cluster-config
    ```

    Review and adjust these values as necessary.

4. Review the integration with External Secrets Operator.

    This configuration was generated by the `configure.sh` script.

    It reported:

    ```console
    ...
    wrote ESO configuration for Tanzu Sync to: tanzu-sync/app/values/tanzu-sync-eso.yaml
    ...
    ```

    For example, for the "iterate-green" cluster, if the AWS account is 665100000000, then `tanzu-sync-eso.yaml` would contain:

    ```yaml
    ---
    secrets:
     eso:
       aws:
         region: us-west-2
         tanzu_sync_secrets:
           role_arn: arn:aws:iam::665100000000:role/iterate-green--tanzu-sync-secrets
       remote_refs:
         sync_git_ssh:
           ssh_private_key:
             key: dev/iterate-green/tanzu-sync/sync-git-ssh
             property: ssh-privatekey
           ssh_known_hosts:
             key: dev/iterate-green/tanzu-sync/sync-git-ssh
             property: ssh-knownhosts
         install_registry_dockerconfig:
           dockerconfigjson:
             key: dev/iterate-green/tanzu-sync/install-registry-dockerconfig
    ```

    Where:

    - `role_arn` is the IAM role that grants permission to Tanzu Sync to read secrets specific to Tanzu Sync. This role was created in the [Grant Tanzu Sync and TAP installation read access to secret data](#grant-read-access-to-secret-data) step, above.
    - `ssh_private_key` is the AWS Secrets Manager secret name (aka "key") and JSON property that contains the private key portion of the SSH authentication to the git repository (created above).
    - `ssh_known_hosts` is the AWS Secrets Manager secret name (aka "key") and JSON property that contains the known host entries for the SSH authentication to the git repository (created above).
    - `install_registry_dockerconfig` contains the AWS Secrets Manager secret name that contains the Docker config authentication to the OCI registry hosting the Tanzu Application Platform images (created above).

    Review and adjust these values as necessary.

5. Commit the Tanzu Sync configuration

    For example, for the "iterate-green" cluster:

    ```console
    git add tanzu-sync/
    git commit -m 'Configure Tanzu Sync on "iterate-green"'
    ```

### <a id='reviewstore-tap-installation-config'></a>Review/Store TAP installation config

Configuration for the Tanzu Application Platform installation are stored in two places:

- sensitive configuration is stored in AWS Secrets Manager;
- non-sensitive configuration is stored in YAML files in the git repository.

Create the sensitive configuration and review the non-sensitive configuration as follows:

1. Save the "sensitive values" for the Tanzu Application Platform installation:

    Create a secret named `dev/${EKS_CLUSTER_NAME}/tap/sensitive-values.yaml` that will contain the sensitive portion of the "TAP values" configuring the Tanzu Application Platform. These are values that might have gone in the `tap-values.yaml` file but are sensitive data (e.g. username and password, private key, etc.).

    This value can be initially an empty document and updated later in the [configuring TAP values](#configure-and-push-tap-values) step:

    ```console
    aws secretsmanager create-secret \
       --name dev/${EKS_CLUSTER_NAME}/tap/sensitive-values.yaml \
       --secret-string "$(cat <<EOF
    ---
    # this document is intentionally initially blank.
    EOF
    )"
    ```

2. Review the integration with External Secrets Operator.

    This configuration was generated by the `configure.sh` script.

    It reported:

    ```console
    ...
    wrote ESO configuration for TAP Install to: cluster-config/values/tap-install-eso-values.yaml
    ...
    ```

    For example, for the "iterate-green" cluster, if the AWS account is 665100000000, then `tap-install-eso-values.yaml` would contain:

    ```yaml
    ---
    tap_install:
     secrets:
       eso:
         aws:
           region: us-west-2
           tap_install_secrets:
             role_arn: arn:aws:iam:665100000000:iterate-green--tap-install-secrets
         remote_refs:
           tap_sensitive_values:
             sensitive_tap_values_yaml:
               key: dev/iterate-green/tap/sensitive-values.yaml
    ```

    Where:

    - `role_arn` is the IAM role that grants permission to Tanzu Application Platform installation to read its associated secrets. This role was created in the [Grant Tanzu Sync and TAP installation read access to secret data](#grant-read-access-to-secret-data) step, above.
    - `sensitive_tap_values_yaml.key` is the AWS Secrets Manager secret name that contains the _sensitive_ portion of the TAP values for this cluster in a YAML format.

    Review and adjust these values as necessary.

3. Commit the Tanzu Application Platform installation configuration.

    For example, for the "iterate-green" cluster:

    ```console
    git add cluster-config/
    git commit -m 'Configure installer for TAP 1.5.0 on "iterate-green"'
    ```

## <a id='configure-and-push-tap-values'></a>Configure and push TAP values

Configuration for the Tanzu Application Platform, itself, is split into two locations:

- sensitive configuration is stored in a AWS Secrets Manager secret created as part of [storing configuration for TAP installation](#reviewstore-tap-installation-config).
- non-sensitive configuration is in a plain YAML file located at `cluster-config/values/tap-values.yaml`

Split the the "TAP values" in this way:

1. Create the file `cluster-config/values/tap-values.yaml` using the [Full Profile (AWS)](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/install-aws.html#full-profile) which contains the minimum configurations required to deploy Tanzu Application Platform on AWS.

    >**Important**
    >
    > TAP values are input configuration to the TAP installation.
    > As such, they are placed under the `tap_install.values` path.
    >
    > ```yaml
    > tap_install:
    >   values:
    >     # TAP values go here
    >     shared:
    >       ingress_domain: "INGRESS-DOMAIN"
    >     ceip_policy_disclosed: true
    > ...
    > ```
    >
    > The [Components and installation profiles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/{{ vars.url_version }}/tap/about-package-profiles.html) details the Tanzu Application Platform profiles and component configuration.

1. Review the contents of `tap-values.yaml`. Move _all_ sensitive values into the AWS Secrets Store secret created in [Review/configuration for TAP installation](#reviewstore-tap-installation-config).

    For example, if the "iterate-green" cluster is being configured with the basic Out of the Box Supply Chain, this may include a passphrase for that supply chain's GitOps flow:

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
           ssh_secret: "SSH-SECRET-KEY"   # <== sensitive value; do not commit to git repository!
       ...
    ```

    To maintain the secrecy of `ootb_supply_chain_basic.gitops.ssh_secret`, move this value from the `tap-values.yaml` file:

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

    And include it in the contents of the AWS Secrets Store secret named `dev/iterate-green/tap/sensitive-values.yaml` (by default) without the `tap_install.values` root:

    ```yaml
    ---
    ...
    ootb_supply_chain_basic:
     gitops:
       ssh_secret: "SSH-SECRET-KEY"
    ...
    ```

    Put the updated secret value using a method described in [Modify an AWS Secrets Manager secret](https://docs.aws.amazon.com/secretsmanager/latest/userguide/manage_update-secret.html).

    When moving values, omit the `tap_install.values` root, but keep the remaining structure: all of the parent keys (e.g. `ootb_supply_chain_basic.gitops`) of the moved value (e.g. `ssh_secret`) must be copied to the sensitive value YAML.

1. Commit and push the Tanzu Application Platform values:

    ```console
    git add cluster-config/
    git commit -m "Configure initial values for TAP 1.5.0"
    git push
    ```

    Tanzu Sync will fetch configuration from the hosted clone of the git repository.
    For changes to take effect on the cluster, they must be pushed to that clone of the git repository.

## <a id='deploy-tanzu-sync'></a>Deploy Tanzu Sync

Deploying Tanzu Sync initiates the GitOps workflow. This will begin installing the Tanzu Application Platform.

Once deployed, Tanzu Sync will periodically poll the git repository for changes. This deployment step is only required once per cluster.

1. Install the Carvel tools `kapp` and `ytt` onto your `$PATH`:

    ```console
    sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
    sudo cp $HOME/tanzu-cluster-essentials/ytt /usr/local/bin/ytt
    ```
    These are required to deploy the `tanzu-sync` App correctly.

1. Ensure the Kubernetes cluster context is set to the EKS cluster

    1. List the existing contexts:

        ```console
        kubectl config get-contexts
        ```

    1. Set the context to the cluster that you want to deploy (if not already the current):

        ```console
        kubectl config use-context CONTEXT-NAME
        ```

        Where `CONTEXT-NAME` can be retrieved from the outputs of the previous step.

1. Bootstrap the deployment.

    External Secrets Operator will be installed from the package included in the Tanzu Application Plaform package repository.
    That repository must first be fetched from the OCI registry.

    Ensure the following environment variables are set:

    ```console
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    ```

    Where:

    - `MY-REGISTRY` is your container registry.
    - `MY-REGISTRY-USER` is the user with read access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.

    Create a secret containing credentials used to fetch from that OCI registry.

    This can be done with the script provided:

    ```console
    tanzu-sync/scripts/bootstrap.sh
    ```

    These credentials are used exactly once to install the External Secrets Operator (ESO) package.

1. Install Tanzu Sync and start the GitOps workflow by deploying it to the cluster using `kapp` and `ytt`.

    For your convenience, this script is provided:

    ```console
    tanzu-sync/scripts/deploy.sh
    ```

Depending on the profile and components included, it may take 5-10 minutes for the Tanzu Application Platform to install.
During this time, `kapp` waits for the deployment of Tanzu Sync to reconcile successfully. This is normal.

You can track the progress of the installation by watching the installation of those packages in a separate terminal window:

```console
watch kubectl get pkgi -n tap-install
```

{{#unless vars.hide_content}}

<!-- TODO: Write a "How-To" guide for changing the names of AWS Resources -->
<!-- ## <a id='custom-aws-resource-names'></a>Using Custom Names for AWS Resources

The following sections describe creating a set of secrets in AWS Secrets Manager. Once a secret is created in AWS Secrets Manager, it cannot be renamed; it must be recreated under a new name.

The default names for the required AWS Secrets Manager Secrets are:
- `dev/EKS-CLUSTER-NAME/tanzu-sync/sync-git-ssh` : SSH authentication credentials to the hosted git repository
- `dev/EKS-CLUSTER-NAME/tanzu-sync/install-registry-dockerconfig` : OCI registry credentials to be used to install Tanzu Application Platform packages
- `dev/EKS-CLUSTER-NAME/tap/sensitive-values.yaml` : the portion of TAP values that are sensitive

where `EKS-CLUSTER-NAME` is the name of the cluster as it appears in `eksctl get clusters`

If this convention meets the need, follow the instructions below, as is.

If another convention is needed:
- replace the default name with the custom one while following the instructions -->

{{/unless}}
