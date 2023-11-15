# Work with Git repositories in air-gapped environments with Namespace Provisioner

This section provides instructions on configuring the Namespace Provisioner to utilize air-gapped
Git repositories. This allows you to store GitOps-based installation files and platform
operator-templated resources intended for creation in your developer namespace within
Tanzu Application Platform (TAP).


## <a id= 'git-auth'></a>Git Authentication

Authentication is established through a secret in the `tap-namespace-provisioning` namespace or
an existing secret in another namespace referenced in the `secretRef` within `additional_sources`.
For more details, refer to [Customize Installation of Namespace Provisioner](customize-installation.hbs.md).

### Create the Git Authentication secret in tap-namespace-provisioning namespace

The Git authentication secrets support the following keys: `ssh-privatekey`, `ssh-knownhosts`, `username`, and `password`. If `ssh-knownhosts` is not specified, Git does not perform strict host checking.

>**Important:** In air-gapped environments or other scenarios where external services
are secured by a Custom CA certificate, configure kapp-controller with the CA certificate data
to prevent X.509 certificate errors.
For detailed instructions, refer to [Deploy onto Cluster](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#deploy-onto-cluster-5) in the Cluster Essentials for VMware Tanzu documentation.


1. Create the Git secret:

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
            ...
            -----END OPENSSH PRIVATE KEY-----
      EOF
      ```

2. Add the `secretRef` section to the `additional_sources` and the `gitops_install` section of your `tap-values.yaml` file:

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
            url: git@git-airgap-server:private-repo-org/repo.git
            secretRef:
              name: git-auth
      ```

    Using GitOps
    : Description


      **Caution:** In kapp-controller versions \<v0.46.0, there is a limitation that
      prevents the reuse of the same Git secret multiple times. If you have multiple additional sources
      utilizing repositories with identical credentials, you must create distinct secrets,
      each with the same authentication details.

      In this example, the list of namespaces resides in a repository. Therefore, you must
      create a secret named `git-auth-install` with the same authentication details for this location.

      ```yaml
      namespace_provisioner:
        controller: false
        additional_sources:
        - git:
            ref: origin/main
            subPath: tekton-pipelines
            # This example URL is for SSH auth. Use https:// path if using HTTPS auth
            url: git@git-airgap-server:private-repo-org/repo.git
            secretRef:
              name: git-auth
        gitops_install:
          ref: origin/main
          subPath: gitops-install
          # This example URL is for SSH auth. Use https:// path if using HTTPS auth
          url: git@git-airgap-server:private-repo-org/repo.git
          secretRef:
            name: git-auth-install
      ```

<br>

### Import from another namespace

If you already have a Git secret created in a namespace other than the `tap-namespace-provisioning`
namespace and you want to refer to it, the `secretRef` section should include the namespace
along with the `create_export` flag. The default value for `create_export` is `false`,
assuming the Secret is already exported for the `tap-namespace-provisioning` namespace.
However, you can specify if you want the Namespace Provisioner to create a *Carvel* `SecretExport`
for that secret.

In the example, the `secretRef` section refers to the `git-auth` secret from the `tap-install` namespace.

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
        url: git@git-airgap-server:private-repo-org/repo.git
        secretRef:
            name: git-auth
            namespace: tap-install
            #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
            create_export: true
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
        url: git@git-airgap-server:private-repo-org/repo.git
        secretRef:
            name: git-auth
            namespace: tap-install
            #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
            create_export: true
    gitops_install:
      ref: origin/main
      subPath: gitops-install
      #! This example URL is for SSH auth. Use https:// path if using HTTPS auth
      url: git@git-airgap-server:private-repo-org/repo.git
      secretRef:
        name: git-auth-install
        namespace: tap-install
        #! If this secret is already exported for this namespace, you can ignore the create_export key as it defaults to false
        create_export: true
  ```

After reconciliation, Namespace Provisioner creates:

- [SecretExport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretexport) for the secret in the provided namespace (e.g., `tap-install` in the above example), exporting it to the Namespace Provisioner namespace.
- [SecretImport](https://github.com/carvel-dev/secretgen-controller/blob/develop/docs/secret-export.md#secretimport) for the secret in the Namespace Provisioning namespace. This enables Carvel [secretgen-controller](https://github.com/carvel-dev/secretgen-controller) to create the required secret, allowing the Namespace Provisioner to connect to the Git repository.

## Git Authentication for Workloads and Supply chain

When fetching or pushing source code to a repository that requires credentials,
it's essential to provide those credentials through a Kubernetes secret object referenced by
the corresponding Kubernetes object created for the action. The following sections provide details on
setting up Kubernetes secrets to securely pass these credentials to the relevant resources.

This section provides instructions on configuring the `default` service account to
interact with Git repositories for workloads and supply chain using Namespace Provisioner.

To set up the service account to interact with Git repositories, follow the steps below:

1. Create a secret in the `tap-install` namespace or any preferred namespace, containing Git credentials in YAML format.

   - `host`, `username`, `caFile` and `password` or `personal access token` values for HTTP-based Git Authentication.
   - `ssh-privatekey`, `identity`, `identity_pub`, and `known_hosts` for SSH-based Git Authentication.

    >**Note:** The `stringData` key of the secret must end with either **.yaml** or **.yml** suffix.

    Using HTTP(s) based Authentication
    : If using Username and Password for authentication.


       Assuming that, in this configuration for an air-gapped environment,
       the Git Repository server has a custom certificate of authority that
       cannot be verified against public issuers, you must provide
       the `caFile` content to log in against it.


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
            caFile: |
              -----BEGIN CERTIFICATE-----
              ...
              -----END CERTIFICATE-----
      EOF
      ```

    Using SSH based Authentication
    : If you prefer using an SSH private key for authentication, create the Git secret with the authentication details as follows:


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
            host: GIT-SERVER
            #! For SSH Auth
            ssh_privatekey: SSH-PRIVATE-KEY
            identity: SSH-PRIVATE-KEY
            identity_pub: SSH-PUBLIC-KEY
            known_hosts: GIT-SERVER-PUBLIC-KEYS
      EOF
      ```

2. To create a secret to be added to the service account in the developer namespace within the GitOps repository, you can use this [example](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-airgap/resources/git.yaml) for HTTP-based or this [example](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/ns-provisioner-samples/gitops-airgap/resources/settings-xml.yaml) for `setings.xml`-based, or follow the provided example below.

    Rather than directly including the actual username and password in the Git repository secret,
    utilize the `data.values.imported` keys to add references to the values from the `git-auth` secret
    created in Step 1.

    This secret represents the actual Git secret that will be created by the Namespace Provisioner
    in each managed namespace. It should be included in your Git repository linked in the
    `additional_sources` section of `tap-values.yaml` mentioned in Step 4.

    Using HTTP(s) based Authentication
    : If using Username and Password for authentication.

      
      Assuming that, in this configuration for an air-gapped environment,
       the Git Repository server has a custom certificate of authority that
       cannot be verified against public issuers, you must provide
       the `caFile` content to log in against it.
       
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
        caFile: #@ data.values.imported.git.caFile
      ```

    Using settings.xml based Authentication for Java applications
    : If using Username and Password for authentication.
       
       ```yaml
      #@ load("@ytt:data", "data")

      apiVersion: v1
      kind: Secret
      metadata:
        name: settings-xml
      type: service.binding/maven
      stringData:
        type: maven
        provider: sample
        #@yaml/text-templated-strings
        settings.xml: |
          <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
              <mirrors>
                  <mirror>
                      <id>reposilite</id>
                      <name>Accelerator samples</name>
                      <url>(@= data.values.imported.git.host @)/vmware-tanzu/application-accelerator-samples</url>
                      <mirrorOf>*</mirrorOf>
                  </mirror>
              </mirrors>
              <servers>
                  <server>
                      <id>reposilite</id>
                      <username>(@= data.values.imported.git.username @)</username>
                      <password>(@= data.values.imported.git.password @)</password>
                  </server>
              </servers>
          </settings>
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

3. Combine this `tap-values.yaml`:

    Using Namespace Provisioner Controller
    : Add the following configuration to `tap-values.yaml`:


      ```yaml
      namespace_provisioner:
        controller: true
        additional_sources:
        - git:
            ref: origin/main
            subPath: ns-provisioner-samples/credentials
            url: https://git-airgap-server/application-accelerator-samples.git
        import_data_values_secrets:
        - name: workload-git-auth
          namespace: tap-install
          create_export: true
        default_parameters:
          supply_chain_service_account:
            secrets:
            - git
      ```

      Assuming that `https://git-airgap-server/application-accelerator-samples.git` is a fork of the
      [application-accelerator-samples](https://github.com/vmware-tanzu/application-accelerator-samples) repository,


    Using GitOps
    : Add the following configuration to `tap-values.yaml`:


      ```yaml
      namespace_provisioner:
        controller: false
        additional_sources:
        - git:
            ref: origin/main
            subPath: ns-provisioner-samples/credentials
            url: https://git-airgap-server/vmware-tanzu/application-accelerator-samples.git
        gitops_install:
          ref: origin/main
          subPath: ns-provisioner-samples/gitops-install
          url: https://git-airgap-server/vmware-tanzu/application-accelerator-samples.git
        import_data_values_secrets:
        - name: workload-git-auth
          namespace: tap-install
          create_export: true
        default_parameters:
          supply_chain_service_account:
            secrets:
            - git
      ```

      Assuming that `https://git-airgap-server/application-accelerator-samples.git` is a fork of the
      [application-accelerator-samples](https://github.com/vmware-tanzu/application-accelerator-samples) repository,

   - The first additional source points to the location where the templated Git secret resides,
  which will be created in all developer namespaces./
   - Import the newly created `workload-git-auth` secret into Namespace Provisioner to use in
  `data.values.imported` by adding the secret to `import_data_values_secrets`.
   - Add the secret to be included in the ServiceAccount in the `default_parameters`. 
  For more information, see [Customize service accounts](use-case4.hbs.md#customize-sa).

   >**Note:** `create_export` is set to `true` in `import_data_values_secrets`.
   As a result, a SecretExport is automatically created for the `workload-git-auth` secret in
   the `tap-install` namespace by Namespace Provisioner. After the changes are reconciled,
   the secret named **git** is present in all provisioned namespaces and is also
   added to the default service account of those namespaces.

4. In your `tap-values.yaml` file, within the `ootb_supply_chain_*.gitops.ssh_secret` section,
   specify the name of the Git secret containing the credentials. This is necessary for
   the supply chain to include the `secretRef` when creating the Flux `GitRepository` resource.
   Here is an example:


  ```yaml
  ootb_supply_chain_testing_scanning:
    gitops:
      ssh_secret: git  # Replace with the actual name of your Git secret for the workload, if different
  ```

  By providing this configuration, the supply chain associates the created `GitRepository`
  resource with the specified Git secret managed by the Namespace Provisioner.

5. Create the workload

    Using HTTP/HTTPS or SSH-based
    : If using Username and Password for authentication.
    
    
      ```bash
      tanzu apps workload apply APP_NAME \
      --git-repo GIT_REPO \
      --git-branch BRANCH \
      --type web \
      --app APP_NAME \
      --label apps.tanzu.vmware.com/has-tests="true" \
      --namespace DEV_NAMESPACE \
      --tail \
      --yes
      ```

    Using settings.xml based Authentication for Java applications
    : If using Username and Password for authentication.
    
    
      ```bash
      tanzu apps workload apply APP_NAME \
      --git-repo GIT_REPO \
      --git-branch BRANCH \
      --type web \
      --app APP_NAME \
      --label apps.tanzu.vmware.com/has-tests="true" \
      --namespace DEV_NAMESPACE \
      --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' 
      --tail \
      --yes
      ```
