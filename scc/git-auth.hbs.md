# Git authentication

To either fetch or push source code from or to a repository that requires
credentials, you must provide those through a Kubernetes secret object 
referenced by the intended Kubernetes object created for performing the action.

The following sections provide details about how to appropriately set up 
Kubernetes secrets for carrying those credentials forward to the proper resources.


## <a id="http"></a>HTTP

For any action upon an HTTP(s)-based repository, create a Kubernetes secret
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

>**Note**: In this example, you use an access token because GitHub deprecates 
basic authentication with plain user name and password. 
For more information, see [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
on GitHub.

After you create the secret, attach it to the `ServiceAccount` configured for the
workload by including it in its set of secrets. For example:

  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: default
  secrets:
    - name: registry-credentials
    - name: tap-registry
    - name: GIT-SECRET-NAME
  imagePullSecrets:
    - name: registry-credentials
    - name: tap-registry
  ```

## <a id="ssh"></a>SSH

Aside from using HTTP(S) as a transport, the supply chains also allow you to
use SSH. 

>**Note:** If you want to use the pull request feature, you must use 
HTTP(S) authentication with an access token.

1. To provide the credentials for any Git operations with SHH,
create the Kubernetes secret as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: GIT-SECRET-NAME
      annotations:
        tekton.dev/git-0: GIT-SERVER
    type: kubernetes.io/ssh-auth
    stringData:
      ssh-privatekey: SSH-PRIVATE-KEY     # private key with push-permissions
      identity: SSH-PRIVATE-KEY           # private key with pull permissions
      identity.pub: SSH-PUBLIC-KEY        # public of the `identity` private key
      known_hosts: GIT-SERVER-PUBLIC-KEYS # Git server public keys
    ```

1. Generate a new SSH keypair: `identity` and `identity.pub`.

    ```bash
    ssh-keygen -t ecdsa -b 521 -C "" -f "identity" -N ""
    ```

1. Go to your Git provider and add the `identity.pub` as a deployment key for 
the repository of interest or add to an account that has access to it. 
For example, for GitHub, 
visit `https://github.com/<repository>/settings/keys/new`.

    >**Note:** Keys of type SHA-1/RSA are recently deprecated by GitHub.

1. Gather public keys from the provider, for example, GitHub:

    ```bash
    ssh-keyscan github.com > ./known_hosts
    ```

1. Create the Kubernetes secret by using the contents of the files in the first step:

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

1. After you create the secret, attach it to the ServiceAccount configured for the
workload by including it in its set of secrets. For example:

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
    secrets:
      - name: registry-credentials
      - name: tap-registry
      - name: GIT-SECRET-NAME
    imagePullSecrets:
      - name: registry-credentials
      - name: tap-registry
    ```
