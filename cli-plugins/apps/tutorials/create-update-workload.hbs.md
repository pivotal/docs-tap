# Create/Update a Workload

Refer to the [Supply Chain How-to-guides](../../../scc/scc-how-to.hbs.md) for different type of 
workload creation.

## <a id='create-yaml-url'></a> Create workload from a workload.yaml file or from a URL

### <a id='workload-from-yaml'></a> Workload from a YAML file

In many cases, workload life cycles are managed through CLI commands. However, there might be cases 
where managing the workload through direct interactions and edits of a `yaml` file is preferred. 
The Apps CLI plug-in supports using `yaml` files to meet the requirements.

When a workload is managed using a `yaml` file, that file must **contain a single workload definition**.

For example, a valid file looks similar to the following example:

```yaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/vmware-tanzu/application-accelerator-samples
      ref:
        tag: tap-1.6.0
    subPath: tanzu-java-web-app
```

To create a workload from a file like the earlier example:

```bash
tanzu apps workload create --file my-workload-file.yaml
```

>**Note** When flags are passed in combination with `--file my-workload-file.yaml` the flag values 
>take precedence over the associated property or values in the YAML.

### <a id='workload-from-stdin'></a> Workload from standard input

The workload `yaml` definition can also be passed in through stdin as follows:

```bash
tanzu apps workload create --file - --yes
```

The console waits for input, and the content with valid `yaml` definitions for a workload can either
be written or pasted. Then click `Ctrl-D` three times to start the workload creation.
This can also be done with the `workload apply` command.

To pass a workload through `stdin`, the `--yes` flag is required. If not provided, the
command fails.

```bash
tanzu apps workload create -f -y
❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files will replace rather than merge existing configuration. The change will take place in the January 2024 TAP release (use "--update-strategy" to control strategy explicitly).

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
spec:
  source:
    git:
      url: https://github.com/vmware-tanzu/application-accelerator-samples
      ref:
        tag: tap-1.6.0
    subPath: tanzu-java-web-app
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
      7 + |    apps.tanzu.vmware.com/workload-type: server
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        tag: tap-1.6.0
     15 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     16 + |    subPath: tanzu-java-web-app
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"
```

### <a id='workload-from-url'></a> Workload from URL

Another way to pass a workload with the --file flag is using a URL, which must contain a raw file
with the workload definition.

For example:

```bash
tanzu apps workload create --file https://raw.githubusercontent.com/vmware-tanzu/apps-cli-plugin/main/pkg/commands/testdata/workload.yaml
```

## <a id='create-workload-git'></a> Create workload from Git source

Use the flags `--git-repo`, `--git-branch`, `--git-tag`, and `--git-commit` flags to create a 
workload from an existing Git repository. This allows the [supply chain](../../../scc/about.hbs.md) 
to get the source from the given repository to deploy the application.

To create a named workload and specify a Git source code location, run:

```bash
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-1.6.0 --type web
```

Respond `Y` to prompts to complete process.

Where:

- `tanzu-java-web-app` is the name of the workload.
- `--git-repo` is the location of the code to build the workload from.
- `--sub-path` (optional) is the relative path inside the repository to treat as application root.
- `--git-tag` (optional) specifies which tag in the repository to pull the code from.
- `--git-branch` (optional) specifies which branch in the repository to pull the code from.
- `--type` distinguishes the workload type.

This process can also be done with non-publicly accessible repositories. These require authentication
using credentials stored in a Kubernetes secret. The supply chain is in charge of managing these credentials.
<!-- IMPORTANT: Point to the How-to-guide section Create a workload from a Private Git Repository
that will be created in another PR -->

View the full list of supported workload configuration options
by running `tanzu apps workload apply --help`.

### <a id='unset-git-fields'></a> Unsetting Git fields

There are various ways to update a workload. It can be by changing its fields through flags or
create a `yaml` file with the changes and run `tanzu apps workload apply` command with the 
`--update-strategy` set as `replace`.
<!--IMPORTANT: add the following line and
point to the How-to-guide section (check --update-strategy in the Control workload merge behavior section).-->

Nevertheless, when it comes to deleting fields, there is a simpler method available through the use 
of the `--git-*` flags. By setting these flags as empty strings within the command, 
the `workload.spec.source.git` fields are effectively removed.

