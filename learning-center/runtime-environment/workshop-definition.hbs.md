# Workshop resource

The `Workshop` custom resource defines a workshop.

## <a id="workshop-title-desc"></a> Workshop title and description

Each workshop must have the `title` and `description` fields. If you do not supply these fields, the `Workshop` resource is rejected when you attempt to load it into the Kubernetes cluster.

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    files: {YOUR-GIT-REPO-URL}/lab-markdown-sample
```

Where:

- The `title` field has a single-line value specifying the subject of the workshop.
- The `description` field has a longer description of the workshop.

You can also supply the following optional information for the workshop:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  url: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
  difficulty: beginner
  duration: 15m
  vendor: learningcenter.tanzu.vmware.com
  authors:
  - John Smith
  tags:
  - template
  logo: data:image/png;base64,....
  content:
    files: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
```

Where:

- The `url` field is the Git repository URL for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.
It must be a URL you can use to get more information about the workshop.

- The `difficulty` field indicates the target audiences of the workshop.
The value can be `beginner`, `intermediate`, `advanced`, or `extreme`.

- The `duration` field gives the maximum amount of time the workshop takes to complete.
This field provides informational value and does not guarantee how long a workshop instance
lasts. The field format is an integer number with `s`, `m`, or `h` suffix.

- The `vendor` field must be a value that identifies the company or organization with which the authors
are affiliated.
This is a company or organization name or a DNS host name under the control of whoever has
created the workshop.

- The `authors` field must list the people who create the workshop.

- The `tags` field must list labels identifying what the workshop is about.
This is used in a searchable catalog of workshops.

- The `logo` field must be an image provided in embedded data URI format that depicts the
topic of the workshop. The image must be 400 by 400 pixels. You can use it in a searchable catalog
of workshops.

- The `files` field is the Git repository URL for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.

When referring to a workshop definition after you load it into a Kubernetes cluster, use the
value of the `name` field given in the metadata. To experiment with different variations of a workshop,
copy the original workshop definition YAML file and change the value of `name`. Make your changes and load it into the Kubernetes cluster.

## <a id="download-workshop-content"></a> Downloading workshop content

You can download workshop content when you create the workshop instance. If the amount of
content is moderate, the download doesn't increase startup time for the workshop instance.
The alternative is to bundle the workshop content in a container image you build from the
Learning Center workshop base image.

To download workshop content at the time the workshop instance starts, set the `content.files`
field to the location of the workshop content:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    files: {YOUR-GIT-REPO-URL}/lab-markdown-sample
```

The location is a GitHub or GitLab repository, a URL to a tarball hosted on a HTTP
server, or a reference to an OCI image artifact on a registry.

For a GitHub or GitLab repository, do not prefix the location with `https://` as it
uses symbolic reference and is not a URL.

The format of the reference to a GitHub or GitLab repository is similar to what you use with Kustomize
when referencing remote repositories. For example:

- `github.com/organisation/project?ref=develop` or `github.com/organisation/project?ref=main`: Use the workshop content you host at the root of the GitHub repository. Use the `develop` or `main` branch. Be sure to specify the ref branch, because not specifying the branch may lead to content download errors.
- `github.com/organisation/project/subdir?ref=develop`: Use the workshop content you host at `subdir`
of the GitHub repository. Use the `develop` branch.
- `gitlab.com/organisation/project`: Use the workshop content you host at the root of the GitLab
repository. Use the `main` branch.
- `gitlab.com/organisation/project/subdir?ref=develop`: Use the workshop content you host at `subdir`
of the GitLab repository. Use the `develop` branch.

For a URL to a tarball hosted on a HTTP server, the URL is in the following formats:

- `https://example.com/workshop.tar` - Use the workshop content from the top-level directory of the
unpacked tarball.
- `https://example.com/workshop.tar.gz` - Use the workshop content from the top-level directory of
the unpacked tarball.
- `https://example.com/workshop.tar?path=subdir` - Use the workshop content from the
subdirectory path of the unpacked tarball.
- `https://example.com/workshop.tar.gz?path=subdir` - Use the workshop content from the
subdirectory path of the unpacked tarball.

The tarball referenced by the URL is either uncompressed or compressed.

For GitHub, instead of referencing the Git repository containing the
workshop content, use a URL to refer directly to the downloadable tarball for a
specific version of the Git repository:

- `https://github.com/organization/project/archive/develop.tar.gz?path=project-develop`

You must reference the `.tar.gz` download and cannot use the `.zip` file.
The base name of the tarball file is the branch or commit name. You must enter the `path` query
string parameter where the argument is the name of the project and branch or project and commit.
You must supply the path because the contents of the repository are not returned at the root of the
archive.

GitLab also provides a means of downloading a package as a tarball:

- `https://gitlab.com/organization/project/-/archive/develop/project-develop.tar.gz?path=project-develop`

If the GitHub or GitLab repository is private, you can generate a personal access token providing
read-only access to the repository and include the credentials in the URL:

- `https://username@token:github.com/organization/project/archive/develop.tar.gz?path=project-develop`

With this method, you supply a full URL to request a tarball of the repository and it does not
refer to the repository itself. You can also reference private enterprise versions of GitHub or
GitLab and the repository doesn't need to be on the public `github.com` or `gitlab.com` sites.

The last case is a reference to an OCI image artifact stored on a registry.
This is not a full container image with the operating system, but an image containing only the files
making up the workshop content. The URI formats for this are:

- `imgpkg+https://harbor.example.com/organisation/project:version` - Use the workshop content from
the top-level directory of the unpacked OCI artifact. The registry in this case must support `https`.
- `imgpkg+https://harbor.example.com/organisation/project:version?path=subdir` - Use the workshop
content from the subdirectory path of the unpacked OCI artifact you specify.
The registry in this case must support `https`.
- `imgpkg+http://harbor.example.com/organisation/project:version` - Use the workshop content from
the top-level directory of the unpacked OCI artifact. The registry in this case can only support `http`.
- `imgpkg+http://harbor.example.com/organisation/project:version?path=subdir` - Use the workshop
content from the subdirectory path of the unpacked OCI artifact you specify. The registry in this
case can only support `http`.

You can use `imgpkg://` instead of the prefix `imgpkg+https://`. The registry in this
case must still support `https`.

For any of the formats, you can supply credentials as part of the URI:

- `imgpkg+https://username:password@harbor.example.com/organisation/project:version`

