# Building from source

Regardless of the out of the box Supply Chain Package you've installed, you can provide source code for the workload from one of three places:

1. A Git repository.
1. A directory in your local computer's file system.
1. A Maven repository.

  ```console
  Supply Chain

    -- fetch source                 * either from Git or local directory
      -- test
        -- build
          -- scan
            -- apply-conventions
              -- push config
  ```

This document provides details about each approach.

>**Note:** To provide a prebuilt container image instead of
building the application from the beginning by using the supply chain, see
[Using a prebuilt image](pre-built-image.md).

## <a id="git-source"></a>Git source

To provide source code from a Git repository to the supply chains,
you must fill `workload.spec.source.git`. With the `tanzu` CLI, you can do so by using the following flags:

- `--git-branch`: branch within the Git repository to checkout
- `--git-commit`: commit SHA within the Git repository to checkout
- `--git-repo`: Git URL to remote source code
- `--git-tag`: tag within the Git repository to checkout

For example, after installing `ootb-supply-chain-basic`, to create a
`Workload` the source code for which comes from the `main` branch of the
`github.com/sample-accelerators/tanzu-java-web-app` Git repository, run:

  ```bash
  tanzu apps workload create tanzu-java-web-app \
    --app tanzu-java-web-app \
    --type web \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main
  ```

Expect to see the following output:

  ```console
  Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  labels:
        6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
        7 + |    apps.tanzu.vmware.com/workload-type: web
        8 + |  name: tanzu-java-web-app
        9 + |  namespace: default
      10 + |spec:
      11 + |  source:
      12 + |    git:
      13 + |      ref:
      14 + |        branch: main
      15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
  ```

>**Note:** The Git repository URL must include the scheme: `http://`,
`https://`, or `ssh://`.


### <a id="private-git-repo"></a>Private `GitRepository`

