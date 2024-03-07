# Use Git authentication with Supply Chain Choreographer

This topic describes how you can use Git authentication with Supply Chain Choreographer.

You can either fetch or push source code from or to a repository that requires
credentials. You must provide credentials through a Kubernetes secret object
referenced by the intended Kubernetes object created for performing the action.

The following sections provide details about how to appropriately set up
Kubernetes secrets for carrying those credentials forward to the proper resources.

>**Important** For HTTP, HTTPS, and SSH, do not use the same server for multiple secrets to avoid a Tekton error.

## <a id="pulling-source-code"></a>Pulling Source Code

For the supply chain to pull source code it must reference a secret with Git credentials.
This secret must exist in the same namespace as the workload.

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
     name: NAME-OF-THE-SECRET
     namespace: SOME-NAMESPACE
  spec: ...
  ```

You must provide the name of this secret to the supply chain, either as a tap-value or as a workload parameter.

tap-value example:

  ```yaml
  ootb_supply_chain_basic:
     source:
        credentials_secret: NAME-OF-THE-SECRET
  ```

Workload parameter value:

  ```yaml
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    namespace: SOME-NAMESPACE
  spec:
    params:
      - name: source_credentials_secret
        value: NAME-OF-THE-SECRET
  ```

## <a id="pushing-build-config"></a>Pushing Build Configuration

For the supply chain to push build configuration to a Gitops repository, the supply chain must reference a
service account and this service account must in turn reference a secret with Git credentials.

The secret can be different from the secret used for pulling source code, with different credentials to a different
repository.

For example, a secret:
  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
     name: NAME-OF-A-SECRET
     namespace: SOME-NAMESPACE
     annotations:
       tekton.dev/git-0: GIT-SERVER        # ! required. example: https://github.com
  spec: ...
  ```

referenced by a service account:
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: SOME-SA-NAME
    namespace: SOME-NAMESPACE
  secrets:
    - name: registry-credentials
    - name: tap-registry
    - name: NAME-OF-A-SECRET
  imagePullSecrets:
    - name: registry-credentials
    - name: tap-registry
  ```

You must provide the name of this service account to the supply chain, either as a tap-value or as a workload parameter.

tap-value example:

  ```yaml
  ootb_supply_chain_basic:
     service_account: SOME-SA-NAME
  ```

Workload parameter example:

  ```yaml
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    namespace: SOME-NAMESPACE
  spec:
    params:
      - name: serviceAccount
        value: SOME-SA-NAME
  ```

>**Note** If you've used Namespace Provisioner to set up your Developer Namespace where your workload is created, use the `namespace_provisioner.default_parameters.supply_chain_service_account.secrets` property in your `tap-values.yaml`. For example:

    ```yaml
    namespace_provisioner:
      default_parameters:
        supply_chain_service_account:
          secrets:
          - GIT-SECRET-NAME
    ```
Namespace Provisioner manages the service account and manual edits to it do not persist.

## <a id="pulling-build-conf"></a>Pulling Build Configuration

The delivery must pull the build configuration that was pushed by the supply chain.
It must reference a secret with Git credentials (similar to how the supply chain pulls source code).
This secret must exist in the same namespace as the deliverable. The credentials in this secret must be valid for the repository to which the supply chain pushed configuration.

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
     name: NAME-OF-A-SECRET
     namespace: A-NAMESPACE
  spec: ...
  ```

You must provide the name of this secret, either as a tap-value or as a deliverable parameter.

tap-value example:

  ```yaml
  ootb_delivery_basic:
     source:
        credentials_secret: NAME-OF-A-SECRET
  ```

Deliverable parameter example:

  ```yaml
  apiVersion: carto.run/v1alpha1
  kind: Deliverable
  metadata:
    namespace: A-NAMESPACE
  spec:
    params:
      - name: source_credentials_secret
        value: NAME-OF-A-SECRET
  ```

## <a id="http"></a>HTTP

