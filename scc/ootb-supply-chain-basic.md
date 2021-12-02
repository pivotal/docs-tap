---
title: Out of The Box Supply Chain Basic (ootb-supply-chain-basic)
weight: 2
---

This [cartographer] Supply Chain ties a series of Kubernetes resources which,
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


### Prerequisites

To make use this supply chain, it's required that:

- Out of The Box Templates is installed
- Out of The Box Delivery Basic is installed
- Developer namespace is configured with auxiliary objects that are used by the
  supply chain (see below)


#### Developer namespace

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


##### Image Secret

Regardless of the supply chain that a Workload goes through, there must be in
the developer namespace a Secret that contains the credentials to be passed to
resources that push container images to image registries (like Tanzu Build
Service) as well as for those resources that must pull container images from
such image registry (like [Convention Service], [Knative], etc).

Using the `tanzu secret registry add` command from the [tanzu cli], we're able
to provision a base secret that contains such credentials and then export the
contents of that Secret to the namespaces where it should be consumed (i.e.,
the developer namespaces).


```bash
# create a Secret object using the `dockerconfigjson` format using the
# credentials provided, then a SecretExport (`secretgen-controller`
# resource) so that it gets exported to all namespaces where a
# placeholder secret can be found.
#
#
tanzu secret registry add image-secret \
  --export-to-all-namespaces \
  --server https://index.docker.io/v1/ \
  --username $REGISTRY_USERNAME \
  --password $REGISTRY_PASSWORD
```
```console
- Adding image pull secret 'image-secret'...
 Added image pull secret 'image-secret' into namespace 'default'
```


##### ServiceAccount

In a Kubernetes cluster, a ServiceAccount provides a way of representing an
identity within the Kubernetes role base access control (RBAC) system, which in
the case of a developer namespace, that would be the representation of a
developer / development team.

To it, we can directly attach secrets as bind roles so that we can provide ways
of indirectly letting resources find credentials without having to know the
exact name of the secrets, as well as reduce the set of permissions that a
group would have (through the use of Roles and RoleBinding objects).


```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: image-secret
imagePullSecrets:
  - name: image-secret
```


##### Role and RoleBinding

As the Supply Chain takes action in the cluster on behalf of the users who
created the Workload, it needs permissions within Kubernetes' RBAC system to do
so.

To achieve that, we need to first describe a set of permissions for particular
resources (i.e., create a Role), and then bind those permissions to an actor
(i.e., create a RoleBinding that binds the Role to the ServiceAccount).

So, create a Role describing the permissions:


```yaml
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
- apiGroups: [scst-scan.apps.tanzu.vmware.com]
  resources: ['imagescans', 'sourcescans']
  verbs: ['*']
```

Then bind it to the ServiceAccount:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: kapp-permissions
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: kapp-permissions
subjects:
  - kind: ServiceAccount
    name: default
```


### Developer Workload

With the developer namespace setup with the objects above (image secret,
serviceaccount, role, and rolebinding), we can move on to creating the Workload
object.

We can configure the Workload with two scenarios in mind:


- local iteration: takes source code from the filesystem and
  drives is through the supply chain making no use of external git repositories

- local iteration with code from git: takes source code from a git repository
  and drives it through the supply chain without persisting the final
  configuration in git

- gitops: source code is provided by an external git repository (public _or_
  private), and the final kubernetes configuration to deploy the application is
  persisted in a repository


###### Local iteration with local code

In this scenario, all we need is the source code (in the example below,
assuming the current directory `.` as the location of the source code we want
to send through the supply chain), and a container image registry to use as the
mean for making the source code available inside the Kubernetes cluster.


```bash
tanzu apps workload create tanzu-java-web-app \
  --local-path . \
  --source-image $REGISTRY/source \
  --type web
```
```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-java-web-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    image: 10.188.0.3:5000/source:latest@sha256:1cb23472fcdcce276c316d9bed6055625fbc4ac3e50a971f8f8004b1e245981e

? Do you want to create this workload? Yes
Created workload "tanzu-java-web-app"
```

With the Workload submitted, we should be able to keep track of the resulting
series of Kubernetes objects created to drive the source code all the way to a
deployed application by making use of the `tail` command:

```bash
tanzu apps workload tail tanzu-java-web-app
```



###### Local iteration with code from git

Similar to local iteration with local code, here we make use of the same type
(`web`), but instead of pointing at source code that we have locally, we can
make use of a git repository to feed the supply chain with new changes as they
are pushed to a branch.


```bash
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo https://github.com/sample-accelerators/tanzu-java-web-app
  --type web