To fetch source code from a repository that requires credentials, you must
provide those by using a Kubernetes secret object that the `GitRepository` object created for that workload references. 
See [How It Works](#how-it-works)
to learn more about detecting changes to the repository.

```scala
Workload/tanzu-java-web-app
└─GitRepository/tanzu-java-web-app  
                   └───────> secretRef: {name: GIT-SECRET-NAME}
                                                   |
                                      either a default from TAP installation or
                                           gitops_ssh_secret Workload parameter
``` 

Platform operators who install the Out of the Box Supply Chain packages
by using Tanzu Application Platform profiles can customize the default name of
the secret (`git-ssh`) by editing the corresponding `ootb_supply_chain*`
property in the `tap-values.yaml` file:


  ```yaml
  ootb_supply_chain_basic:
    gitops:
      ssh_secret: GIT-SECRET-NAME
  ```

For platform operators who install the `ootb-supply-chain-*` package individually
by using `tanzu package install`, they can edit the
`ootb-supply-chain-*-values.yml` as follows:

  ```yaml
  gitops:
    ssh_secret: GIT-SECRET-NAME
  ```

You can also override the default secret name directly in the workload by using
the `gitops_ssh_secret` parameter, regardless of how Tanzu Application Platform
is installed. You can use the `--param` flag in Tanzu CLI. For example:

  ```bash
  tanzu apps workload create tanzu-java-web-app \
    --app tanzu-java-web-app \
    --type web \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --param gitops_ssh_secret=SECRET-NAME
  ```

Expect to see the following output:

  ```console
  Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  labels:
        6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
        7 + |    apps.tanzu.vmware.com/workload-type: web
        8 + |  name: tanzu-java-web-app
        9 + |  namespace: default
      10 + |spec:
      11 + |  params:
      12 + |  - name: gitops_ssh_secret  #! parameter that overrides the default
      13 + |    value: GIT-SECRET-NAME     #! secret name
      14 + |  source:
      15 + |    git:
      16 + |      ref:
      17 + |        branch: main
      18 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
  ```

>**Note:** A secret reference is only provided to `GitRepository` if
`gitops_ssh_secret` is set to a non-empty string in some fashion,
either by a package property or a workload parameter. To force a `GitRepository` to
not reference a secret, set the value to an empty string (`""`).

After defining the name of the Kubernetes secret, you can define
the secret.

#### <a id="http-auth"></a>HTTP(S) Basic-authentication and Token-based authentication

Despite both the package value and workload parameter being called `gitops.ssh_secret`, you can use HTTP(S) transports as well:

1. Ensure that the repository in the `Workload` specification
uses `http://` or `https://` schemes in any URLs that relate to the repositories.
For example, `https://github.com/my-org/my-repo` instead of
`github.com/my-org/my-repo` or `ssh://github.com:my-org/my-repo`.

1. In the same namespace as the workload, create a Kubernetes secret object
of type `kubernetes.io/basic-auth` with the name matching the one
expected by the supply chain. For example:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: GIT-SECRET-NAME
      annotations:
        tekton.dev/git-0: GIT-SERVER        # ! required
    type: kubernetes.io/basic-auth
    stringData:
      username: GIT-USERNAME
      password: GIT-PASSWORD
    ```

1. With the secret created with the name matching the one configured for
`gitops.ssh_secret`, attach it to the `ServiceAccount` used by the workload. For
example:

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

For more information about the credentials and setting up the Kubernetes secret, see
[Git Authentication's HTTP section](git-auth.md#http).

#### <a id="ssh-auth"></a>SSH authentication

Aside from using HTTP(S) as a transport, you can also use SSH:

1. Ensure that the repository URL in the workload specification uses
`ssh://` as the scheme in the URL, for example, `ssh://git@github.com:my-org/my-repo.git`

1. Create a Kubernetes secret object of type `kubernetes.io/ssh-auth`:

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

1. With the secret created with the name matching the one configured for
`gitops.ssh_secret`, attach it to the ServiceAccount used by the workload. For
example:

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

For information about how to generate the keys and set up SSH with the Git server,
see [Git Authentication's SSH section](git-auth.md#ssh).


### <a id="how-it-works-1"></a>How it works

With the `workload.spec.source.git` filled, the supply chain takes care of
managing a child `GitRepository` object that keeps track of commits made to the
Git repository stated in `workload.spec.source.git`.

For each revision found, `gitrepository.status.artifact` gets updated providing
information about an HTTP endpoint that the controller makes available for
other components to fetch the source code from within the cluster.

The digest of the latest commit:

  ```yaml
  apiVersion: source.toolkit.fluxcd.io/v1beta1
  kind: GitRepository
  metadata:
    name: tanzu-java-web-app
  spec:
    gitImplementation: go-git
    ignore: '!.git'
    interval: 1m0s
    ref: {branch: main}
    timeout: 20s
    url: https://github.com/sample-accelerators/tanzu-java-web-app
  status:
    artifact:
      checksum: 375c2daee5fc8657c5c5b49711a8e94d400994d7
      lastUpdateTime: "2022-04-07T15:02:30Z"
      path: gitrepository/default/tanzu-java-web-app/d85df1fc.tar.gz
      revision: main/d85df1fc28c6b86ca54bd613f55991645d3b257c
      url: http://source-controller.flux-system.svc.cluster.local./gitrepository/default/tanzu-java-web-app/d85df1fc.tar.gz
    conditions:
    - lastTransitionTime: "2022-04-07T15:02:30Z"
      message: 'Fetched revision: main/d85df1fc28c6b86ca54bd613f55991645d3b257c'
      reason: GitOperationSucceed
      status: "True"
      type: Ready
    observedGeneration: 1
  ```

Cartographer passes the artifact URL and revision to further
components in the supply chain. Those components must consume the source code from
an internal URL where a tarball with the source code is fetched, without
having to process any Git-specific details in multiple places.


### <a id="workload-params"></a>Workload parameters

You can pass the following parameters by using the workload object's
`workload.spec.params` field to override the default behavior of the
`GitRepository` object created for keeping track of the changes to a repository:

- `gitImplementation`: name of the Git implementation (either `libgit2` or `go-git`) to fetch the source code.
- `gitops_ssh_secret`: name of the secret in the same namespace as the workload
  where credentials to fetch the repository are found.

You can also customize the following parameters with defaults for the whole cluster.
Do this by using properties for either `tap-values.yaml`
when installing supply chains by using Tanzu Application Platform profiles,
or `ootb-supply-chain-*-values.yml` when installing the OOTB packages
individually):

- `git_implementation`: the same as `gitImplementation` workload parameter
- `gitops.ssh_secret`: the same as `gitops_ssh_secret` workload parameter

## <a id="local-source"></a>Local source

You can provide source code from a local directory such as, from a directory in the
developer's file system. The `tanzu` CLI provides two flags to specify
the source code location in the file system and where the source code is
pushed to as a container image:

- `--local-path`: path on the local file system to a directory of source code
to build for the workload
- `--source-image`: destination image repository where source code is staged
before being built

This way, whether the cluster the developer targets is local
(a cluster in the developer's machine) or not, the source code
is made available by using a container image registry.

For example, if a developer has source code under the current directory
(`.`) and access to a repository in a container image
registry, you can create a workload as follows:

  ```bash
  tanzu apps workload create tanzu-java-web-app \
    --app tanzu-java-web-app \
    --type web \
    --local-path . \
    --source-image $REGISTRY/test
  ```

  ```console
  Publish source in "." to "REGISTRY-SERVER/REGISTRY-REPOSITORY"?
  It may be visible to others who can pull images from that repository

    Yes

  Publishing source in "." to "REGISTRY-SERVER/REGISTRY-REPOSITORY"...
  Published source

  Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  labels:
        6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
        7 + |    apps.tanzu.vmware.com/workload-type: web
        8 + |  name: tanzu-java-web-app
        9 + |  namespace: default
      10 + |spec:
      11 + |  source:
      12 + |    image: REGISTRY-SERVER/REGISTRY-REPOSITORY:latest@<digest>
  ```

 Where:

   - `REGISTRY-SERVER` is the container image registry.
   - `REGISTRY-REPOSITORY` is the repository in the container image registry.



### <a id="auth"></a>Authentication

Both the cluster and the developer's machine must be configured to properly
provide credentials for accessing the container image registry where the
local source code is published to.

#### <a id="dev"></a>Developer

The `tanzu` CLI must push the source code to the container image registry
indicated by `--source-image`. To do so, the CLI must find the credentials,
so the developer must configure their machine accordingly.

To ensure credentials are available, use `docker` to make the necessary
credentials available for the Tanzu CLI to perform the image push. Run:

  ```console
  docker login REGISTRY-SERVER -u REGISTRY-USERNAME -p REGISTRY-PASSWORD
  ```

#### <a id="auth"></a>Supply chain components

Aside from the developer's ability to push source code to the container image registry,
the cluster must also have the proper credentials, so it can pull that
container image, unpack it, run tests, and build the application.

To provide the cluster with the credentials, point the ServiceAccount used by the workload at the
Kubernetes secret that contains the credentials.

If the registry that the developer targets is the same one for which
credentials were provided while setting up the workload namespace, no further
action is required. Otherwise, follow the same steps as recommended for the
application image.


### <a id="how-it-works-2"></a>How it works

A workload specifies that source code must come from an image by setting
`workload.spec.source.image` to point at the registry provided by using
`--source-image`. Instead of having a GitRepository object created, an
ImageRepository object is instantiated, with its specification filled in such a
way to keep track of images pushed to the registry provided by the user.

Take the following workload as an example:

  ```yaml
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    name: app
    labels:
      app.kubernetes.io/part-of: app
      apps.tanzu.vmware.com/workload-type: web
  spec:
    source:
      image: 10.188.0.3:5000/test:latest
  ```

Instead of a `GitRepository` object, an `ImageRepository` is created:

  ```diff
    Workload/app
    │
  - ├─GitRepository/app
  + ├─ImageRepository/app
    │
    ├─Image/app
    │ ├─Build/app-build-1
    │ │ └─Pod/app-build-1-build-pod
    │ ├─PersistentVolumeClaim/app-cache
    │ └─SourceResolver/app-source
    │
    ├─PodIntent/app
    │
    ├─ConfigMap/app
    │
    └─Runnable/app-config-writer
      └─TaskRun/app-config-writer-2zj7w
        └─Pod/app-config-writer-2zj7w-pod
  ```

`ImageRepository` provides the same semantics as `GitRepository`,
except that it looks for source code in container image registries rather than
Git repositories.

## <a id="maven-artifact"></a> Maven Artifact

This approach aids integration with existing CI systems, such as Jenkins, and can pull artifacts from existing Maven repositories,
including Jfrog Artifactory.

There are no dedicated fields in the `Workload` resource for
specifying the Maven artifact configuration. You must fill in the
`name`/`value` pairs in the `params` structure.

For example:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: my-workload
  labels:
    apps.tanzu.vmware.com/workload-type: web
spec:
  params:
  - name: maven
    value:
      groupId: com.example
      artifactId: springboot-initial
      version: RELEASE      # latest 'RELEASE' or a specific version (e.g.: '1.2.2')
      type: jar             # optional (defaults to 'jar')
      classifier: sources   # optional
```

The `tanzu` CLI is used for creating workloads that define Maven artifacts as source.

To create a workload that defines a specific version of a maven artifact as source, run:

```bash
tanzu apps workload apply my-workload \
      --param-yaml maven='{"artifactId": "springboot-initial", "version": "2.6.0", "groupId": "com.example"}'\
      --type web --app spring-boot-initial -y
```

To create a workload that defines the `RELEASE` version of a maven artifact as source, run:

```bash
tanzu apps workload apply my-workload \
      --param-yaml maven='{"artifactId": "springboot-initial", "version": "RELEASE", "groupId": "com.example"}'\
      --type web --app spring-boot-initial -y
```

The Maven repository URL and required credentials are defined in the supply
chain, not the workload. For more information, see [Installing OOTB
Basic](install-ootb-sc-basic.md).

### <a id="maven-repository-secret"></a> Maven Repository Secret

The MavenArtifact only supports authentication using basic authentication.

Additionally, MavenArtifact supports security using the TLS protocol.  The Application Operator can configure the MavenArtifact to use a
custom, or self-signed certificate authority (CA).

The MavenArtifact expects that all of the earlier credentials are provided in
one secret, formatted as shown later:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: maven-credentials
type: Opaque
data:
  username: <BASE64>  # basic auth user name
  password: <BASE64>  # basic auth password
  caFile: <BASE64>    # PEM Encoded certificate data for custom CA 
```

You cannot use the `tanzu` CLI to create secrets such as this, but
you can use the kubectl CLI instead.  

For example:

``` bash
kubectl create secret generic maven-credentials \
  --from-literal=username=literal-username \
  --from-file=password=/path/to/file/with/password.txt \
  --from-file=caFile=/path/to/ca-certificate.pem
```
