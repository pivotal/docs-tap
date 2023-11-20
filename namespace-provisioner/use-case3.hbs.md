# Work with private Git repositories in Namespace Provisioner

This topic tells you how to configure Namespace Provisioner to use private Git repositories for
storing  GitOps based installation files, and platform operator templated resources that you want to create in your developer namespace in Tanzu Application Platform (commonly known as TAP).

## <a id= 'git-private'></a>Git Authentication for using a private Git repository

Namespaces Provisioner enables you to use private Git repositories for storing your GitOps based installation files as well as additional platform operator templated resources that you want to create in your developer namespace. Authentication is provided using a secret in `tap-namespace-provisioning` namespace, or an existing secret in another namespace referred to in the secretRef in the additional sources. For more information, see [Customize Installation of Namespace Provisioner](customize-installation.md).

### Create the Git Authentication secret in tap-namespace-provisioning namespace

The secrets for Git authentication allow the following keys: ssh-privatekey, ssh-knownhosts, username, and password.

>**Note**  If ssh-knownhosts is not specified, Git does not perform strict host checking.
>**Important** Namespace Provisioner relies on kapp-controller for any tasks involving communication
with external services, such as registries or Git repositories. When operating in air-gapped
environments or other scenarios where external services are secured by a Custom CA certificate,
you must configure kapp-controller with the CA certificate data to prevent
X.509 certificate errors. For more information, see [Deploy onto Cluster](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/1.5/cluster-essentials/deploy.html#deploying-cluster-essentials-v156-0)
in the Cluster Essentials for VMware Tanzu documentation.

1. Create the Git secret.

    Using HTTP(s) based Authentication
    : If you are using Username and Password for authentication:

      ```yaml
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
    : If you are using SSH private key for authentication:

      ```yaml
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

2. Add the `secretRef` section to the `additional_sources` and the `gitops_install` section of the Namespace Provisioner configuration in your TAP values:

    Using Namespace Provisioner Controller
    : Description

      ```yaml
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

      **Caution** There is a current limitation in kapp-controller which does not allow the users to
      re-use the same git secret multiple times. If you have multiple additional sources using private
      repo with the same credentials, you must create different secrets with the same
      authentication details for each of them.

      In this example, the location where the list of namespaces resides is also a private repository. So you must create a secret named `git-auth-install` with the same authentication details.

      ```yaml
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

If you already have a Git secret created in a namespace other than `tap-namespace-provisioning`
namespace and you want to refer to that, the secretRef section should have the namespace
mentioned along with the ` create_export` flag. The default value for `create_export` is false
as it assumes the Secret is already exported for tap-namespace-provisioning namespace,
but allows the user to specify if they want the Namespace Provisioner to create a
`Carvel SecretExport` for that secret.

The example refers to `git-auth` secret from `tap-install` in the secretRef section.

Using Namespace Provisioner Controller
: Description

  ```yaml
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

  ```yaml
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

After reconciling, Namespace Provisioner creates:

- [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) for the secret in the provided namespace (tap-install in the above example) to the Namespace Provisioner namespace.
- [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) for the secret in Namespace Provisioning namespace (tap-namespace-provisioning) so Carvel [secretgen-controller](https://github.com/carvel-dev/secretgen-controller) can create the required secret for the Provisioner to connect to the Private Git Repository.

## Git Authentication for Private Repository for Workloads and Supply chain

To either fetch or push source code from or to a repository that requires credentials,
you must provide those through a Kubernetes secret object referenced by the intended Kubernetes
object created for performing the action. The following sections provide details about how to
appropriately set up Kubernetes secrets for carrying those credentials forward to the proper resources.

This section provides instructions on how to configure the `default` service account to work with private Git repositories for workloads and supply chain using Namespace Provisioner.

To configure the service account to work with private Git repositories, follow the steps below:

1. Create a secret in the `tap-install` namespace or any namespace of your preference, that contains the Git credentials in the YAML format.

   - `host`, `username` and `password` or `personal access token` values for HTTP based Git Authentication.
   - `ssh-privatekey, identity, identity_pub`, and `known_hosts` for SSH based Git Authentication.

    >**Note** stringData key of the secret must have **.yaml** or **.yml** suffix at the end.

    Using HTTP(s) based Authentication
    : If using Username and Password for authentication.

      ```yaml
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
            password: GIT-PASSWORD
      EOF
      ```

    Using SSH based Authentication
    : If using SSH private key for authentication, create the git secret with authentication details as follows:

      ```yaml
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
            host: GIT-SERVER
      EOF
      ```

2. Create a scaffolding of a Git secret that needs to be added to the service account in the developer namespace in the GitOps repository. See the [sample secret here.](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/credentials/git.yaml) An example secret would look like the following. Instead of putting the actual username and password in the secret in the Git repository, put the reference to the values in the git-auth secret created in Step 1 by using the `data.values.imported` keys.

    Using HTTP(s) based Authentication
    : If using Username and Password for authentication.

      ```yaml
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

    Using SSH based Authentication
    : If using SSH private key for authentication:

      ```yaml
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
        identity: #@ data.values.imported.git.identity
        identity.pub: #@ data.values.imported.git.identity_pub
        known_hosts: #@ data.values.imported.git.known_hosts
        ssh-privatekey: #@ data.values.imported.git.ssh_privatekey
      ```

3. Create a secret to specify an overlay to patch the default service account adding a reference to the secret **git**.

    ```yaml
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

4. Put all this together in Namespace Provisioner configuration in TAP values as follows:

    Using Namespace Provisioner Controller
    : Add the following configuration to your TAP values

      ```yaml
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

      ```yaml
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

* First additional source points to the location where the templated git secret resides which is
created in all developer namespaces.
* Second additional source points to the overlay file which adds the git secret onto the default service account
* Finally, import the newly created `workload-git-auth` secret into Namespace Provisioner to use in `data.values.imported` by adding the secret to the `import_data_values_secrets`.

>**Note** `create_export` is set to `true` in `import_data_values_secrets` meaning that a SecretExport
is created for the `workload-git-auth` secret in the tap-install namespace automatically by
Namespace Provisioner. After the changes are reconciled, the secret named **git** is in
all provisioned namespaces and it is also added to the default service account of those namespaces.
