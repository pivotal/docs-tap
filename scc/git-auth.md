# Git authentication

To either fetch/push source code from/to a repository that requires
credentials, one must provide those via a Kubernetes Secret object that's
referenced by the intended Kubernetes object created for performing such action.

Here you'll find details on how to appropriately setup Kubernetes secrets for
carrying those credentials forward to the proper resources.


## HTTP

For any action upon an HTTP(s)-based repository, create a Kubernetes Secret
object of type `kubernetes.io/basic-auth` like so:

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

For instance, assuming we have a repository called `kontinue/hello-world` on
GitHub that requires authentication and that we have an access token with the
privileges of reading the contents of the repository, we can create the Secret
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

> **Note** In the example above we use an access token because GitHub
> deprecated basic auth with plain username and password. See [GitHub
> docs][gh-creating-access-token] to know more.

[gh-creating-access-token]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token

With the Secret created, attach it to the ServiceAccount configured for the
Workload by including it in its set of secrets. For instance:

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

## SSH

Aside from using HTTP(S) as a transport, the supply chains also let you
leverage SSH.

For providing the credentials for any Git operations with such transport,
create the Kubernetes Secret like so:

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

1. Generate a new SSH key pair (`identity` and `identity.pub`)

    ```bash
    ssh-keygen -t ecdsa -b 521 -C "" -f "identity" -N ""
    ```

    Once done, head to your git provider and add the `identity.pub` as a
    deployment key for the repository of interest or add to an account that has
    access to it. For instance, for GitHub, visit
    `https://github.com/<repository>/settings/keys/new`.

    > **Note:** keys of type SHA-1/RSA have been recently deprecated by GitHub.

1. Gather public keys from the provider (e.g., github):

    ```bash
    ssh-keyscan github.com > ./known_hosts
    ```

1. Create the Kubernetes Secret based on using the contents of the files above:

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

    For instance, having credentials redacted:


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

With the Secret created, attach it to the ServiceAccount configured for the
Workload by including it in its set of secrets. For instance:

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