Access to the registry using a secure connection of `https` must have a valid certificate.

You can create the OCI image artifact by using `imgpkg` from the Carvel tool set. For example, from the
top-level directory of the Git repository containing the workshop content, run:

```console
imgpkg push -i harbor.example.com/organisation/project:version -f .
```

In all cases for downloading workshop content, the `workshop` subdirectory holding the actual
workshop content is relocated to `/opt/workshop` so that it is not visible to a user.
If you want to ignore other files so the user can not see them, you can supply a
`.eduk8signore` file in your repository or tarball and list patterns for the files in it.

The contents of the `.eduk8signore` file are processed as a list of patterns and each is
applied recursively to subdirectories. To ensure that a file is only ignored if it resides in the
root directory, prefix it with `./`:

```text
./.dockerignore
./.gitignore
./Dockerfile
./LICENSE
./README.md
./kustomization.yaml
./resources
```

## <a id="cntnr-img-for-workshop"></a> Container image for the workshop

When you bundle the workshop content into a container image, the `content.image` field must specify
the image reference identifying the location of the container image that you will deploy for the workshop
instance:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
```

Even though you can download workshop content when the workshop environment starts,
you might still want to override the workshop image that is used as a base. You can do this when you have a
custom workshop base image that includes added language runtimes or tools that the specialized workshops require.

For example, if running a Java workshop, you can enter the `jdk11-environment` for the workshop image.
The workshop content is still downloaded from GitHub:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-spring-testing
spec:
  title: Spring Testing
  description: Playground for testing Spring development
  content:
    image: registry.tanzu.vmware.com/learning-center/jdk11-environment:latest
    files: {YOUR-GIT-REPO-URL}/lab-spring-testing
```

If you want to use the latest version of an image, always include the `:latest` tag.
This is important because the Learning Center Operator looks for version tags `:main`, `:main`,
`:develop` and `:latest`. When using these tags, the Operator sets the image pull policy to `Always` to ensure
that a newer version is always pulled if available.
Otherwise, the image is cached on the Kubernetes nodes and only pulled when it is initially absent. Any other version tags are always assumed to be unique and are never updated.
Be aware of image registries that use a content delivery network (CDN) as front end. When using these image tags, the CDN can
still regard them as unique and not do pull through requests to update an image even if it uses
a tag of `:latest`.

When special custom workshop base images are available as part of the Learning Center project,
instead of specifying the full location for the image, including the image registry, you can specify
a short name. The Learning Center Operator then fills in the rest of the details:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-spring-testing
spec:
  title: Spring Testing
  description: Playground for testing Spring development
  content:
    image: jdk11-environment:latest
    files: github.com/eduk8s-tests/lab-spring-testing
```

The supported short versions of the names are:

- `base-environment:*`: A tagged version of the `base-environment` workshop image matched with the current version of the Learning Center Operator.

The `*` variants of the short names map to the most up-to-date version of the image available when the version of the Learning Center Operator was released. That version is guaranteed to work with that version of the Learning Center Operator. The `latest` version can be newer, with possible incompatibilities.

If required, you can remap the short names in the `SystemProfile` configuration of the
Learning Center Operator. You can map additional short names to your own custom workshop base images
for your own deployment of the Learning Center Operator, and with any of your own workshops.

## <a id="set-env-vars"></a> Setting environment variables

To set or override environment variables for the workshop instance, you can supply the
`session.env` field:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    files: {YOUR-GIT-REPO-URL}/lab-markdown-sample
  session:
    env:
    - name: REPOSITORY-URL
      value: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
```

Where:

- The `session.env` field is a list of dictionaries with the `name` and `value` fields.
- The `value` field is the Git repository for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.

Values of fields in the list of resource objects can reference a number of predefined parameters.
The available parameters are:

- `session_id`: A unique ID for the workshop instance within the workshop environment.
- `session_namespace`: The namespace you create for and bind to the workshop instance.
This is the namespace unique to the session. A workshop can create its own resources.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where you create all
deployments of the workshop instances. It is also the namespace where the service account that the workshop
instance runs.
- `service_account`: The name of the service account that the workshop instance runs as. It has
access to the namespace you create for that workshop instance.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.
- `ingress_protocol`: The protocol (http/https) you use for ingress routes and create
for workshops.

The syntax for referencing the parameters is `$(parameter_name)`.

Use the `session.env` field to override environment variables only when they are required for the workshop.
To set or override an environment for a specific workshop environment, set environment variables in the `WorkshopEnvironment`
custom resource for the workshop environment instead.

## <a id="override-available-memory"></a> Overriding the memory available

By default the container the workshop environment runs in is allocated 512Mi.
If the editor is enabled, a total of 1Gi is allocated.

The memory allocation is sufficient for the workshop that is mainly aimed at deploying workloads into the Kubernetes cluster.
If you run workloads in the workshop environment container and need more memory, you can override the default by setting `memory` under
`session.resources`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
  session:
    resources:
      memory: 2Gi
```

## <a id="mount-persistent-volume"></a> Mounting a persistent volume

In circumstances where a workshop needs persistent storage to ensure no loss of work, you can request a persistent volume be mounted into the workshop container after the workshop environment container is stopped and restarted:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
  session:
    resources:
      storage: 5Gi
```

The persistent volume is mounted on top of the `/home/eduk8s` directory. Because this hides any
workshop content bundled with the image, an init container is automatically configured and run,
which copies the contents of the home directory to the persistent volume before the persistent volume
is mounted on top of the home directory.

## <a id="rsrc-budget-namespaces"></a> Resource budget for namespaces

In conjunction with each workshop instance, a namespace is created during the workshop.
From the terminal of the workshop, you can deploy dashboard applications into the namespace through the Kubernetes
REST API by using tools such as kubectl.

By default, this namespace has all the limit ranges and resource quotas the
Kubernetes cluster can enforce. In most cases, this means there are no limits or quotas.

To control how much resources you can use when you set no limit ranges and resource quotas,
or override any default limit ranges and resource quotas,
you can set a resource budget for any namespace of the workshop instance in the `session.namespaces.budget` field:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
  session:
    namespaces:
      budget: small