For instance, when dealing with a workload that includes specifications such as `--git-tag`, `--git-commit`
and/or `--git-branch`, removing any of these can be easily accomplished by simply setting them as
empty strings in the command as shown in the following example:

```yaml
# existing workload definition
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-java-web-app
  namespace: default
spec:
  source:
    git:
      ref:
        branch: main
        tag: tap-1.6.0
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: tanzu-java-web-app
```

```bash
# Update the workload to remove one of its git fields
tanzu apps workload apply tanzu-java-web-app --git-branch ""
🔎 Update workload:
...
  9,  9   |spec:
 10, 10   |  source:
 11, 11   |    git:
 12, 12   |      ref:
 13     - |        branch: main
 14, 13   |        tag: tap-1.6.0
 15, 14   |      url: https://github.com/vmware-tanzu/application-accelerator-samples
 16, 15   |    subPath: tanzu-java-web-app
❓ Really update the workload "tanzu-java-web-app"? [yN]: y
👍 Updated workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

# Export the workload to see that `spec.source.git.ref.tag` is not part of the definition
tanzu apps workload get tanzu-java-web-app --export
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-java-web-app
  namespace: default
spec:
  source:
    git:
      ref:
        tag: tap-1.6.0
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: tanzu-java-web-app
```

>**Note** If `--git-repo` is set to empty, then the whole git section is going to be removed from 
>the workload definition.

```bash
tanzu apps workload apply tanzu-java-web-app --git-repo ""
🔎 Update workload:
...
  5,  5   |  labels:
  6,  6   |    apps.tanzu.vmware.com/workload-type: web
  7,  7   |  name: tanzu-java-web-app
  8,  8   |  namespace: default
  9     - |spec:
 10     - |  source:
 11     - |    git:
 12     - |      ref:
 13     - |        tag: tap-1.6.0
 14     - |      url: https://github.com/vmware-tanzu/application-accelerator-samples
 15     - |    subPath: tanzu-java-web-app
      9 + |spec: {}
❗ NOTICE: no source code or image has been specified for this workload.
❓ Really update the workload "tanzu-java-web-app"? [yN]: y
👍 Updated workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

# Export the workload and check that the git source section does not exist
tanzu apps workload get tanzu-java-web-app --export
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-java-web-app
  namespace: default
spec: {}
```

### <a id='workload-git-subpath'></a> Subpath

The subpath flag is designed to facilitate the creation of workloads within a repository, 
particularly in cases where the repository, such as a monorepo, consists of multiple folders or projects.

```bash
# The Git repository for this sample contains several applications, each on its own folder
tanzu apps workload apply tanzu-where-for-dinner --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-branch main --sub-path where-for-dinner 
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: tanzu-where-for-dinner
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: where-for-dinner
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-where-for-dinner"

To see logs:   "tanzu apps workload tail tanzu-where-for-dinner --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-where-for-dinner"
```

## <a id='create-workload-local'></a> Create workload from Local Source

There are multiple ways a developer can upload their local source code to a Tanzu Application 
Platform cluster.

Using Local Source Proxy
: The new Local Source Proxy component for TAP allows developers to push their local source code to 
  the registry configured by the Platform operators during TAP installation.
    Check the Local Source Proxy installation instructions in [install LSP section](../../../local-source-proxy/install.hbs.md)
    To create a workload that pushes to an already configured registry through Local Source Proxy, 
    use `--local-path` flag without `--source-image`, like the following example:

```bash
# Point the local path flag to the folder containing the source code
tanzu apps workload create tanzu-java-web-app --local-path /path/to/java/app

The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "/path/to/java/app" to "local-source-proxy.tap-local-source-system.svc.cluster.local/source:default-tanzu-java-web-app"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  annotations:
      6 + |    local-source-proxy.apps.tanzu.vmware.com: registry.io/project/source:default-tanzu-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
      7 + |  labels:
      8 + |    apps.tanzu.vmware.com/workload-type: web
      9 + |  name: tanzu-java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    image: registry.io/project/source:default-tanzu-java-web-app@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
❓ Do you want to create this workload? [yN]: 
```

>**Note** A workload created using Local Source Proxy is easily recognisable because it has the
> `local-source-proxy.apps.tanzu.vmware.com` annotation,
> whose value is the same as the `spec.source.image` field.

