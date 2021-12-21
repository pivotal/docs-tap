# Out of The Box Supply Chain Basic (ootb-supply-chain-basic)

This Cartographer Supply Chain ties a series of Kubernetes resources which,
when working together, drives a developer-provided Workload from source code
all the way to a Kubernetes configuration ready to be deployed to a cluster.

This is the most basic supply chain, making no use of testing or scanning
steps: it aims at providing a quick path to deployment.


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

- Watching a Git Repository or local directory for changes
- Building a container image out of the source code with Buildpacks
- Applying operator-defined conventions to the container definition
- Deploying the application to the same cluster


## Prerequisites

To make use this supply chain, it's required that:

- Out of The Box Templates is installed
- Out of The Box Delivery Basic is installed
- Developer namespace is configured with auxiliary objects that are used by the
  supply chain (see below)


### Developer namespace

Despite the supply chains coming out of the box with the definition of the
objects that it should create to make the source code be transformed to a
container image and made available as an application in the cluster, there are
a couple objects that _must_ be provided by the developer or configured in the
developer namespace beforehand so that the supply chain can make use of it to
provide credentials and use the permissions that have been granted to a
particular development team.

These include:

- **image secret**: a Kubernetes secret of type
  `kubernetes.io/dockerconfigjson` filled with credentials for pushing the
container images built by the supply chain

- **service account**: the identity to be used for any interaction with the
  Kubernetes API made by the supply chain

- **role**: the set of capabilities that we want to assign to the service
  account - it must provide the ability to manage all of the resources that the
supplychain is responsible for

- **rolebinding**: binds the role to the service account, i.e., grants the
  capabilities to the identity

- (optional) **git credentials secret**: when using GitOps for managing the
  delivery of applications (or a private git source), provides the required
  credentials for interacting with the git repository.


#### Image Secret

Regardless of the supply chain that a Workload goes through, there must be, in
the developer namespace, a Secret that contains the credentials to be passed to
resources that push container images to image registries (like Tanzu Build
Service) as well as for those resources that must pull container images from
such image registry, such as Convention Service and Knative.

Using the `tanzu secret registry add` command from the Tanzu CLI, we're able to
provision one that contains such credentials.


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
`kubernetes.io/dockerconfigjson` is created in the namespace, thus being
available for Workloads in this same namespace.

To export it to all namespaces, make use of the `--export-to-all-namespaces`
flag.


#### ServiceAccount

In a Kubernetes cluster, a ServiceAccount provides a way of representing an
identity within the Kubernetes role base access control (RBAC) system, which in
the case of a developer namespace, that would be the representation of a
developer / development team.

To it, we can directly attach secrets as bind roles so that we can provide ways
of indirectly letting resources find credentials without having to know the
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

Note that the ServiceAccount **must**  have the secret created above linked to
it, otherwise services like Tanzu Build Service (used in the supply chain)
won't have the necessary credentials for pushing the images it builds for that
Workload.


#### Role and RoleBinding

As the Supply Chain takes action in the cluster on behalf of the users who
created the Workload, it needs permissions within Kubernetes' RBAC system to do
so.

To achieve that, we need to first describe a set of permissions for particular
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


### Developer workload

With the developer namespace setup with the objects above (image, secret,
serviceaccount, role, and rolebinding) we can move on to creating the Workload
object.

We can configure the Workload with three scenarios in mind:

- **local iteration**: takes source code from the filesystem and drives is
  through the supply chain making no use of external git repositories

- **local iteration with code from git**: takes source code from a git
  repository and drives it through the supply chain without persisting the
  final configuration in git (enabled **only** if the installation didn't include
  a default repository prefix for git-based workflows)

- **gitops**: source code is provided by an external git repository (public or
  private), and the final kubernetes configuration to deploy the application is
  persisted in a repository


#### Local iteration with local code