```

The resource budget sizings and quotas for CPU and memory are:

| Budget    | CPU   | Memory |
|-----------|-------|--------|
| small     | 1000m | 1Gi    |
| medium    | 2000m | 2Gi    |
| large     | 4000m | 4Gi    |
| x-large   | 8000m | 8Gi    |
| xx-large  | 8000m | 12Gi   |
| xxx-large | 8000m | 16Gi   |

A value of 1000m is equivalent to 1 CPU.

Separate resource quotas for CPU and memory are applied for terminating and non-terminating workloads.

Only the CPU and memory quotas are listed in the preceding table, but limits also apply to the number of
resource objects of certain types you can create, such as:

- persistent volume claims
- replication controllers
- services
- secrets

For each budget type, a limit range is created with fixed defaults. The limit ranges for CPU usage on a container are as follows:

| Budget    | Minimum| Maximum| Request | Limit |
|-----------|-----|-------|---------|-------|
| small     | 50m | 1000m | 50m     | 250m  |
| medium    | 50m | 2000m | 50m     | 500m  |
| large     | 50m | 4000m | 50m     | 500m  |
| x-large   | 50m | 8000m | 50m     | 500m  |
| xx-large  | 50m | 8000m | 50m     | 500m  |
| xxx-large | 50m | 8000m | 50m     | 500m  |


The limit ranges for memory are as follows:

| Budget    | Minimum | Maximum | Request | Limit |
|-----------|------|------|---------|-------|
| small     | 32Mi | 1Gi  | 128Mi   | 256Mi |
| medium    | 32Mi | 2Gi  | 128Mi   | 512Mi |
| large     | 32Mi | 4Gi  | 128Mi   | 1Gi   |
| x-large   | 32Mi | 8Gi  | 128Mi   | 2Gi   |
| xx-large  | 32Mi | 12Gi | 128Mi   | 2Gi   |
| xxx-large | 32Mi | 16Gi | 128Mi   | 2Gi   |


The request and limit values are the defaults of a container when there is no resources specification in a pod specification.

You can supply overrides in `session.namespaces.limits` to override the limit ranges and defaults for request and limit values
when a budget sizing for CPU and memory is sufficient and there is no resources specification in a pod specification:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-markdown-sample
spec:
  title: Markdown Sample
  description: A sample workshop using Markdown
  content:
    image: {YOUR-REGISTRY-URL}/lab-markdown-sample:main
  session:
    namespaces:
      budget: medium
      limits:
        min:
          cpu: 50m
          memory: 32Mi
        max:
          cpu: 1
          memory: 1Gi
        defaultRequest:
          cpu: 50m
          memory: 128Mi
        default:
          cpu: 500m
          memory: 1Gi
```

Although all the configurable properties are listed in this example,
you only need to supply the property for the value that you want to override.

If you need more control over the limit ranges and resource quotas,
you can set the resource budget to `custom`.
This removes any default limit ranges and resource quota that might be applied to the namespace.
You can enter your own `LimitRange` and `ResourceQuota` resources as part of the list of resources created for each session.

Before disabling the quota and limit ranges or contemplating any switch to using a custom set of
`LimitRange` and `ResourceQuota` resources, consider if that is what is really required.

The default requests defined by these for memory and CPU are fallbacks only.
In most cases, instead of changing the defaults, you can enter the memory and CPU resources in the pod template
specification of your deployment resources used in the workshop to indicate what the application requires.
This allows you to control exactly what the application can use and so
fit into the minimum quota required for the task.

This budget setting and the memory values are distinct from the amount of memory the container the
workshop environment runs in. To change how much memory is available to the workshop
container, set the `memory` setting under `session.resources`.

## <a id="patch-workshop-deployment"></a> Patching workshop deployment

In order to set or override environment variables, you can provide `session.env`.
To make other changes to the Pod template for the deployment used to create the workshop
instance, provide an overlay patch. You can use this patch to override the default
CPU and memory limit applied to the workshop instance or to mount a volume.

The patches are provided by setting `session.patches`. The patch is applied to the `spec` field of the pod template:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-resource-testing
spec:
  title: Resource testing
  description: Play area for testing memory resources
  content:
    files: github.com/eduk8s-tests/lab-resource-testing
  session:
    patches:
      containers:
      - name: workshop
        resources:
          requests:
            memory: "1Gi"
          limits:
            memory: "1Gi"
```

In this example, the default memory limit of "512Mi" is increased to "1Gi". Although memory is
set using a patch in this example, the `session.resources.memory` field is the preferred way to
override the memory allocated to the container the workshop environment is running in.

The patch works differently than overlay patches that you can find elsewhere in Kubernetes.
Specifically, when patching an array and the array contains a list of objects, a search is performed
on the destination array. If an object already exists with the same value for the `name` field,
the item in the source array is overlaid on top of the existing item in the destination array.

If there is no matching item in the destination array, the item in the source array is added to the end of the destination array.

This means an array doesn't outright replace an existing array, but a more intelligent merge is performed of elements in the array.

## <a id="create-session-resources"></a> Creation of session resources

When a workshop instance is created, the deployment running the workshop dashboard is created in the
namespace for the workshop environment. When more than one workshop instance is created under that
workshop environment, all those deployments are in the same namespace.

For each workshop instance, a separate empty namespace is created with name corresponding to the
workshop session. The workshop instance is configured so that the service account that the workshop
instance runs under can access and create resources in the namespace created for that workshop
instance. Each separate workshop instance has its own corresponding namespace and cannot see the
namespace for another instance.

To pre-create additional resources within the namespace for a workshop instance, you can
supply a list of the resources against the `session.objects` field within the workshop definition.
You might use this to add additional custom roles to the service account for the workshop instance
when working in that namespace or to deploy a distinct instance of an application for just that
workshop instance, such as a private image registry:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-registry-testing
spec:
  title: Registry Testing
  description: Play area for testing image registry
  content:
    files: github.com/eduk8s-tests/lab-registry-testing
  session:
    objects:
    - apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: registry
      spec:
        replicas: 1
        selector:
          matchLabels:
            deployment: registry
        strategy:
          type: Recreate
        template:
          metadata:
            labels:
              deployment: registry
          spec:
            containers:
            - name: registry
              image: registry.hub.docker.com/library/registry:2.6.1
              imagePullPolicy: IfNotPresent
              ports:
              - containerPort: 5000
                protocol: TCP
              env:
              - name: REGISTRY_STORAGE_DELETE_ENABLED
                value: "true"
    - apiVersion: v1
      kind: Service
      metadata:
        name: registry
      spec:
        type: ClusterIP
        ports:
        - port: 80
          targetPort: 5000
        selector:
          deployment: registry
```

