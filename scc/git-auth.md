# Git authentication

To either fetch/push source code from/to a repository that requires
credentials, you must provide those credentials by using a Kubernetes Secret 
object referenced by the Kubernetes object that is created for performing such 
action.

The following sections provide details about how to appropriately set up 
Kubernetes secrets for carrying those credentials forward to the proper resources.


## <a id="http"></a>HTTP

For any action upon an HTTP(s)-based repository, create a Kubernetes Secret
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
GitHub that requires authentication and that you have an access token with the
privileges of reading the contents of the repository, you can create the Secret
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
  username: ""
  password: GITHUB-ACCESS-TOKEN
```

>**Note** In this example, you use an access token because GitHub deprecates 
basic auth with plain username and password. 
See [GitHub docs](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) 
to learn more.

After you create the Secret, attach it to the `ServiceAccount` configured for the
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

To provide the credentials for any Git operations with such transport,
create the Kubernetes Secret as follows:

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
  known_hosts: GIT-SERVER-PUBLIC-KEYS # git server public keys
```

1. Generate a new SSH key pair: `identity` and `identity.pub`.

    ```bash
    ssh-keygen -t ecdsa -b 521 -C "" -f "identity" -N ""
    ```

1. Go to your Git provider and add the `identity.pub` as a deployment key for 
the repository of interest or add to an account that has access to it. 
For example, for GitHub, 
visit `https://github.com/<repository>/settings/keys/new`.

    >**Note:** Keys of type SHA-1/RSA are recently deprecated by GitHub.

1. Gather public keys from the provider (for example, Github):

    ```bash
    ssh-keyscan github.com > ./known_hosts
    ```

1. Create the Kubernetes Secret by using the contents of the files in earlier step:

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

After you create the Secret, attach it to the ServiceAccount configured for the
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
