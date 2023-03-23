# Working with Private Git Repositories

## Git Authentication for using a private Git repository

Namespaces provisioner enables users to use private git repositories for storing their Gitops based installation files as well as additional platform operator templated resources that they want to create in their developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning` namespace, or an existing secret in another namespace referred to in the secretRef in the additional sources (See [Customize Installation](#heading=h.lc08xegj8s5n) for more details). 

## Create the Git Authentication secret in tap-namespace-provisioning namespace.

The secrets for Git authentication allow the following keys:** **

* ssh-privatekey
* ssh-knownhosts
    * if ssh-knownhosts is not specified, git will not perform strict host checking.
* username
* password

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

Next, Add the` secretRef` section to the` additional_sources` and the `gitops_install` section of the namespace provisioner configuration in your TAP values:

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

## Import from another namespace

If you already have a Git secret created in a namespace other than `tap-namespace-provisioning `namespace and you want to refer to that, the secretRef section should have the namespace mentioned along with the` create_export` flag. The default value for create_export is false as it assumes the Secret is already exported for tap-namespace-provisioning namespace, but allows the user to specify if they want the Namespace provisioner to create a` Carvel SecretExport` for that secret. 

Please find the below example referring to<code> git-auth<strong> </strong></code>secret from<code> tap-install</code> in the secretRef section.

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

* [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) for the secret in the provided namespace (tap-install in the above example) to the namespace provisioner namespace.
* [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) for the secret in Namespace Provisioning namespace (tap-namespace-provisioning) so Carvel [secretgen-controller](https://github.com/carvel-dev/secretgen-controller) can create the required secret for the Provisioner to connect to the Private Git Repository.