For namespaced resources, it is not necessary to enter the `namespace` field of the
resource `metadata`. When the `namespace` field is not present, the resource is created within the session namespace for that workshop instance.

When resources are created, owner references are added, making the `WorkshopSession` custom resource
corresponding to the workshop instance the owner. This means that when the workshop instance is
deleted, any resources are deleted.

Values of fields in the list of resource objects can reference a number of predefined parameters.
The available parameters are:

- `session_id`: A unique ID for the workshop instance within the workshop environment.
- `session_namespace`: The namespace you create for and bound to the workshop instance. This is the
namespace unique to the session and where a workshop can create its own resources.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where you create all
deployments of the workshop instances. It is also the namespace where the service account that the workshop
instance runs.
- `service_account`: The name of the service account the workshop instance runs as and which has
access to the namespace you create for that workshop instance.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.
- `ingress_protocol`: The protocol (http/https) you use for ingress routes and create for workshops.

The syntax for referencing the parameter is `$(parameter_name)`.

For cluster-scoped resources, you must set the name of the created resource
so that it embeds the value of `$(session_namespace)`. This way the resource name is unique to the
workshop instance, and you do not get a clash with a resource for a different workshop instance.

For examples of making use of the available parameters, see the following sections.

## <a id="override-def-rbac-rules"></a> Overriding default role-based access control (RBAC) rules

By default the service account created for the workshop instance has `admin` role access to the
session namespace created for that workshop instance. This enables the service account to be used to
deploy applications to the session namespace and manage secrets and service accounts.

Where a workshop doesn't require `admin` access for the namespace, you can reduce the level of access
it has to `edit` or `view` by setting the `session.namespaces.role` field:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-role-testing
spec:
  title: Role Testing
  description: Play area for testing roles
  content:
    files: github.com/eduk8s-tests/lab-role-testing
  session:
    namespaces:
      role: view
```

To add additional roles to the service account, such as working with custom
resource types added to the cluster, you can add the appropriate `Role` and
`RoleBinding` definitions to the `session.objects` field described previously:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-kpack-testing
spec:
  title: Kpack Testing
  description: Play area for testing kpack
  content:
    files: github.com/eduk8s-tests/lab-kpack-testing
  session:
    objects:
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: Role
      metadata:
        name: kpack-user
      rules:
      - apiGroups:
        - build.pivotal.io
        resources:
        - builds
        - builders
        - images
        - sourceresolvers
        verbs:
        - get
        - list
        - watch
        - create
        - delete
        - patch
        - update
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
        name: kpack-user
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: Role
        name: kpack-user
      subjects:
      - kind: ServiceAccount
        namespace: $(workshop_namespace)
        name: $(service_account)
```

Because the subject of a `RoleBinding` must specify the service account name and namespace it is
contained within, both of which are unknown in advance, references to parameters for the workshop
namespace and service account for the workshop instance are used when defining the subject.

You can add additional resources with `session.objects` to grant cluster-level roles and the service account `cluster-admin` role:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-admin-testing
spec:
  title: Admin Testing
  description: Play area for testing cluster admin
  content:
    files: github.com/eduk8s-tests/lab-admin-testing
  session:
    objects:
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: $(session_namespace)-cluster-admin
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin
      subjects:
      - kind: ServiceAccount
        namespace: $(workshop_namespace)
        name: $(service_account)
```

In this case, the name of the cluster role binding resource embeds `$(session_namespace)` so that its
name is unique to the workshop instance and doesn't overlap with a binding for a different workshop
instance.

## <a id="run-user-cntnrs-as-root"></a> Running user containers as root

In addition to RBAC, which controls what resources a user can create and work with, Pod security
policies are applied to restrict what Pods/containers a user deploys can do.

By default the deployments that a workshop user can create are allowed only to run containers
as a non-root user. This means that many container images available on registries such as Docker Hub
cannot be used.

If you are creating a workshop where a user must run containers as the root user, you
must override the default `nonroot` security policy and select the `anyuid` security policy by using
the `session.namespaces.security.policy` setting:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-policy-testing
spec:
  title: Policy Testing
  description: Play area for testing security policies
  content:
    files: github.com/eduk8s-tests/lab-policy-testing
  session:
    namespaces:
      security:
        policy: anyuid
```

This setting applies to the primary session namespace and any secondary namespaces
created.

## <a id="create-extra-namespaces"></a> Creating additional namespaces

For each workshop instance, a primary session namespace is created. You can deploy or pre-deploy applications into this namespace as part of the workshop.

If you need more than one namespace per workshop instance, you can create secondary namespaces in a
couple of ways.

If the secondary namespaces are to be created empty, you can list the details of the namespaces under
the property `session.namespaces.secondary`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-namespace-testing
spec:
  title: Namespace Testing
  description: Play area for testing namespaces
  content:
    files: github.com/eduk8s-tests/lab-namespace-testing
  session:
    namespaces:
      role: admin
      budget: medium
      secondary:
      - name: $(session_namespace)-apps
        role: edit
        budget: large
        limits:
          default:
            memory: 512mi
```

When secondary namespaces are created, by default, the role, resource quotas, and limit ranges are
set the same as the primary session namespace. Each namespace has a separate resource
budget and it is not shared.

If required, you can override what `role`, `budget`, and `limits` are applied within the entry for the namespace.

Similarly, you can override the security policy for secondary namespaces on a case-by-case basis by
adding the `security.policy` setting under the entry for the secondary namespace.

To create resources in the namespaces you create, create
the namespaces by adding an appropriate `Namespace` resource to `session.objects` with the definitions of the resources you want to create in the namespaces:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-namespace-testing
spec:
  title: Namespace Testing
  description: Play area for testing namespaces
  content:
    files: github.com/eduk8s-tests/lab-namespace-testing
  session:
    objects:
    - apiVersion: v1
      kind: Namespace
      metadata:
        name: $(session_namespace)-apps
```

When listing any other resources to be created within the added namespace, such as deployments,
ensure that the `namespace` is set in the `metadata` of the resource.
For example, `$(session_namespace)-apps`.