In this scenario, all we need is the source code (in the example below,
assuming the current directory `.` as the location of the source code we want
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

With the Workload submitted, we should be able to keep track of the resulting
series of Kubernetes objects created to drive the source code all the way to a
deployed application by making use of the `tail` command:

```
tanzu apps workload tail tanzu-java-web-app
```


#### Local iteration with code from git

Similar to local iteration with local code, here we make use of the same type
(`web`), but instead of pointing at source code that we have locally, we can
make use of a git repository to feed the supply chain with new changes as they
are pushed to a branch.

**note**: If you're planning to use a private git repository, make sure to skip
to the next section (Private Source Git Repository).


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

Note that this scenario is only possible if the installation of the supply
chain didn't include a default git repository prefix
(`gitops.repository_prefix`).


##### Private Source Git Repository

In the example above, we make use of a public repository, but, if you want to
make use of a private repository instead, make sure you create a Secret in the
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

**note**: for a particular Workload, the name of the secret can be overriden by
making use of the `gitops_ssh_secret` parameter (`--param gitops_ssh_secret`)
in the Workload.

If it's your first time setting up SSH credentials for your user, the following
steps can serve as a guide for getting it done:

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

**note**: when creating a Secret that provides credentials for accessing your
private git repository, you can create a deploy key if your Git Provider
supports it (GitHub does). Please be aware that any Git secrets you apply to
your cluster could potentially be viewed by others that have access to that
cluster. So using Deploy keys or shared bot accounts should be preferred over
adding personal Git Credentials.

With the namespace configured, having added the secret to be used for
fetching source code from a private repository, we can move on to creating the
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


#### GitOps

Differently from local iteration, with the GitOps approach we end up at the end
of the supply chain having the configuration that got created by it pushed to a
git repository where that's persisted and used at the basis for further
deployments.

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

Given the extra capability of pushing to git, here we have an extra requirement:

- there must be in the developer namespace (i.e., same namespace as the one
  where the Workload is submitted to) a Secret containing credentials to a git
  provider (e.g., GitHub), regardless of whether the source code comes from a
  private git repository or not.

Before proceeding, make sure you have a secret with following shape fields and
annotations set:

```
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh   # `git-ssh` is the default name.
                  #   - operators can tweak the default via `gitops.ssh_secret`.
                  #   - developers can override via `gitops_ssh_secret` param.
  annotations:
    tekton.dev/git-0: github.com  # git server host   (!! required)
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions
  known_hosts: string             # git server public keys
  identity: string                # private key with pull permissions
  identity.pub: string            # public of the `identity` private key
```

**note**: yes, at the moment `ssh-privatekeys` must be set to the same value as
`identity` due to incompatibilities between Kubernetes resources.

With the Secret created, we can move on to the Workload.


##### Workload using default git organization

During the installation of `ootb-*`, one of the values that operators can
configure is one that dictates what the prefix the supply chain should use when
forming the name of the repository to push to the Kubernetes configurations
produced by the supply chains - `gitops.repository_prefix`.

That being set, all it takes to change the behavior towards using GitOps is
setting the source of the source code to a git repository and then as the
supply chain progresses, configuration will be pushed to a repository named
after `$(gitops.repository_prefix) + $(workload.name)`.

e.g, having `gitops.repository_prefix` configured to `git@github.com/foo/` and
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

we'd see kubernetes configuration being pushed to
`git@github.com/foo/tanzu-java-web-app.git`.

Regardless of the setup, the repository where configuration is pushed to can be
also manually overriden by the developers by tweaking the following parameters:

-  `gitops_ssh_secret`: name of the secret in the same namespace as the
   Workload where SSH credentials exist for pushing the configuration produced
   by the supply chain to a git repository.
   e.g.: "ssh-secret"

-  `gitops_repository`: SSH url of the git repository to push the kubernete
   configuration produced by the supply chain to.
   e.g.: "ssh://git@foo.com/staging.git"

-  `gitops_branch`: name of the branch to push the configuration to.
   e.g.: "main"

-  `gitops_commit_message`: message to write as the body of the commits
   produced for pushing configuration to the git repository.
   e.g.: "ci bump"

-  `gitops_user_name`: user name to use in the commits.
   e.g.: "Alice Lee"

-  `gitops_user_email`: user email to use for the commits.
   e.g.: "foo@example.com"
