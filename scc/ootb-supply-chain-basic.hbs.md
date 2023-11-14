# Out of the Box Supply Chain Basic for Supply Chain Choreographer

This topic provides an overview of Out of the Box Supply Chain Basic for Supply Chain Choreographer.

This package contains Cartographer Supply Chains that tie together a series of
Kubernetes resources that drive a developer-provided workload from source code
to a Kubernetes configuration ready to be deployed to a cluster.
It contains the most basic supply chains that focus on providing a quick path
to deployment making no use of testing or scanning resources.

The supply chains in this package perform the following:

- Building from source code:

  1. Watching a Git repository, Maven repository, or local directory for changes
  2. Building a container image out of the source code with Buildpacks
  3. Applying operator-defined conventions to the container definition
  4. Creating a deliverable object for deploying the application to a cluster
    1. (Experimental) Alternatively, outputting a Carvel Package containing the application to a Git Repository

- Using a prebuilt application image:

  1. Applying operator-defined conventions to the container definition
  1. Creating a deliverable object for deploying the application to a cluster
    1. (Experimental) Alternatively, outputting a Carvel Package containing the application to a Git Repository


## <a id="prerequisites"></a> Prerequisites

To use this package, you must:

- Install [Out of the Box Templates](ootb-templates.html).
- Configure the Developer namespace with auxiliary objects that are used by the
  supply chain as described in the following section.
- (Optionally) install [Out of the Box Delivery
  Basic](ootb-delivery-basic.html), if you are willing to deploy the application to the
same cluster as the workload and supply chains.


### <a id="developer-namespace"></a> Developer Namespace

The supply chains provide definitions of many of the objects that they create
to transform the source code to a container image and make it available as an
application in a cluster.

The developer must provide or configure particular objects in the developer
namespace so that the supply chain can provide credentials and use permissions
granted to a specific development team.

The objects that the developer must provide or configure include:

- **[registries secrets](#registries-secrets)**: Kubernetes secrets of type
  `kubernetes.io/dockerconfigjson` that contain credentials for pushing and
  pulling the container images built by the supply chain and the
  installation of Tanzu Application Platform.

- **[service account](#service-account)**: The identity to be used for any
  interaction with the Kubernetes API made by the supply chain.

- **[rolebinding](#rolebinding)**: Grant to the identity the necessary roles
  for creating the resources prescribed by the supply chain.

#### <a id="registries-secrets"></a> Registries Secrets

Regardless of the supply chain that a workload goes through, there must be
Kubernetes secrets in the developer namespace containing credentials for both
pushing and pulling the container image that the supply chain builds when source code is provided. The developer namespace must also contain
registry credentials for Kubernetes to
run pods using images from the installation of Tanzu Application Platform.

1. Add read/write registry credentials for pushing and pulling application images:

    ```console
    tanzu secret registry add registry-credentials \
      --server REGISTRY-SERVER \
      --username REGISTRY-USERNAME \
      --password REGISTRY-PASSWORD \
      --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name you want to use for the developer
      namespace. For example, use `default` for the default namespace.

    - `REGISTRY-SERVER` is the URL of the registry. For Docker Hub, this must be
      `https://index.docker.io/v1/`. Specifically, it must have the leading
      `https://`, the `v1` path, and the trailing `/`. For Google Container Registry (GCR), this is
      `gcr.io`.  Based on the information used in [Installing the Tanzu
      Application Platform package and profiles](../install-online/profile.hbs.md), you can use the
      same registry server as in `ootb_supply_chain_basic` - `registry` -
      `server`.

2. Add a placeholder secret for gathering the credentials used for pulling
   container images from the installation of Tanzu Application Platform:

    ```console
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
    EOF
    ```

With the two secrets created:

- `tap-registry` is a placeholder secret filled indirectly by
  `secretgen-controller` Tanzu Application Platform credentials set up during the installation of Tanzu Application Platform.
- `registry-credentials` is a secret providing credentials for the registry where
  application container images are pushed to.

The following section discusses setting up the identity required for the workload.

#### <a id="service-account"></a> ServiceAccount

In a Kubernetes cluster, a ServiceAccount provides a way of representing an
actor within the Kubernetes role-based access control (RBAC) system. In the case
of a developer namespace, this represents a developer or development team.

You can directly attach secrets to the ServiceAccount through both the `secrets`
and `imagePullSecets` fields. This allows you to provide indirect ways for
resources to find credentials without knowing the exact name of
the secrets.

```console
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

> **Important** The ServiceAccount must have the secrets created earlier linked to it. If
> it does not, services like Tanzu Build Service (used in the supply chain)
> lack the necessary credentials for pushing the images it builds for that
> workload.

#### <a id="rolebinding"></a> RoleBinding

As the Supply Chain takes action in the cluster on behalf of the users who
created the workload, it needs permissions within Kubernetes' RBAC system to do
so.

Tanzu Application Platform v1.2 includes two ClusterRoles that describe all of the necessary
permissions to grant to the service account:

- `workload` clusterrole, providing the necessary roles for the supply chains
  to manage the resources prescribed by them.

- `deliverable` clusterrole, providing the roles for deliveries to deploy to
  the cluster the application Kubernetes objects produced by the supply chain.

To provide those permissions to the identity you created for this workload, bind
the `workload` ClusterRole to the ServiceAccount you created above:

```console
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

If this is a Build cluster, and you do not intend to run the application in
it, this single RoleBinding is all that's necessary.

If you intend to also deploy the application that's been built, bind to the same
ServiceAccount the `deliverable` ClusterRole too:

```console
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

For more information about authentication and authorization in Tanzu Application Platform, see [Overview of Default roles for Tanzu Application Platform](../authn-authz/overview.hbs.md).

### <a id="developer-workload"></a> Developer workload

With the developer namespace set up with the preceding objects, such as secret,
serviceaccount, and rolebinding, you can create the workload object.

To do so, use the `apps` plug-in from the Tanzu CLI:

```console
tanzu apps workload create FLAGS WORKLOAD-NAME
```

Where:

- `FLAGS` are the one or more flags you want to include.
- `WORKLOAD-NAME` is the name of the workload you want to target.

Depending on what you are aiming to achieve, you can set different flags.
To know more about those (including details about different features
of the supply chains), see the following sections:

- [Building from source](building-from-source.md), for more information about
  different ways of creating a workload where the application is built from
  source code.

- [Using an existing image](pre-built-image.md), for more information about how to
  use prebuilt images in the supply chains.

- [GitOps vs RegistryOps](gitops-vs-regops.md), for a description of the
  different ways of propagating the deployment configuration through external
  systems (Git repositories and image registries).

- [Carvel Package Workflow](carvel-package-supply-chain.hbs.md), for information
  about how to configure workloads to output Carvel Packages for delivery through Git repositories.