To override what role the service account for the workshop instance has in the added
namespace, you can set the `learningcenter.tanzu.vmware.com/session.role` annotation on the
`Namespace` resource:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-namespace-testing
spec:
  title: Namespace Testing
  description: Play area for testing namespaces
  content:
    files: github.com/eduk8s-tests/lab-namespace-testing
  session:
    objects:
    - apiVersion: v1
      kind: Namespace
      metadata:
        name: $(session_namespace)-apps
        annotations:
          learningcenter.tanzu.vmware.com/session.role: view
```

To have a different resource budget set for the additional namespace, you can add the
annotation `learningcenter.tanzu.vmware.com/session.budget` in the `Namespace` resource metadata and
set the value to the required resource budget:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-namespace-testing
spec:
  title: Namespace Testing
  description: Play area for testing namespaces
  content:
    files: github.com/eduk8s-tests/lab-namespace-testing
  session:
    objects:
    - apiVersion: v1
      kind: Namespace
      metadata:
        name: $(session_namespace)-apps
        annotations:
          learningcenter.tanzu.vmware.com/session.budget: large
```

To override the limit range values applied corresponding to the budget applied, you can add
annotations starting with `learningcenter.tanzu.vmware.com/session.limits.` for each entry:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-namespace-testing
spec:
  title: Namespace Testing
  description: Play area for testing namespaces
  content:
    files: github.com/eduk8s-tests/lab-namespace-testing
  session:
    objects:
    - apiVersion: v1
      kind: Namespace
      metadata:
        name: $(session_namespace)-apps
        annotations:
          learningcenter.tanzu.vmware.com/session.limits.min.cpu: 50m
          learningcenter.tanzu.vmware.com/session.limits.min.memory: 32Mi
          learningcenter.tanzu.vmware.com/session.limits.max.cpu: 1
          learningcenter.tanzu.vmware.com/session.limits.max.memory: 1Gi
          learningcenter.tanzu.vmware.com/session.limits.defaultrequest.cpu: 50m
          learningcenter.tanzu.vmware.com/session.limits.defaultrequest.memory: 128Mi
          learningcenter.tanzu.vmware.com/session.limits.request.cpu: 500m
          learningcenter.tanzu.vmware.com/session.limits.request.memory: 1Gi
```

You only must supply annotations for the values you want to override.

If you need more fine-grained control over the limit ranges and resource quotas, set the value of
the annotation for the budget to `custom` and add the `LimitRange` and `ResourceQuota` definitions
to `session.objects`.

In this case you must set the `namespace` for the `LimitRange` and `ResourceQuota` resource to the
name of the namespace, e.g., `$(session_namespace)-apps` so they are only applied to that namespace.

To set the security policy for a specific namespace other than the primary session
namespace, you can add the annotation `learningcenter.tanzu.vmware.com/session.security.policy` in
the `Namespace` resource metadata and set the value to `nonroot`, `anyuid`, or `custom` as necessary.

## <a id="shared-workshop-resources"></a> Shared workshop resources

Adding a list of resources to `session.objects` causes the given resources to be created for
each workshop instance, whereas namespaced resources default to being created in the session namespace for a workshop instance.

If instead you want to have one common shared set of resources created once for the whole workshop
environment, that is, used by all workshop instances, you can list them in the `environment.objects`
field.

This might, for example, be used to deploy a single container image registry used by all workshop
instances, with a Kubernetes job used to import a set of images into the container image registry, which are then referenced by the workshop instances.

For namespaced resources, it is not necessary to enter the `namespace` field of the resource
`metadata`. When the `namespace` field is not present, the resource is created within
the workshop namespace for that workshop environment.

When resources are created, owner references are added, making the `WorkshopEnvironment` custom
resource correspond to the workshop environment of the owner. This means that when the workshop
environment is deleted, any resources are also deleted.

Values of fields in the list of resource objects can reference a number of predefined parameters.
The available parameters are:

- `workshop_name`: The name of the workshop. This is the name of the `Workshop` definition the
workshop environment was created against.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `environment_token`: The value of the token that must be used in workshop requests against the workshop environment.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where all
deployments of the workshop instances, and their service accounts, are created. It is the same
namespace that shared workshop resources are created.
- `service_account`: The name of a service account you can use when creating deployments in
the workshop namespace.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.
- `ingress_protocol`: The protocol (http/https) used for ingress routes created
for workshops.
- `ingress_secret`: The name of the ingress secret stored in the workshop namespace when secure
ingress is used.

To create additional namespaces associated with the workshop environment, embed a
reference to `$(workshop_namespace)` in the name of the additional namespaces with an appropriate
suffix. Be careful that the suffix doesn't overlap with the range of session IDs for workshop
instances.

When creating deployments in the workshop namespace, set the `serviceAccountName` of the `Deployment`
resource to `$(service_account)`. This ensures the deployment makes use of a special Pod security
policy set up by the Learning Center. If this isn't used and the cluster imposes a more strict
default Pod security policy, your deployment might not work, especially if any image runs as
`root`.

## <a id="workshop-pod-security-pol"></a> Workshop pod security policy

The pod for the workshop session is set up with a pod security policy that restricts what you can do
from containers in the pod. The nature of the applied pod security policy is adjusted when
enabling support for doing Docker builds. This in turn enables Docker builds
inside the sidecar container attached to the workshop container.

If you are customizing the workshop by patching the pod specification
using `session.patches` to add your own sidecar container,
and that sidecar container must run as the root user or needs a custom pod security policy,
you must override the default security policy for the workshop container.

To allow a sidecar container to run as the root user with no extra
privileges required, you can override the default `nonroot` security policy and set it to
`anyuid`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-policy-testing
spec:
  title: Policy Testing
  description: Play area for testing security policies
  content:
    files: github.com/eduk8s-tests/lab-policy-testing
  session:
    security:
      policy: anyuid
```

This is a different setting than described previously for changing the security policy for
deployments made by a workshop user to the session namespaces. This setting applies only to the
workshop container itself.