Using Source Image
: If the Local Source Proxy component is not installed, Developers can upload their local source 
  code to a registry of their choice by passing in the --source-image flag. This flag is used to 
  specify the registry path where the local source code is going to be uploaded as an image.
     Both the cluster and the developer’s machine must be configured to properly provide credentials
     for accessing the container image registry where the local source code is published to. More
     information on authentication requirements can be found in the Supply chain documentation for 
     [Building from Local Source](../../../scc/building-from-source.hbs.md#authentication)
     To create a workload using a source image, use `--local-path` flag alongside `--source-image`,
     like the following example:

```bash
tanzu apps workload create tanzu-java-web-app --local-path /path/to/java/app --source-image registry.io/path/to/project/image-name

The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "." to "registry.io/path/to/project/image-name"...
📥 Published source

🔎 Create workload:
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
     11 + |    image: registry.io/path/to/project/image-name:latest@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
❓ Do you want to create this workload? [yN]: 
```

### <a id='workload-local-live-update'></a> `--live-update`

Use the `--live-update` flag to ensure that local source code changes are reflected quickly
on the running workload. This is particularly valuable when iterating on features that require
the workload to be deployed and running to validate.

Live update is ideally situated for running from within one of our supported IDE extensions, but it
can also be utilized independently as shown in the following Spring Boot application example:

#### Spring Boot application example

Prerequisites: [Tilt](https://docs.tilt.dev/install.html) must be installed on the client.

1. Clone the repository by running:

   ```console
   git clone https://github.com/vmware-tanzu/application-accelerator-samples
   ```

2. Change into the `tanzu-java-web-app` directory.
3. In `Tiltfile`, first, change the `SOURCE_IMAGE` variable to use your registry and project.
4. At the very end of the file add:

   ```console
   allow_k8s_contexts('your-cluster-name')
   ```

5. Inside the directory, run:

   ```console
   tanzu apps workload apply tanzu-java-web-app --live-update --local-path . -s
   gcr.io/PROJECT/tanzu-java-web-app-live-update -y
   ```

   Expected output:

   ```console
   The files and directories listed in the .tanzuignore file are being excluded from the uploaded source code.
   Publishing source in "." to "gcr.io/PROJECT/tanzu-java-web-app-live-update"...
   📥 Published source

   🔎 Create workload:
       1 + |---
       2 + |apiVersion: carto.run/v1alpha1
       3 + |kind: Workload
       4 + |metadata:
       5 + |  name: tanzu-java-web-app
       6 + |  namespace: default
       7 + |spec:
       8 + |  params:
       9 + |  - name: live-update
      10 + |    value: "true"
      11 + |  source:
      12 + |    image: gcr.io/PROJECT/tanzu-java-web-app-live-update:latest@sha256:3c9fd738492a23ac532a709301fcf0c9aa2a8761b2b9347bdbab52ce9404264b
   👍 Created workload "tanzu-java-web-app"

   To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
   To get status: "tanzu apps workload get tanzu-java-web-app"

   ```

6. Run Tilt to deploy the workload.

    ```console
    tilt up

    Tilt started on http://localhost:10350/
    v0.23.6, built 2022-01-14

    (space) to open the browser
    (s) to stream logs (--stream=true)
    (t) to open legacy terminal mode (--legacy=true)
    (ctrl-c) to exit
    Tilt started on http://localhost:10350/
    v0.23.6, built 2022-01-14

    Initial Build • (Tiltfile)
    Loading Tiltfile at: /path/to/repo/tanzu-java-web-app/Tiltfile
    Successfully loaded Tiltfile (1.500809ms)
    tanzu-java-w… │
    tanzu-java-w… │ Initial Build • tanzu-java-web-app
    tanzu-java-w… │ WARNING: Live Update failed with unexpected error:
    tanzu-java-w… │   Cannot extract live updates on this build graph structure
    tanzu-java-w… │ Falling back to a full image build + deploy
    tanzu-java-w… │ STEP 1/1 — Deploying
    tanzu-java-w… │      Objects applied to cluster:
    tanzu-java-w… │        → tanzu-java-web-app:workload
    tanzu-java-w… │
    tanzu-java-w… │      Step 1 - 8.87s (Deploying)
    tanzu-java-w… │      DONE IN: 8.87s
    tanzu-java-w… │
    tanzu-java-w… │
    tanzu-java-w… │ Tracking new pod rollout (tanzu-java-web-app-build-1-build-pod):
    tanzu-java-w… │      ┊ Scheduled       - (…) Pending
    tanzu-java-w… │      ┊ Initialized     - (…) Pending
    tanzu-java-w… │      ┊ Ready           - (…) Pending
    ...
    ```

### <a id='workload-local-subpath'></a> Subpath

Same as specified for [Git workloads](create-update-workload.hbs.md#subpath), for local source
workloads a subpath can be specified, which would point to a specific subfolder within the root folder.

```bash
# After cloning repo in https://github.com/vmware-tanzu/application-accelerator-samples and install Local Source Proxy 

cd application-accelerator-samples
tanzu apps workload apply tanzu-java-web-app --local-path . --sub-path tanzu-java-web-app
Publishing source in "." to "local-source-proxy.tap-local-source-system.svc.cluster.local/source:default-tanzu-java-web-app"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  annotations:
      6 + |    local-source-proxy.apps.tanzu.vmware.com: gcr.io/tanzu-framework-playground/source:default-tanzu-java-web-app@sha256:e6ee774bc427273afb6dcf6388aca8edd83b83c72e4de00bf0cf8dfce72f8446
      7 + |  labels:
      8 + |    apps.tanzu.vmware.com/workload-type: web
      9 + |  name: tanzu-java-web-app
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    image: gcr.io/tanzu-framework-playground/source:default-tanzu-java-web-app@sha256:e6ee774bc427273afb6dcf6388aca8edd83b83c72e4de00bf0cf8dfce72f8446
     14 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"
```

## <a id='create-workload-image'></a> Create workload from Pre-built image

Create a workload from an existing registry image by providing the reference to that image through
the `--image` flag. The [supply chain](../../../scc/about.hbs.md) references the provided registry
image when the workload is deployed.

For example:

```bash
tanzu apps workload create petclinic-image --image springcommunity/spring-framework-petclinic
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: petclinic-image
      8 + |  namespace: default
      9 + |spec:
     10 + |  image: springcommunity/spring-framework-petclinic
❓ Do you want to create this workload? [yN]: 
```

Check the requirements to use a pre-built image in supply chain
[pre-built images requirements](../../../scc/pre-built-image.hbs.md#requirements-for-prebuilt-images)
and how to [configure the workload](../../../scc/pre-built-image.hbs.md#configure-your-workload-to-use-a-prebuilt-image)
in order to use it.

### <a id="create-workload-maven"></a> Create a workload from Maven repository artifact

Create a workload from a Maven repository
artifact ([Source-Controller](../../../source-controller/about.hbs.md)) by setting some
specific properties as YAML parameters in the workload when using the [supply chain](../../../scc/about.hbs.md).

The Maven repository URL is set when the supply chain is created.

- Param name: `maven`
- Param value:
  - YAML:

    ```yaml
    artifactId: ...
    type: ... # default jar if not provided
    version: ...
    groupId: ...
    ```

  - JSON:

    ```json
    {
        "artifactId": ...,
        "type": ..., // default jar if not provided
        "version": ...,
        "groupId": ...
    }
    ```

For example, to create a workload from a Maven artifact, run:

```bash
# YAML
tanzu apps workload create petclinic-image --param-yaml maven=$"artifactId:hello-world\ntype: jar\nversion: 0.0.1\ngroupId: carto.run"

# JSON
tanzu apps workload create petclinic-image --param-yaml maven="{"artifactId":"hello-world", "type": "jar", "version": "0.0.1", "groupId": "carto.run"}"
```

To configure the credentials that the MavenArtifact expects for authentication,
check the [Maven Repository Secret](../../../scc/building-from-source.hbs.md#maven-repository-secret)
section in supply chain guide.

### <a id="create-workload-dockerfile"></a> Create a workload from Dockerfile

For any source-based supply chains, when you specify the new dockerfile parameter in a workload,
the builds switch from using Kpack to using Kaniko. Source-based supply chains are supply chains that
don’t take a pre-built image. Kaniko is an open-source tool for building container images from a 
Dockerfile without running Docker inside a container. For more information, refer to the 
Supply chain documentation on [Dockerfile-based builds](../../../scc/dockerfile-based-builds.hbs.md).
