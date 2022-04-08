# Out of the Box Supply Chain Basic

This Package contains Cartographer Supply Chains that tie together a series of
Kubernetes resources which drive a developer-provided Workload from source code
to a Kubernetes configuration ready to be deployed to a cluster.

It contains the most basic supply chains that focus on providing a quick path
to deployment making no use of testing or scanning resources in between. With
it, the supply chains included here performs the following:

- Building from source code:

  1. Watching a Git repository or local directory for changes
  1. Building a container image out of the source code with Buildpacks
  1. Applying operator-defined conventions to the container definition
  1. Creating a Deliverable object for deploying the application to a cluster

- Using a pre-built application image:

  1. Applying operator-defined conventions to the container definition
  1. Creating a Deliverable object for deploying the application to a cluster


## <a id="prerequisites"></a> Prerequisites

To use consume this Package, you must:

- Install [Out of the Box Templates](ootb-templates.html)
- Configure the Developer namespace with auxiliary objects that are used by the
  supply chain as described below
- (optionally) Install [Out of the Box Delivery
  Basic](ootb-delivery-basic.html), if willing to deploy the application to the
same cluster as where the Workload and supply chains.


### <a id="developer-namespace"></a> Developer Namespace

The supply chains provide definitions of many of the objects that they create
to transform the source code to a container image and make it available as an
application in a cluster.

The developer must provide or configure particular objects in the developer
namespace so that the supply chain can provide credentials and use permissions
granted to a particular development team.

The objects that the developer must provide or configure include:

- **[registries secrets](#registries-secrets)**: Kubernetes secrets of type
  `kubernetes.io/dockerconfigjson` that contains credentials for pushing and
  pulling the container images built by the supply chain as well as the
  installation of TAP

- **[service account](#service-account)**: The identity to be used for any
  interaction with the Kubernetes API made by the supply chain

- **[rolebinding](#rolebinding)**: Grant to the identity the necessary roles
  for creating the resources prescribed by the supply chain.



#### <a id="registries-secrets"></a> Registries Secrets

Regardless of the supply chain that a Workload goes through, there must be
Kubernetes Secrets in the developer namespace containing credentials for both
pushing and pulling the container image that gets built by the supply chains
when source code is provided, as well registry credentials for Kubernetes to
run Pods using images from the installation of TAP.

1. Add read/write registry credentials for pushing/pulling application images:

    ```
    tanzu secret registry add registry-credentials \
      --server REGISTRY-SERVER \
      --username REGISTRY-USERNAME \
      --password REGISTRY-PASSWORD \
      --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name that you want to use for the developer
      namespace.  For example, use `default` for the default namespace.

    - `REGISTRY-SERVER` is the URL of the registry. For Dockerhub, this must be
      `https://index.docker.io/v1/`. Specifically, it must have the leading
      `https://`, the `v1` path, and the trailing `/`. For GCR, this is
      `gcr.io`.  Based on the information used in [Installing the Tanzu
      Application Platform Package and Profiles](install.md), you can use the
      same registry server as in `ootb_supply_chain_basic` - `registry` -
      `server`.

1. Add a placeholder secret for gathering the credentials used for pulling
   container images from the installation of TAP:

    ```
    cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-registry
      annotations:
        secretgen.carvel.dev/image-pull-secret: ""
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: e30K
    ```

With the two secrets  created

- `tap-registry`, placeholder secret filled indirectly by
  `secretgen-controller` TAP credentials set up during the installation of TAP
- `registry-credentials`, secret providing credentials for the registry where
  application container images will be pushed to

we can move on to setting up the identity required for the Workload.


#### <a id="service-account"></a> ServiceAccount

In a Kubernetes cluster, a ServiceAccount provides a way of representing an
actor within the Kubernetes role base access control (RBAC) system. In the case
of a developer namespace, this represents a developer or development team.

You can directly attach secrets to the ServiceAccount via both the `secrets`
and `imagePullSecets` fields. This allows you to provide indirect ways for
resources to find credentials without them needing to know the exact name of
the secrets.

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
  - name: tap-registry
imagePullSecrets:
  - name: registry-credentials
  - name: tap-registry
```

> **Note:** The ServiceAccount must have the secrets created above linked to it. If
> it does not, services like Tanzu Build Service (used in the supply chain)
> lack the necessary credentials for pushing the images it builds for that
> Workload.


#### <a id="rolebinding"></a> RoleBinding

As the Supply Chain takes action in the cluster on behalf of the users who
created the Workload, it needs permissions within Kubernetes' RBAC system to do
so.

TAP v1.1 ships with two ClusterRoles that describe all of the necessary
permissions we need to grant to the service account:

- `workload` clusterrole, providing the necessary roles for the supply chains
  to be able to manage the resources prescribed by them

- `deliverable` clusterrole, providing the roles for deliveries to deploy to
  the cluster the application Kubernetes objects produced by the supply chain

To provide those permissions to the identity we created for this Workload, bind
the `workload` ClusterRole to the ServiceAccount we created above:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-workload
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: workload
subjects:
  - kind: ServiceAccount
    name: default
```

If this is just a Build cluster that does not intend to run the appication in
it, this single RoleBinding is all that's necessary.

If intending to also deploy the application that's been built, bind to the same
ServiceAccount the `deliverable` ClusterRole too:

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-deliverable
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: deliverable
subjects:
  - kind: ServiceAccount
    name: default
```

To know more about authentication and authorization in TAP v1.1, check out
https://github.com/pivotal/docs-tap/blob/main/authn-authz/overview.md.

### <a id="developer-workload"></a> Developer workload

With the developer namespace setup with the objects above (secret,
serviceaccount, and rolebinding), you can create the Workload object.

To do so, we can make use of the `apps` plugin from the Tanzu CLI:

```
tanzu apps workload create [flags] [workload-name]
```

Depending on what one is aiming to achieve, different flags should be
specified. To know more about those (including details about different features
of the supply chains), check out the following sections:

- [Building from source](building-from-source.md), for knowing more about
  different ways of creating a Workload that has the application built from
  source code

- [Pre-built image](pre-built-image.md), for more information on how to
  leverage pre-built images in the supply chains

- [GitOps vs RegistryOps](gitops-vs-regops.md), for a description of the
  different ways of propagating the deployment configuration through external
  systems (git repositories and image registries).