If you need more fine-grained control of the security policy, you must provide your own resources
for defining the Pod security policy and map it so it is used. The details of the pod security policy
must be in `environment.objects` and mapped by definitions added to `session.objects`.
For this to be used, you must deactivate the application of the inbuilt pod security policies.
You can do this by setting `session.security.policy` to `custom`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-policy-testing
spec:
  title: Policy Testing
  description: Play area for testing policy override
  content:
    files: github.com/eduk8s-tests/lab-policy-testing
  session:
    security:
      policy: custom
    objects:
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
        namespace: $(workshop_namespace)
        name: $(session_namespace)-podman
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: $(workshop_namespace)-podman
      subjects:
      - kind: ServiceAccount
        namespace: $(workshop_namespace)
        name: $(service_account)
  environment:
    objects:
    - apiVersion: policy/v1beta1
      kind: PodSecurityPolicy
      metadata:
        name: aa-$(workshop_namespace)-podman
      spec:
        privileged: true
        allowPrivilegeEscalation: true
        requiredDropCapabilities:
        - KILL
        - MKNOD
        hostIPC: false
        hostNetwork: false
        hostPID: false
        hostPorts: []
        runAsUser:
          rule: MustRunAsNonRoot
        seLinux:
          rule: RunAsAny
        fsGroup:
          rule: RunAsAny
        supplementalGroups:
          rule: RunAsAny
        volumes:
        - configMap
        - downwardAPI
        - emptyDir
        - persistentVolumeClaim
        - projected
        - secret
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
        name: $(workshop_namespace)-podman
      rules:
      - apiGroups:
        - policy
        resources:
        - podsecuritypolicies
        verbs:
        - use
        resourceNames:
        - aa-$(workshop_namespace)-podman
```

By overriding the pod security policy, you are responsible for limiting what you can do from the
workshop pod. In other words, add only the extra capabilities you need. The pod
security policy is applied only to the pod the workshop session runs in. It does not change any pod
security policy applied to service accounts that exist in the session namespace or other namespaces you have created.

There is a better way to set the priority of applied Pod security policies when a default
Pod security policy is applied globally by mapping it to the `system:authenticated` group.
This causes priority falling back to the order of the names of the Pod security policies.
VMware recommends you use `aa-` as a prefix to the custom Pod security name you create.
This ensures it takes precedence over any global default Pod security policy such as `restricted`, `pks-restricted` or
`vmware-system-tmc-restricted`, no matter what the name of the global policy default.


## <a id="custom-sec-pol-user-cont"></a> Custom security policies for user containers

You can also set the value of the `session.namespaces.security.policy` setting as
`custom`. This gives you more fine-grained control of the security policy applied to the
pods and containers that a user deploys during a session.
In this case you must provide your own resources that define and map the pod security policy.

For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-policy-testing
spec:
  title: Policy Testing
  description: Play area for testing policy override
  content:
    files: github.com/eduk8s-tests/lab-policy-testing
  session:
    namespaes:
      security:
        policy: custom
    objects:
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
        namespace: $(workshop_namespace)
        name: $(session_namespace)-security-policy
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: $(workshop_namespace)-security-policy
      subjects:
      - kind: Group
        namespace: $(workshop_namespace)
        name: system:serviceaccounts:$(workshop_namespace)
  environment:
    objects:
    - apiVersion: policy/v1beta1
      kind: PodSecurityPolicy
      metadata:
        name: aa-$(workshop_namespace)-security-policy
      spec:
        privileged: true
        allowPrivilegeEscalation: true
        requiredDropCapabilities:
        - KILL
        - MKNOD
        hostIPC: false
        hostNetwork: false
        hostPID: false
        hostPorts: []
        runAsUser:
          rule: MustRunAsNonRoot
        seLinux:
          rule: RunAsAny
        fsGroup:
          rule: RunAsAny
        supplementalGroups:
          rule: RunAsAny
        volumes:
        - configMap
        - downwardAPI
        - emptyDir
        - persistentVolumeClaim
        - projected
        - secret
    - apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
        name: $(workshop_namespace)-security-policy
      rules:
      - apiGroups:
        - policy
        resources:
        - podsecuritypolicies
        verbs:
        - use
        resourceNames:
        - aa-$(workshop_namespace)-security-policy
```

You can also do this on secondary namespaces by either changing the
`session.namespaces.secondary.security.policy` setting to `custom` or using the
`learningcenter.tanzu.vmware.com/session.security.policy: custom` annotation.


## <a id="def-extra-ingress-points"></a> Defining additional ingress points

If running additional background applications, by default they are only accessible to other
processes within the same container. For an application to be accessible to a user through their web browser,
an ingress must be created mapping to the port for the application.

You can do this by supplying a list of the ingress points and the internal container port
they map to by setting the `session.ingresses` field in the workshop definition:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    ingresses:
    - name: application
      port: 8080
```

The form of the host name used in the URL to access the service is:

```console
$(session_namespace)-application.$(ingress_domain)
```

This name cannot be `terminal`, `console`, `slides`, `editor`, or the name of any built-in
dashboard.
These values are reserved for the corresponding built-in capabilities providing those features.

In addition to specifying ingresses for proxying to internal ports within the same Pod, you can
enter a `host`, `protocol` and `port` corresponding to a separate service running in the Kubernetes
cluster:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    ingresses:
    - name: application
      protocol: http
      host: service.namespace.svc.cluster.local
      port: 8080
```

You can use variables providing information about the current session within the `host` property if
required:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    ingresses:
    - name: application
      protocol: http
      host: service.$(session_namespace).svc.cluster.local
      port: 8080
```

Available variables are:

- `session_namespace`: The namespace you create for and bind to the workshop instance. This is the
namespace unique to the session and where a workshop can create its own resources.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where you create all
deployments of the workshop instances and where the service account that the workshop instance runs.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.

If the service uses standard `http` or `https` ports, you can leave out the `port` property, and the
port is set based on the value of `protocol`.

When a request is proxied, you can specify additional request headers that must be passed to the
service:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    ingresses:
    - name: application
      protocol: http
      host: service.$(session_namespace).svc.cluster.local
      port: 8080
      headers:
      - name: Authorization
        value: "Bearer $(kubernetes_token)"
```

The value of a header can reference the following variable:

- `kubernetes_token`: The access token of the service account for the current workshop session,
used for accessing the Kubernetes REST API.

Access controls enforced by the workshop environment or training portal protect accessing any service through the ingress.
If you use the training portal, this must be transparent.
Otherwise, supply any login credentials for the workshop again when prompted by your web browser.

## <a id="external-ws-instructions"></a> External workshop instructions

In place of using workshop instructions provided with the workshop content, you can use externally
hosted instructions instead. To do this set `sessions.applications.workshop.url` to the URL of an
external web site:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      workshop:
        url: https://www.example.com/instructions