For any action upon an HTTP or HTTPS based repository, create a Kubernetes secret
object of type `kubernetes.io/basic-auth` as follows:

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: SECRET-NAME
    annotations:
      tekton.dev/git-0: GIT-SERVER        # ! required
  type: kubernetes.io/basic-auth          # ! required
  stringData:
    username: GIT-USERNAME
    password: GIT-PASSWORD
  ```

For example, assuming you have a repository called `kontinue/hello-world` on
GitHub that requires authentication, and you have an access token with the
privileges of reading the contents of the repository, you can create the secret
as follows:

  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: git-secret
    annotations:
      tekton.dev/git-0: https://github.com
  type: kubernetes.io/basic-auth
  stringData:
    username: GITHUB-USERNAME
    password: GITHUB-ACCESS-TOKEN
  ```

>**Note** In this example, you use an access token because GitHub deprecates
basic authentication with plain user name and password.
For more information, see [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
on GitHub.

## <a id="http-custom-cert"></a>HTTPS with a Custom CA Certificate

In addition to the
[shared.ca_cert_data](../security-and-compliance/custom-ca-certificates.hbs.md)
field, you must add the certificate to the secret used to access the Git
repository. The only platform tested with custom CA certificates is GitLab.

You set up the secret similarly to the section above, but the `caFile` field specifies a certificate authority.

   ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: SECRET-NAME
    annotations:
      tekton.dev/git-0: GIT-SERVER        # ! required
  type: kubernetes.io/basic-auth          # ! required
  stringData:
    username: GIT-USERNAME
    password: GIT-PASSWORD
    caFile: |
     -----BEGIN CERTIFICATE-----
     ...
     -----END CERTIFICATE-----
   ```

## <a id="ssh"></a>SSH

Aside from using HTTP or HTTPS as a transport, the supply chains also allow you to
use SSH.

>**Important** To use the pull request feature, you must use
HTTP or HTTPS authentication with an access token.

1. To provide the credentials for any Git operations with SSH,
create the Kubernetes secret as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: GIT-SECRET-NAME
      annotations:
        tekton.dev/git-0: GIT-SERVER
    type: kubernetes.io/ssh-auth          # ! required
    stringData:
      ssh-privatekey: SSH-PRIVATE-KEY     # private key with push-permissions
      identity: SSH-PRIVATE-KEY           # private key with pull permissions
      identity.pub: SSH-PUBLIC-KEY        # public of the `identity` private key
      known_hosts: GIT-SERVER-PUBLIC-KEYS # Git server public keys
    ```

1. Generate a new SSH keypair: `identity` and `identity.pub`.

    ```console
    ssh-keygen -t ecdsa -b 521 -C "" -f "identity" -N ""
    ```

1. Go to your Git provider and add the `identity.pub` as a deployment key for
the repository of interest or add to an account that has access to it.
For example, for GitHub,
visit `https://github.com/<repository>/settings/keys/new`.

    >**Note** Keys of type SHA-1/RSA are recently deprecated by GitHub.

1. Gather public keys from the provider, for example, GitHub:

    ```console
    ssh-keyscan github.com > ./known_hosts
    ```

2. Create the Kubernetes secret by using the contents of the files in the first step:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: GIT-SECRET-NAME
      annotations: {tekton.dev/git-0: GIT-SERVER}
    type: kubernetes.io/ssh-auth
    stringData:
      ssh-privatekey: SSH-PRIVATE-KEY
      identity: SSH-PRIVATE-KEY
      identity.pub: SSH-PUBLIC-KEY
      known_hosts: GIT-SERVER-PUBLIC-KEYS
    ```

    For example, edit the credentials:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: git-ssh
      annotations: {tekton.dev/git-0: github.com}
    type: kubernetes.io/ssh-auth
    stringData:
      ssh-privatekey: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        AAAA
        ....
        ....
        -----END OPENSSH PRIVATE KEY-----
      known_hosts: |
        <known hosts entrys for git provider>
      identity: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        AAAA
        ....
        ....
        -----END OPENSSH PRIVATE KEY-----
      identity.pub: ssh-ed25519 AAAABBBCCCCDDDDeeeeFFFF user@example.com
    ```

## <a id="more-info"></a>More information about Git

For information about Git, see [Git Reference](git.hbs.md).
