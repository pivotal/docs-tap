# Working with Private Git Repositories

## Git Authentication for using a private Git repository

Namespaces provisioner enables users to use private git repositories for storing their Gitops based installation files as well as additional platform operator templated resources that they want to create in their developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning` namespace, or an existing secret in another namespace referred to in the secretRef in the additional sources (See [Customize Installation](#heading=h.lc08xegj8s5n) for more details).

### Create the Git Authentication secret in tap-namespace-provisioning namespace.

The secrets for Git authentication allow the following keys:

- ssh-privatekey
- ssh-knownhosts
>**Note** if ssh-knownhosts is not specified, Git will not perform strict host checking.
-  username
- password

Using HTTP(s) based Authentication
: If using Username and Password for authentication, create the git secret with authentication details as follows:

    ```console
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: git-auth
    namespace: tap-namespace-provisioning
    type: Opaque
    stringData:
    username: GIT-USERNAME
    password: GIT-PASSWORD
    EOF
    ```

Using SSH based Authentication
: If using SSH private key for authentication, create the git secret with authentication details as follows:

    ```console
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: git-auth
    namespace: tap-namespace-provisioning
    type: Opaque
    stringData:
    ssh-privatekey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        ..
        -----END OPENSSH PRIVATE KEY-----
    EOF
    ```

Next, Add the` secretRef` section to the` additional_sources` and the `gitops_install` section of the Namespace Provisioner configuration in your TAP values: <!--is this outside tabs-->

Using Namespace Provisioner Controller
: Description

    ```console
    namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: sources
        # This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
            name: git-auth
        path: _ytt_lib/my-additional-source
    ```

Using GitOps
: Description

    **Caution** There is a current limitation in kapp-controller which does not allow the users to re-use the same git secret multiple times. If you have multiple additional sources using private repo with the same credentials, you will have to create different secrets with the same authentication details for each of them.

    In our example, the location where our list of namespace reside is also a private repository. So we will create a secret named` git-auth-install` with the same authentication details.

    ```console
    namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: tekton-pipelines
        # This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
            name: git-auth
        path: _ytt_lib/my-additional-source
    gitops_install:
        ref: origin/main
        subPath: gitops-install
        # This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
        name: git-auth-install
    ```

### Import from another namespace

If you already have a Git secret created in a namespace other than `tap-namespace-provisioning `namespace and you want to refer to that, the secretRef section should have the namespace mentioned along with the` create_export` flag. The default value for create_export is false as it assumes the Secret is already exported for tap-namespace-provisioning namespace, but allows the user to specify if they want the Namespace Provisioner to create a` Carvel SecretExport` for that secret.

Find the below example referring to `git-auth` secret from `tap-install` in the secretRef section.

Using Namespace Provisioner Controller
: Description

    ```console
    namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: sources
        #! This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
            name: git-auth
            namespace: tap-install
            #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
            create_export: true
        path: _ytt_lib/my-additional-source
    ```

Using GitOps
: Description

    ```console
    namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: tekton-pipelines
        #! This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
            name: git-auth
            namespace: tap-install
            #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
            create_export: true
        path: _ytt_lib/my-additional-source
    gitops_install:
        ref: origin/main
        subPath: gitops-install
        #! This example URL is for SSH auth. Use https:// path if using HTTPS auth
        url: git@github.com:private-repo-org/repo.git
        secretRef:
        name: git-auth-install
        namespace: tap-install
        #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
        create_export: true
    ```

After reconciling, Namespace Provisioner will create:

* [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) for the secret in the provided namespace (tap-install in the above example) to the Namespace Provisioner namespace.
* [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) for the secret in Namespace Provisioning namespace (tap-namespace-provisioning) so Carvel [secretgen-controller](https://github.com/carvel-dev/secretgen-controller) can create the required secret for the Provisioner to connect to the Private Git Repository.

## Git Authentication for Private Repository for Workloads and Supply chain

To either fetch or push source code from or to a repository that requires credentials, you must provide those through a Kubernetes secret object referenced by the intended Kubernetes object created for performing the action. The following sections provide details about how to appropriately set up Kubernetes secrets for carrying those credentials forward to the proper resources.

This section provides instructions on how to configure the `default` service account to work with private git repositories for workloads and supply chain using Namespace Provisioner.

To configure the service account to work with private git repositories, follow the steps below:

* Create a secret in the `tap-install` namespace (or any namespace of your preference) that contains the Git credentials in the YAML format.
    * `host`, `username` and `password` values for HTTP based Git Authentication.
    * `ssh-privatekey, identity, identity_pub`, and `known_hosts` for SSH based Git Authentication.

>**Note**: stringData key of the secret must have **.yaml** or **.yml** suffix at the end.

Using HTTP(s) based Authentication
: If using Username and Password for authentication, create the git secret with authentication details as follows:

    ```console
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: workload-git-auth
    namespace: tap-install
    type: Opaque
    stringData:
    content.yaml: |
        git:
        #! For HTTP Auth. Recommend using https:// for the git server.
        host: GIT-SERVER
        username: GIT-USERNAME
        token: GIT-PASSWORD
    EOF
    ```

Using SSH based Authentication
: If using SSH private key for authentication, create the git secret with authentication details as follows:

    ```console
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: workload-git-auth
    namespace: tap-install
    type: Opaque
    stringData:
    content.yaml: |
        git:
        #! For SSH Auth
        ssh_privatekey: SSH-PRIVATE-KEY
        identity: SSH-PRIVATE-KEY
        identity_pub: SSH-PUBLIC-KEY
        known_hosts: GIT-SERVER-PUBLIC-KEYS

    EOF
    ```

    *  We will create a scaffolding of a Git secret that needs to be added to the service account in our developer namespace in our GitOps repository. See the [sample secret here.](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/credentials/git.yaml) An example secret would look like the following. Instead of putting the actual username and password in the secret in our Git repository, we will put the reference to the values in the git-auth secret created in Step 1 by using the `data.values.imported` keys.

    ```console
    #@ load("@ytt:data", "data")
    ---
    apiVersion: v1
    kind: Secret
    metadata:
    name: git
    annotations:
        tekton.dev/git-0: #@ data.values.imported.git.host
    type: kubernetes.io/basic-auth
    stringData:
    username: #@ data.values.imported.git.username
    password: #@ data.values.imported.git.token
    ```

    * We will create a secret to specify an overlay to patch the default service account adding reference to the secret **git**.

    ```console
    cat << EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: workload-git-auth-overlay
    namespace: tap-install
    annotations:
        kapp.k14s.io/change-rule: "delete after deleting tap"
    stringData:
    workload-git-auth-overlay.yaml: |
    #@ load("@ytt:overlay", "overlay")
    #@overlay/match by=overlay.subset({"apiVersion": "v1", "kind": "ServiceAccount","metadata":{"name":"default"}}), expects="0+"
    ---
    secrets:
    #@overlay/append
    - name: git
    EOF
    ```

* We will now put all this together in Namespace Provisioner configuration in TAP values as follows:<!--is this outside tabs-->

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values

    ```console
    namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/credentials
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/credentials-setup
    import_data_values_secrets:
    - name: workload-git-auth
        namespace: tap-install
        create_export: true
    overlay_secrets:
    - name: workload-git-auth-overlay
        namespace: tap-install
        create_export: true
    ```

Using GitOps
: Add the following configuration to your TAP values

    ```console
    namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/credentials
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/credentials-setup
    gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    import_data_values_secrets:
    - name: workload-git-auth
        namespace: tap-install
        create_export: true
    overlay_secrets:
    - name: workload-git-auth-overlay
        namespace: tap-install
        create_export: true
    ```

    * First additional source points to the location where our templated git secret resides which will be created in all developer namespaces.
    * Second additional source points to the overlay file which will add the git secret onto the default service account
    * Finally, import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets` (See the [Templating additional sources](#heading=h.bcqllo8t167x) for more details)

    >**Note** `create_export` is set to` true` in `import_data_values_secrets` meaning that a SecretExport will be created for the `workload-git-auth` secret in the tap-install namespace automatically by Namespace Provisioner. After the changes are reconciled, you should see the secret named **git **in all provisioned namespaces and also added to the default service account of those namespaces.