```

The external web site must displayed in an HTML iframe, is shown as is and must provide its own page
navigation and table of contents if required.

The URL value can reference a number of predefined parameters. The available parameters are:

- `session_namespace`: The namespace you create for and bind to the workshop instance. This is the
namespace unique to the session and where a workshop can create its own resources.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where you create all
deployments of the workshop instances and where the service account that the workshop
instance runs.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.
- `ingress_protocol`: The protocol (http/https) used for ingress routes that you create for workshops.

These could be used, for example, to reference workshops instructions hosted as part of the workshop
environment:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      workshop:
        url: $(ingress_protocol)://$(workshop_namespace)-instructions.$(ingress_domain)
  environment:
    objects:
    - ...
```

In this case `environment.objects` of the workshop `spec` must include resources to deploy the
application hosting the instructions and expose it through an appropriate ingress.

## <a id="deactivate-ws-instructions"></a> Deactivating workshop instructions

The aim of the workshop environment is to provide instructions for a workshop that users can follow.
If you want instead to use the workshop environment as a development environment or as an
administration console that provides access to a Kubernetes cluster, you can deactivate the display of
workshop instructions provided with the workshop content. In this case, only the work area with the
terminals, console, and so on, is displayed. To deactivate display of workshop instructions, add a
`session.applications.workshop` section and set the `enabled` property to `false`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      workshop:
        enabled: false
```

## <a id="enable-kubernetes-console"></a> Enabling the Kubernetes console

By default the Kubernetes console is not enabled. To enable it and make it available
through the web browser when accessing a workshop, add a `session.applications.console`
section to the workshop definition, and set the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      console:
        enabled: true
```

The Kubernetes dashboard provided by the Kubernetes project is used.
To use Octant as the console, you can set the `vendor` property to `octant`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      console:
        enabled: true
        vendor: octant
```

When `vendor` is not set, `kubernetes` is assumed.

## <a id="enable-integrated-editor"></a> Enabling the integrated editor

By default the integrated web based editor is not enabled. To enable it and make it
available through the web browser when accessing a workshop, add a
`session.applications.editor` section to the workshop definition, and set the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      editor:
        enabled: true
```

