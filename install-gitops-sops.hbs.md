# Installing Tanzu Application Platform via Gitops with SoPS

This topic describes how to install Tanzu Application Platform via Gitops with secrets managed in a git repository.

>**Caution** 
>
> Tanzu GitOps RI does not support changing the secrets management strategy for a cluster. This topic is the ESO based approach to managing secrets in an external secrets store.

## <a id='prereqs'></a>Prerequisites

Before installing Tanzu Application Platform, you need:

<!-- TODO: link to download instructions -->
- SoPS CLI. The SoPS CLI is used to view and edit SoPS encrypted files. To install the SoPS CLI, see [Installation](https://github.com/mozilla/sops/releases).
- Age CLI. The Age CLI is used to create an ecryption key used to encrypt and decrypt sensitive data. To install the Age CLI, see [Installation](https://github.com/FiloSottile/age#installation).
- Completed the [Prerequisites](prerequisites.html).
- [Accepted Tanzu Application Platform EULA and installed Tanzu CLI](install-tanzu-cli.html) with any required plug-ins.
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


## <a id='initialize-git-repository'></a>Create a new git repository

1. In a hosted git service (like GitHub or GitLab), create a new respository.

   >**Note** 
   >
   > This version of Tanzu GitOps RI only supports authenticating to a hosted Git repository via SSH. Support for authenticating using HTTP Basic Auth will be added in a later version.

2. Initialize a new git repository.

    Example:

    ```console
    mkdir -p $HOME/tap-gitops
    cd $HOME/tap-gitops
    
    git init
    git remote add origin git@github.com:my-organization/tap-gitops.git
    ```

3. Create a read-only "Deploy Key" for this new repo (recommended) or "SSH Key" for an account with read access to this repository.

    >**Note** The private portion of this key will be referred to as GIT_SSH_PRIVATE_KEY.

## <a id='download-tanzu-gitops-ri'></a>Download and unpack Tanzu GitOps RI

1. Sign in to [VMware Tanzu Network](https://network.tanzu.vmware.com).
2. Go to the [Tanzu Application Platform product page](https://network.tanzu.vmware.com/products/tanzu-application-platform).
3. Select **Release {{ vars.tap_version }}** from the release drop-down menu.
4. Click **Tanzu Gitops Reference Implementation**.
5. Unpack the downloaded TGZ file into the `$HOME/tap-gitops` directory by running:
   ```console
   tar -xvf tanzu-gitops-ri-0.0.3.tgz -C $HOME/tap-gitops
   ```
6. Commit the initial state:
   ```console
   cd $HOME/tap-gitops

   git add . && git commit -m "Initialize Tanzu GitOps RI"
   git push -u origin
   ```
     
## <a id=''></a>Create cluster configuration

1. Seed configuration for a cluster using SoPS (e.g. using the convenience script provided)::

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh CLUSTER-NAME sops
    ```
    
    Where:
    
    - `CLUSTER-NAME` the name of your cluster.
    - `sops` selects the Secrets OPerationS-based secrets management variant.

    Example:

    ```console
    cd $HOME/tap-gitops

    ./setup-repo.sh full-tap-cluster sops
    Created cluster configuration in ./clusters/full-tap-cluster.
    ...
    ```
    This script creates the directory `clusters/full-tap-cluster/` and copies in the configuration required to sync this git repository with the cluster as well as installing Tanzu Application Platform.

2. Commit and push:

    ```console
    git add . && git commit -m "Add full-tap-cluster"
    git push
    ```

## <a id='tap-config'></a>Configure Tanzu Application Platform

Tanzu Sync RI splits the values configuration of Tanzu Application Platform into two categories:

1. Sensitive TAP values (credentials, encryptions keys etc.)
2. Non-sensitive TAP values (packages to exclude, namespace configuration etc.)

The following steps walk through creating these values files.

## <a id='prep-sensitive-tap-values'></a>Preparing sensitive TAP values

1. Generate Age public/secrets keys:

    >**Note** Skip this step if you already have an Age key you wish to use to encrypt/decrypt secrets.

    ```console
    mkdir -p $HOME/tmp-enc
    chmod 700 $HOME/tmp-enc
    cd $HOME/tmp-enc

    age-keygen -o key.txt
    
    cat key.txt
    # created: 2023-02-08T10:55:35-07:00
    # public key: age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
    AGE-SECRET-KEY-my-secret-key
    ```

2. Create a plain YAML file (named `tap-sensitive-values.yaml`) that contains a placeholder for the sensitive portion of TAP values:
   
    ```yaml
    ---
    tap_install:
      sensitive_values:
    ```

3. Encrypt `tap-sensitive-values.yaml` with Age using SoPS:

    ```console
    export SOPS_AGE_RECIPIENTS=$(cat key.txt | grep "# public key: " | sed 's/# public key: //')
    sops --encrypt tap-sensitive-values.yaml > tap-sensitive-values.sops.yaml
    ```

    Where:

    - `grep` is used to find the line containing the public key portion of the generated secret.
    - `sed` is used to extract the public key from the line found by `grep`.

4. (Optional) Verify the encrypted file can be decrypted:
   
    ```console
    export SOPS_AGE_KEY_FILE=key.txt
    sops --decrypt tap-sensitive-values.sops.yaml
    ```

    and can be edited directly using SoPS:

    ```console
    sops tap-sensitive-values.sops.yaml
    ```
 
5. Move the sensitive TAP values into the cluster config:

    ```console
    mv tap-sensitive-values.sops.yaml <GIT-REPO-ROOT>/clusters/<CLUSTER-NAME>/cluster-config/values/
    ```

    Example:

    ```console
    mv tap-sensitive-values.sops.yaml $HOME/tap-gitops/clusters/full-tap-cluster/cluster-config/values/
    ```

6. (Optional) Retain the Age identity (key file) in a safe and secure place (e.g. a password manager) and purge the scratch space:

    ```console
    mv key.txt SAFE-LOCATION/
    export SOPS_AGE_KEY_FILE=SAFE-LOCATION/key.txt
    rm -rf $HOME/tmp-enc
    ```

## <a id='prep-non-sensitive-tap-values'></a> Preparing non-sensitive TAP values

1. Create a plain YAML file (e.g. `<GIT-REPO-ROOT>/clusters/<CLUSTER-NAME>/cluster-config/values/tap-non-sensitive-values.yaml`) using the [Full Profile sample](install.md#full-profile) as a guide:

    Example (abridged):
    
    ```
    ---
    tap_install:
      values:
        ceip_policy_disclosed: true
        excluded_packages:
        - policy.apps.tanzu.vmware.com
    ...
    ```

## <a id='update-sensitive-tap-values'></a> Updating sensitive TAP values

Now that we have filled in our non-sensitive values, let's extract any sensitive values into `tap-sensitive-values.sops.yaml` we prepared earlier:

  1. Open an editor via SoPS to edit the encrypted sensitive values file:
  
      ```console
      sops <GIT-REPO-ROOT>/clusters/<CLUSTER-NAME>/cluster-config/values/tap-sensitive-values.sops.yaml
      ```

      Example:

      ```console
      sops $HOME/tap-gitops/clusters/full-tap-cluster/cluster-config/values/tap-sensitive-values.sops.yaml
      ```

  2. Add our sensitive values:

      Example with our container registry credentials using basic authentication:

      ```yaml
      ---
      tap_install:
       sensitive_values:
         shared:
           image_registry:
             project_path: "example.com/my-project/tap"
             username: "my_username"
             password: "my_password"
      ```

      Example with our container registry credentials using Google Container Registry:

      ```yaml
      ---
      tap_install:
       sensitive_values:
        shared:
          image_registry:
             project_path: "gcr.io/my-project/tap"
             username: "_json_key"
             password: |
               {
                 "type": "service_account",
                 "project_id": "my-project",
                 "private_key_id": "my-private-key-id",
                 "private_key": "-----BEGIN PRIVATE KEY-----\n..........\n-----END PRIVATE KEY-----\n",
                 ...
               }
      ```

## <a id='generate-tap-config'></a>Generate TAP installation and Tanzu Sync configuration

1. Set up environment variables by running:

    ```console
    export INSTALL_REGISTRY_HOSTNAME=MY-REGISTRY
    export INSTALL_REGISTRY_USERNAME=MY-REGISTRY-USER
    export INSTALL_REGISTRY_PASSWORD=MY-REGISTRY-PASSWORD
    export GIT_SSH_PRIVATE_KEY=PRIVATE-KEY
    export GIT_KNOWN_HOSTS=KNOWN-HOST-LIST
    export SOPS_AGE_KEY=AGE-KEY
    ```

    Where:

    - `MY-REGISTRY` is your container registry.
    - `MY-REGISTRY-USER` is the user with read access to `MY-REGISTRY`.
    - `MY-REGISTRY-PASSWORD` is the password for `MY-REGISTRY-USER`.
    - `PRIVATE-KEY` is the contents of an ssh private key file with read access to your git repository.
    - `HOST-LIST` is the list of known hosts for Git host service.
    - `AGE-KEY` is the contents of the Age key generated earlier.

    Example with the Git repo hosted on GitHub:

    ```console
    export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
    export INSTALL_REGISTRY_USERNAME=foo@example.com
    export INSTALL_REGISTRY_PASSWORD=my-password
    export GIT_SSH_PRIVATE_KEY=$(cat $HOME/.ssh/my_private_key)
    export GIT_KNOWN_HOSTS=$(ssh-keyscan github.com)
    export SOPS_AGE_KEY=$(cat $HOME/key.txt)
    ```

2. Generate the TAP Install and Tanzu Sync configuration files 

    ```console
    ./tanzu-sync/scripts/configure.sh
    ```

    >**Note** `configure.sh` has been provided as a convenient way to generate the data files needed, see the Advanced section to populate these without this script.

3. Commit the generated configured to git repository:

    ```console
    git add cluster-config/ tanzu-sync/
    git commit -m "Configure install of TAP 1.5.0"
    git push
    ```

## <a id='deploy-tanzu-synci'></a>Deploy Tanzu Sync

1. Install the Carvel tools `kapp` and `ytt` onto your `$PATH`:

   ```console
   sudo cp $HOME/tanzu-cluster-essentials/kapp /usr/local/bin/kapp
   sudo cp $HOME/tanzu-cluster-essentials/ytt /usr/local/bin/ytt
   ```

2. Set the Kubernetes cluster context

   1. List the existing contexts:
      ```console
      kubectl config get-contexts
      ``` 
   2. Set the context to the cluster that you want to deploy
      ```console
      kubectl config use-context CONTEXT-NAME
      ``` 
      Where CONTEXT-NAME can be retrieved from the outputs of the previous step.

3. Deploy the "Tanzu Sync" component:

    ```console
    ./tanzu-sync/scripts/deploy.sh
    ```

    >**Note**
    >
    > Depending on the profile and components included, it may take 5-10 minutes for Tanzu Application Platform to install.
    > During this time, `kapp` waits for the deployment of Tanzu Sync to reconcile successfully. This is normal.
