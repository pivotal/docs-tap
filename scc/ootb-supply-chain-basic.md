# Out of the Box Supply Chain Basic

This Cartographer Supply Chain ties together a series of Kubernetes resources which
drive a developer-provided Workload from source code to a Kubernetes configuration
ready to be deployed to a cluster.

This is the most basic supply chain that provides a quick path to deployment. It
makes no use of testing or scanning steps.

```
SUPPLYCHAIN
  source-provider                          flux/GitRepository|vmware/ImageRepository
       <--[src]-- image-builder            kpack/Image           : kpack/Build
           <--[img]-- convention-applier   convention/PodIntent
             <--[config]-- config-creator  corev1/ConfigMap
              <--[config]-- config-pusher  carto/Runnable        : tekton/TaskRun

DELIVERY
  config-provider                           flux/GitRepository|vmware/ImageRepository
    <--[src]-- app-deployer                 kapp-ctrl/App
```

- Watching a Git repository or local directory for changes
- Building a container image out of the source code with Buildpacks
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## <a id="prerequisites"></a> Prerequisites

To use this supply chain, you must:

- Install [Out of the Box Templates](ootb-templates.html)
- Install [Out of the Box Delivery Basic](ootb-delivery-basic.html)
- Configure the Developer namespace with auxiliary objects that are used by the
  supply chain as described below

### <a id="developer-namespace"></a> Developer Namespace

The supply chains provide definitions of many of the objects that they create to transform the source code
to a container image and make it available as an application in the cluster.

The developer must provide or configure particular objects in the developer namespace so that
the supply chain can provide credentials and use permissions granted to a
particular development team.

The objects that the developer must provide or configure include:

- **[image secret](#image-secret)**: A Kubernetes secret of type
  `kubernetes.io/dockerconfigjson` that contains credentials for pushing the
  container images built by the supply chain

- **[service account](#service-account)**: The identity to be used for any interaction with the
  Kubernetes API made by the supply chain

- **[role](#role-rolebinding)**: The set of capabilities that you want to assign to the service
  account. It must provide the ability to manage all of the resources that the
  supplychain is responsible for.

- **[rolebinding](#role-rolebinding)**: Binds the role to the service account. It grants the
  capabilities to the identity.

- (Optional) **[git credentials secret](#git-credentials-secret)**: When using GitOps for managing the
  delivery of applications or a private git source, this secret provides the
  credentials for interacting with the git repository.


#### <a id="image-secret"></a> Image Secret

Regardless of the supply chain that a Workload goes through, there must be a secret
in the developer namespace. This secret contains the credentials to be passed to:

* Resources that push container images to image registries, such as Tanzu Build
Service
* Those resources that must pull container images from such image registry, such
as Convention Service and Knative.

Use the `tanzu secret registry add` command from the Tanzu CLI to provision a
secret that contains such credentials.

```
# create a Secret object using the `dockerconfigjson` format using the
# credentials provided, then a SecretExport (`secretgen-controller`
# resource) so that it gets exported to all namespaces where a
# placeholder secret can be found.
#
#
tanzu secret registry add image-secret \
  --server https://index.docker.io/v1/ \
  --username $REGISTRY_USERNAME \
  --password $REGISTRY_PASSWORD
```
```
- Adding image pull secret 'image-secret'...
 Added image pull secret 'image-secret' into namespace 'default'
```

With the command above, the secret `image-secret` of type
`kubernetes.io/dockerconfigjson` is created in the namespace.
This makes the secret available for Workloads in this same namespace.

To export the secret to all namespaces, use the `--export-to-all-namespaces`
flag.


#### <a id="service-account"></a> ServiceAccount

In a Kubernetes cluster, a ServiceAccount provides a way of representing an
identity within the Kubernetes role base access control (RBAC) system. In
the case of a developer namespace, this represents a developer or development team.

You can directly attach secrets to the ServiceAccount as bind roles. This allows you
to provide indirect ways for resources to find credentials without them needing to know the
exact name of the secrets, as well as reduce the set of permissions that a
group would have, through the use of Roles and RoleBinding objects.


```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: image-secret
imagePullSecrets:
  - name: image-secret
```

The ServiceAccount must have the secret created above linked to
it. If it does not, services like Tanzu Build Service (used in the supply chain)
lack the necessary credentials for pushing the images it builds for that
Workload.

#### <a id="role-rolebinding"></a> Role and RoleBinding

As the Supply Chain takes action in the cluster on behalf of the users who
created the Workload, it needs permissions within Kubernetes' RBAC system to do
so.

To achieve that, you must first describe a set of permissions for particular
resources, meaning create a Role, and then bind those permissions to an actor.
For example, creating a RoleBinding that binds the Role to the ServiceAccount.

So, create a Role describing the permissions:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: default
rules:
- apiGroups: [source.toolkit.fluxcd.io]
  resources: [gitrepositories]
  verbs: ['*']
- apiGroups: [source.apps.tanzu.vmware.com]
  resources: [imagerepositories]
  verbs: ['*']
- apiGroups: [carto.run]
  resources: [deliverables, runnables]
  verbs: ['*']
- apiGroups: [kpack.io]
  resources: [images]
  verbs: ['*']
- apiGroups: [conventions.apps.tanzu.vmware.com]
  resources: [podintents]
  verbs: ['*']
- apiGroups: [""]
  resources: ['configmaps']
  verbs: ['*']
- apiGroups: [""]
  resources: ['pods']
  verbs: ['list']
- apiGroups: [tekton.dev]
  resources: [taskruns, pipelineruns]
  verbs: ['*']
- apiGroups: [tekton.dev]
  resources: [pipelines]
  verbs: ['list']
- apiGroups: [kappctrl.k14s.io]
  resources: [apps]
  verbs: ['*']
- apiGroups: [serving.knative.dev]
  resources: ['services']
  verbs: ['*']
- apiGroups: [servicebinding.io]
  resources: ['servicebindings']
  verbs: ['*']
- apiGroups: [services.apps.tanzu.vmware.com]
  resources: ['resourceclaims']
  verbs: ['*']
- apiGroups: [scanning.apps.tanzu.vmware.com]
  resources: ['imagescans', 'sourcescans']
  verbs: ['*']
```

Then bind it to the ServiceAccount:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: default
subjects:
  - kind: ServiceAccount
    name: default
```


### <a id="developer-workload"></a> Developer workload

With the developer namespace setup with the objects above (image, secret,
serviceaccount, role, and rolebinding), you can create the Workload
object.

Configure the Workload with three scenarios in mind:

- **[local iteration](#local)**: takes source code from the filesystem and drives is
  through the supply chain making no use of external git repositories

- **[local iteration with code from git](#local-with-git)**: takes source code from a git
  repository and drives it through the supply chain without persisting the
  final configuration in git (enabled **only** if the installation did not include
  a default repository prefix for git-based workflows)

- **[gitops](#gitops)**: source code is provided by an external git repository (public or
  private), and the final Kubernetes configuration to deploy the application is
  persisted in a repository


#### <a id="local"></a> Local Iteration with Local Code

In this scenario, you need the source code (in the example below,
assuming the current directory `.` as the location of the source code you want
to send through the supply chain), and a container image registry to use as the
mean for making the source code available inside the Kubernetes cluster.


```
tanzu apps workload create tanzu-java-web-app \
  --local-path . \
  --source-image $REGISTRY/source \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    image: 10.188.0.3:5000/source:latest@sha256:1cb23472fcdcce276c316d9bed6055625fbc4ac3e50a971f8f8004b1e245981e

? Do you want to create this workload? Yes
Created workload "tanzu-java-web-app"
```

With the Workload submitted, you can track of the resulting
series of Kubernetes objects created to drive the source code all the way to a
deployed application by making use of the `tail` command:

```
tanzu apps workload tail tanzu-java-web-app
```


#### <a id="local-with-git"></a> Local Iteration with Code from Git

Similar to local iteration with local code, here we make use of the same type
(`web`), but instead of pointing at source code that we have locally, we can
make use of a git repository to feed the supply chain with new changes as they
are pushed to a branch.

>**Note**: If you plan to use a private git repository, skip
to the next section, [Private Source Git Repository](#private-source).


```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```

This scenario is only possible if the installation of the supply
chain did not include a default git repository prefix
(`gitops.repository_prefix`).


##### <a id="private-source"></a> Private Source Git Repository

In the example above, we make use of a public repository. To
make use of a private repository instead, you create a Secret in the
same namespace as the one where the Workload is being submitted to named after
the value of `gitops.ssh_secret` (the installation defaults the name to
`git-ssh`):

```
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
type: kubernetes.io/ssh-auth
stringData:
  known_hosts: string             # git server public keys
  identity: string                # private key with pull permissions
  identity.pub: string            # public of the `identity` private key
```

>**Note**: For a particular Workload, you can override the name of the secret
by using the `gitops_ssh_secret` parameter (`--param gitops_ssh_secret`)
in the Workload.

If this is your first time setting up SSH credentials for your user, the following
steps can serve as a guide:

```
# generate a new keypair.
#
#   - `identity`     (private)
#   - `identity.pub` (public)
#
# once done, head to your git provider and add the `identity.pub` as a
# deployment key for the repository of interest or add to an account that has
# access to it. for instance, for github:
#
#   https://github.com/<repository>/settings/keys/new
#
ssh-keygen -t rsa -q -b 4096 -f "identity" -N "" -C ""


# gather public keys from the provider (e.g., github):
#
ssh-keyscan github.com > ./known_hosts


# create the secret.
#
kubectl create secret generic git-ssh \
    --from-file=./identity \
    --from-file=./identity.pub \
    --from-file=./known_hosts
```

>**Note**: When you create a Secret that provides credentials for accessing your
private git repository, you can create a deploy key if your Git Provider
supports it (GitHub does). Any Git secrets you apply to
your cluster can potentially be viewed by others who have access to that
cluster. So, it is better to use Deploy keys or shared bot accounts instead of
adding personal Git Credentials.

With the namespace configured and having added the secret to be used for
fetching source code from a private repository, you can create the
Workload:


```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```


#### <a id="gitops"></a> GitOps

Different from local iteration, the GitOps approach configures the supply chain to push the Kubernetes Configuration to a remote Git repository.  This allows users to compare configuration changes and promote changes through environments using GitOps principles. 

```
SUPPLY CHAIN

    given a Workload
      watches sourcecode repo
        builds container image
          prepare configuration
            pushes config to git


DELIVERY

    given a Deliverable
      watches configurations repo
        deploys the kubernetes configurations

```

In order to authenticate to a remote Git repository, a secret containing credentials for the remote provider (e.g., GitHub) must be created in the developer namespace.  Because this operation requires push permissions, this is true regardless if the repository is public or private.

Before proceeding, create a secret in the following format:

```
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh   # `git-ssh` is the default name.
                  #   - operators can change the default using `gitops.ssh_secret`.
                  #   - developers can override using `gitops_ssh_secret`
  annotations:
    tekton.dev/git-0: github.com  # git server host   (!! required)
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions
  known_hosts: string             # git server public keys
  identity: string                # private key with pull permissions (same as ssh-privatekey)
  identity.pub: string            # public of the `identity` private key
```

For example (with secrets redacted):

```
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh   # `git-ssh` is the default name.
                  #   - operators can change the default using `gitops.ssh_secret`.
                  #   - developers can override using `gitops_ssh_secret`
  annotations:
    tekton.dev/git-0: github.com  # git server host   (!! required)
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    AAAA
    ....
    ....
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
    ....
    ....
    -----END OPENSSH PRIVATE KEY-----            
  identity.pub: ssh-ed25519 AAAABBBCCCCDDDDeeeeFFFF user@example.com
```

>**Note**: Because of incompatibilities between Kubernetes resources
 `ssh-privatekeys` must be set to the same value as `identity`.

Now that the secret has been created, ensure that it is added to the service account for the developer namespace is using.  For example, if you are using the `default` service account from the "Getting Started" guide, the service account should look like this:

```
apiVersion: v1
imagePullSecrets:
- name: registry-credentials
- name: tap-registry
kind: ServiceAccount
metadata:
  name: default
  namespace: default
secrets:
- name: registry-credentials
- name: default-token-zjbjs
- name: git-ssh
```

With the Secret created and added to the service account, we can move on to the Workload.

##### <a id="workload-using-default-git-organization"></a> Workload Using Default Git Organization

During the installation of `ootb-*`, one of the values that operators can
configure is one that dictates what the prefix the supply chain should use when
forming the name of the repository to push to the Kubernetes configurations
produced by the supply chains - `gitops.repository_prefix`.

That being set, all it takes to change the behavior towards using GitOps is
setting the source of the source code to a git repository and then as the
supply chain progresses, configuration are pushed to a repository named
after `$(gitops.repository_prefix) + $(workload.name)`.

e.g, having `gitops.repository_prefix` configured to `ssh://git@github.com/foo/gitops` and
a Workload as such:

```
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --type web
```
```
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```

 You see the Kubernetes configuration pushed to
`git@github.com/foo/gitops-tanzu-java-web-app.git`.

Regardless of the setup, the repository where configuration is pushed to can be
also manually overridden by the developers by tweaking the following parameters:

-  `gitops.ssh_secret`: Name of the secret in the same namespace as the
   Workload where SSH credentials exist for pushing the configuration produced
   by the supply chain to a git repository.
   Example: "ssh-secret"

-  `gitops.repository`: SSH URL of the git repository to push the Kubernetes
   configuration produced by the supply chain to.
   Example: "ssh://git@foo.com/staging.git"

-  `gitops.branch`: Name of the branch to push the configuration to.
   Example: "main"

-  `gitops.commit_message`: Message to write as the body of the commits
   produced for pushing configuration to the git repository.
   Example: "ci bump"

-  `gitops.user_name`: Username to use in the commits.
   Example: "Alice Lee"

-  `gitops.user_email`: User email address to use for the commits.
   Example: "foo@example.com"