The integrated editor used is based on Visual Studio Code. For more information about the editor, see [https://github.com/cdr/code-server](https://github.com/cdr/code-server) in GitHub.

To install additional VS Code extensions, do this from the editor.
Alternatively, if building a custom workshop, you can install them from your `Dockerfile` into your
workshop image by running:

```console
code-server --install-extension vendor.extension
```

Replace `vendor.extension` with the name of the extension, where the name identifies the extension on
the VS Code extensions marketplace used by the editor or provide a path name to a local `.vsix` file.

This installs the extensions into `$HOME/.config/code-server/extensions`.

If downloading extensions yourself and unpacking them or extensions are part of your Git repository,
you can instead locate them in the `workshop/code-server/extensions` directory.

## <a id="enable-workshop-downloads"></a> Enabling workshop downloads

You can provide a way for a workshop user to download files as
part of the workshop content. Enable this by adding the `session.applications.files`
section to the workshop definition and setting the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      files:
        enabled: true
```

The recommended way of providing access to files from workshop instructions is using the
`files:download-file` clickable action block. This action ensures any file is downloaded to the local
machine and is not displayed in the browser in place of the workshop instructions.

By default the user can access any files located under the home directory of the workshop user account.
To restrict where the user can download files from, set the `directory` setting:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      files:
        enabled: true
        directory: exercises
```

When the specified directory is a relative path, it is evaluated relative to the home directory of
the workshop user.

## <a id="enable-test-examiner"></a> Enabling the test examiner

The test examiner is a feature that allows a workshop to have verification checks that
the workshop instructions can trigger. The test examiner is deactivated by default.
To enable it, add a `session.applications.examiner` section to the workshop
definition and set the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      examiner:
        enabled: true
```

You must provide any executable test programs for verification checks in the
`workshop/examiner/tests` directory.

The test programs must return an exit status of 0 if the test is successful and nonzero if it fails. Test programs must not be persistent programs that can run forever.

Clickable actions for the test examiner are used within the workshop instructions to trigger the verification checks.
You can configure them to start when the page of the workshop instructions is loaded.

## <a id="enable-session-img-reg"></a> Enabling session image registry

Workshops using tools such as `kpack` or `tekton` and which need a place to push container images
when built can enable a container image registry. A separate registry is deployed for each workshop
session.

The container image registry is currently fully usable only if workshops are deployed under a Learning Center
Operator configuration that uses secure ingress. This is because a registry that is not secure is not trusted by the Kubernetes cluster as the source of container images when doing deployments.

To enable the deployment of a registry per workshop session, add a
`session.applications.registry` section to the workshop definition and set the `enabled` property to
`true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      registry:
        enabled: true
```

The registry mounts a persistent volume for storing of images. By default the size of that
persistent volume is 5Gi. To override the size of the persistent volume, add the `storage`
property under the `registry` section:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      registry:
        enabled: true
        storage: 20Gi
```

The amount of memory provided to the registry defaults to 768Mi. To increase this,
add the `memory` property under the `registry` section.

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      registry:
        enabled: true
        memory: 1Gi
```

The registry is secured with a user name and password unique to the workshop session, and must be accessed over a secure connection.

To allow access from the workshop session, the file `$HOME/.docker/config.json` containing the
registry credentials are injected into the workshop session. This is used by tools
such as `docker`.

For deployments in Kubernetes, a secret of type `kubernetes.io/dockerconfigjson` is created in the
namespace and applied to the `default` service account in the namespace.
This means deployments made using the default service account can pull images from the
registry without additional configuration. If creating deployments using other service accounts,
add configuration to the service account or deployment to add the registry secret for pulling images.

If you need access to the raw registry host details and credentials, they are provided as environment
variables in the workshop session. The environment variables are:

- `REGISTRY_HOST`: Contains the host name for the registry for the workshop session.
- `REGISTRY_AUTH_FILE`: Contains the location of the `docker` configuration file. Must be
the equivalent of `$HOME/.docker/config.json`.
- `REGISTRY_USERNAME`: Contains the user name for accessing the registry.
- `REGISTRY_PASSWORD`: Contains the password for accessing the registry. This is different
for each workshop session.
- `REGISTRY_SECRET`: Contains the name of a Kubernetes secret of type `kubernetes.io/dockerconfigjson`
added to the session namespace, which contains the registry credentials.

The URL for accessing the registry adopts the HTTP protocol scheme inherited from the
environment variable `INGRESS_PROTOCOL`. This is the same HTTP protocol scheme the workshop
sessions use.

To use any of the variables as data variables in workshop content, use the same variable
name but in lowercase: `registry_host`, `registry_auth_file`, `registry_username`,
`registry_password` and `registry_secret`.

## <a id="enable-ability-use-docker"></a> Enabling ability to use Docker

To build container images in a workshop using `docker`, first enable
it. Each workshop session is provided with its own separate Docker daemon instance running in
a container.

Enabling support for running `docker` requires the use of a privileged container for running the
Docker daemon. Because of the security implications of providing access to Docker with this
configuration, VMware recommends that if you don't trust the people taking the workshop,
any workshops that require Docker only be hosted in a disposable Kubernetes cluster that is
destroyed at the completion of the workshop. You must not enable Docker for workshops hosted on
a public service that is always kept running and where arbitrary users can access the workshops.

To enable support for using `docker` add a `session.applications.docker` section to the
workshop definition and set the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      docker:
        enabled: true
```

The container that runs the Docker daemon mounts a persistent volume for storing of images which
are pulled down or built locally. By default the size of that persistent volume is 5Gi.
To override the size of the persistent volume, add the `storage` property under the `docker` section:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      docker:
        enabled: true
        storage: 20Gi
```

The amount of memory provided to the container running the Docker daemon defaults to 768Mi.
To increase this, add the `memory` property under the `registry` section:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      docker:
        enabled: true
        memory: 1Gi
```

Access to the Docker daemon from the workshop session uses a local UNIX socket shared with the container running the Docker daemon.
If it uses a local tool to access the socket connection for the Docker daemon directly rather than by running `docker`, it must use the
`DOCKER_HOST` environment variable to set the location of the socket.

The Docker daemon is only available from within the workshop session and cannot be accessed outside
of the pod by any tools deployed separately to Kubernetes.

## <a id="enable-webdav-access"></a> Enabling WebDAV access to files

You can access or update local files within the workshop session from the terminal command line or editor of the workshop dashboard.
The local files reside in the file system of the container the workshop session is running in.

To access the files remotely, you can enable WebDAV support for the workshop session.

To enable support for accessing files over WebDAV, add a `session.applications.webdav`
section to the workshop definition, and set the `enabled` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      webdav:
        enabled: true
```

This causes a WebDAV server running within the workshop session environment.
A set of credentials is also generated and are available as environment variables.
The environment variables are:

- `WEBDAV_USERNAME`: Contains the user name that must be used when authenticating over WebDAV.
- `WEBDAV_PASSWORD`: Contains the password that must be used when authenticating over WebDAV.

To use any of the environment variables related to the container image registry as data variables
in workshop content, declare this in the `workshop/modules.yaml` file in the `config.vars`
section:

```yaml
config:
  vars:
  - name: WEBDAV_USERNAME
  - name: WEBDAV_PASSWORD
```

The URL endpoint for accessing the WebDAV server is the same as the workshop session, with
`/webdav/` path added. This can be constructed from the terminal using:

```console
$INGRESS_PROTOCOL://$SESSION_NAMESPACE.$INGRESS_DOMAIN/webdav/
```

In workshop content it can be constructed using:

```console
\{{ingress_protocol}}://\{{session_namespace}}.\{{ingress_domain}}/webdav/
```

You can use WebDAV client support provided by your operating system or by using a
standalone WebDAV client, such as [CyberDuck](https://cyberduck.io/).

Using WebDAV can make it easier to transfer files to or from the workshop session.

## <a id="customize-terminal-layout"></a> Customizing the terminal layout

By default a single terminal is provided in the web browser when accessing the workshop.
If required, you can enable alternate layouts which provide additional terminals.
To set the layout, add the `session.applications.terminal` section and include the `layout` property with the desired layout:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    applications:
      terminal:
        enabled: true
        layout: split
```

The options for the `layout` property are:

- `default`: Single terminal.
- `split`: Two terminals stacked above each other in ratio 60/40.
- `split/2`: Three terminals stacked above each other in ratio 50/25/25.
- `lower`: A single terminal is placed below any dashboard tabs, rather than being a tab of its own.
The ratio of dashboard tab to terminal is 70/30.
- `none`: No terminal is displayed but can still be created from the drop down menu.

When adding the `terminal` section, you must include the `enabled` property and set it to `true` as
it is a required field when including the section.

If you don't want a terminal displayed and also want to deactivate the ability to create terminals from the drop-down menu, set `enabled` to `false`.

## <a id="add-custom-dashboard-tabs"></a> Adding custom dashboard tabs

Exposed applications, external sites and additional terminals, can be given their own custom
dashboard tab. This is done by specifying the list of dashboard panels and the target URL:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    ingresses:
    - name: application
      port: 8080
    dashboards:
    - name: Internal
      url: "$(ingress_protocol)://$(session_namespace)-application.$(ingress_domain)/"
    - name: External
      url: http://www.example.com
```

The URL values can reference a number of predefined parameters. The available parameters are:

- `session_namespace`: The namespace you create for and bind to the workshop instance. This is the
namespace unique to the session and where a workshop can create its own resources.
- `environment_name`: The name of the workshop environment. Its current value is the name of
the namespace for the workshop environment and subject to change.
- `workshop_namespace`: The namespace for the workshop environment. This is the namespace where all
deployments of the workshop instances you create and where the service account that the workshop
instance runs.
- `ingress_domain`: The host domain under which you can create host names when creating ingress routes.
- `ingress_protocol`: The protocol (http/https) used for ingress routes that you create
for workshops.

The URL can reference an external web site, however, that web site must not prohibit being embedded in an HTML iframe.

In the case of wanting to have a custom dashboard tab provide an additional terminal, the `url`
property must use the form `terminal:<session>`, where `<session>` is replaced with the name of the
terminal session. The name of the terminal session can be any name you choose, but must be restricted
to lowercase letters, numbers, and dashes. You should avoid using numeric terminal session names such
as "1", "2", and "3" as these are used for the default terminal sessions.

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-application-testing
spec:
  title: Application Testing
  description: Play area for testing my application
  content:
    image: {YOUR-REGISTRY-URL}/lab-application-testing:main
  session:
    dashboards:
    - name: Example
      url: terminal:example
```