```
```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  name: tanzu-java-web-app
      6 + |  namespace: default
      7 + |spec:
      8 + |  source:
      9 + |    git:
     10 + |      ref:
     11 + |        branch: main
     12 + |      url: https://github.com/sample-accelerators/tanzu-java-web-app
```

In the example above, we make use of a public repository, but, if you want to
make use of a private repository instead, make sure you create a Secret in the
same namespace as the one where the Workload is being submitted to, and add the
`--param source_git_ssh_secret=<>` parameter to the set of parameters above.


```yaml
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

If it's your first time setting up SSH credentials for your user, the following
steps can serve as a guide for getting it done:


```bash
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

With the namespace configured (i.e., having added the secret to be used for
fetching source code from a private repository), we can move on to creating the
Workload with the new parameter:


```bash
tanzu apps workload create tanzu-java-web-app \
  --git-branch main \
  --git-repo git@github.com:sample-accelerators/tanzu-java-web-app.git \
  --param source_git_ssh_secret=git-ssh \
  --type web
```
```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-java-web-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  params:
     11 + |  - name: source_git_ssh_secret
     12 + |    value: git-ssh
     13 + |  source:
     14 + |    git:
     15 + |      ref:
     16 + |        branch: main
     17 + |      url: git@github.com:sample-accelerators/tanzu-java-web-app.git
```


###### GitOps

Differently from local iteration, the GitOps approach requires a secret
containing credentials to a git provider (e.g., GitHub) to be exist in the same
namespace as the Workload, and a couple parameters to be set with details about
the commit to be pushed to the repository where Kubernetes configuration is
delivered to.

Before proceeding, make sure you have a secret with following shape fields and
annotations set:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
  annotations:
    tekton.dev/git-0: github.com  # git server host
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: string          # private key with push-permissions
  known_hosts: string             # git server public keys
  identity:                       # private key with pull permissions
  identity.pub:                   # public of the `identity` private key
```

With the Secret created, we can move on to the Workload:


```bash
tanzu apps workload create tanzu-java-web-app \
  --git-repo git@github.com:sample-accelerators/tanzu-java-web-app.git \
  --git-branch main \
  --param "delivery_git_branch=main" \
  --param "delivery_git_commit_message=bump" \
  --param "delivery_git_repository=git@github.com:my-team/staging-repository.git" \
  --param "delivery_git_user_email=team@team.com" \
  --param "delivery_git_user_name=team" \
  --param "delivery_git_ssh_secret=git-ssh" \
  --param "source_git_ssh_secret=git-ssh" \
  --type web
```
```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-java-web-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  params:
     11 + |  - name: delivery_git_branch
     12 + |    value: main
     13 + |  - name: delivery_git_commit_message
     14 + |    value: bump
     15 + |  - name: delivery_git_repository
     16 + |    value: git@github.com:my-team/staging-repository.git
     17 + |  - name: delivery_git_user_email
     18 + |    value: team@team.com
     19 + |  - name: delivery_git_user_name
     20 + |    value: team
     21 + |  - name: delivery_git_ssh_secret
     22 + |    value: git-ssh
     23 + |  - name: source_git_ssh_secret
     24 + |    value: git-ssh
     25 + |  source:
     26 + |    git:
     27 + |      ref:
     28 + |        branch: main
     29 + |      url: git@github.com:sample-accelerators/tanzu-java-web-app.git

? Do you want to create this workload? (y/N)
```

where:

-  `delivery_git_ssh_secret` (required): name of the secret in the same
   namespace as the Workload where SSH credentials exist for pushing the
   configuration produced by the supply chain to a git repository.
   e.g.: "ssh-secret"

-  `delivery_git_repository` (required): SSH url of the git repository to push
   the kubernete configuration produced by the supply chain to.
   e.g.: "ssh://git@foo.com/staging.git"

-  `delivery_git_branch`: name of the branch to push the configuration to.
   e.g.: "main"

-  `delivery_git_commit_message`: message to write as the body of the commits
   produced for pushing configuration to the git repository.
   e.g.: "ci bump"

-  `delivery_git_user_name`: user name to use in the commits.
   e.g.: "Alice Lee"

-  `delivery_git_user_email`: user email to use for the commits.
   e.g.: "foo@example.com"

-  `source_git_ssh_secret` (required, if source is private): name of the secret
   in the same namespace as the Workload where SSH credentials exist for
   fetching the source code of `workload.spec.source.git`.
