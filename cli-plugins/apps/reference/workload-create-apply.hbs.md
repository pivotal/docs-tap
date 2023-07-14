# tanzu apps workload apply

Use the `tanzu apps workload apply` command to create and update workloads that are deployed in a
cluster through a supply chain.

The `tanzu apps workload apply` and `tanzu apps workload create` commands have the same behavior and
flags with the following exceptions:

- The `tanzu apps workload create` command fails if a workload with the same name preexists on the
  target cluster.
- The `--update-strategy` flag is only supported by `tanzu apps workload apply` because `tanzu apps workload create` doesn't support updating existing workloads.

## Default view

In the output of the `tanzu apps workload apply` command, the specification for the workload is
shown in YAML file format.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web
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
     11 + |    git:
     12 + |      ref:
     13 + |        tag: tap-{{ vars.tap_version }}
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

```

In the first section, the definition of workload is displayed. It's followed by a dialog box asking
`whether the workload should be created or updated`. In the last section, if a workload is created or
updated, some hints are displayed about the next steps.

## <a id='workload-apply-flags'></a> Workload Apply flags

### <a id="apply-annotation"></a> `--annotation`

Sets the annotations to be applied to the workload. To specify more than one annotation set the flag
multiple times. These annotations are passed as parameters to be processed in the supply chain.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --annotation tag=tap-{{ vars.tap_version }} --annotation name="Tanzu Java Web"
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
   10 + |  params:
   11 + |  - name: annotations
   12 + |    value:
   13 + |      name: Tanzu Java Web
   14 + |      tag: tap-{{ vars.tap_version }}
   15 + |  source:
   16 + |    git:
   17 + |      ref:
   18 + |        tag: tap-{{ vars.tap_version }}
   19 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   20 + |    subPath: tanzu-java-web-app
```

To delete an annotation, use `-` after its name.

Example

```console
tanzu apps workload apply tanzu-java-web-app --annotation tag-
🔎 Update workload:
...
10, 10   |  params:
11, 11   |  - name: annotations
12, 12   |    value:
13, 13   |      name: Tanzu Java Web
14     - |      tag: tap-{{ vars.tap_version }}
15, 14   |  source:
16, 15   |    git:
17, 16   |      ref:
18, 17   |        tag: tap-{{ vars.tap_version }}
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-app"></a> `--app` / `-a`

This is the application the workload is part of. This is part of the workload metadata section.

Example

```console
tanzu apps workload apply tanzu-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --app tanzu-java-web-app

   Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    app.kubernetes.io/part-of: tanzu-java-web-app
    7 + |    apps.tanzu.vmware.com/workload-type: web
    8 + |  name: tanzu-app
    9 + |  namespace: default
   10 + |spec:
   11 + |  source:
   12 + |    git:
   13 + |      ref:
   14 + |        tag: tap-{{ vars.tap_version }}
   15 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   16 + |    subPath: tanzu-java-web-app
  Do you want to create this workload? [yN]:
  Created workload "tanzu-app"

To see logs:   "tanzu apps workload tail tanzu-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-app"
```

### <a id="apply-build-env"></a> `--build-env`

Sets environment variables to use in the build phase by the build resources in the supply
chain.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --build-env JAVA_VERSION=1.8
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
     10 + |  build:
     11 + |    env:
     12 + |    - name: JAVA_VERSION
     13 + |      value: "1.8"
     14 + |  source:
     15 + |    git:
     16 + |      ref:
     17 + |        tag: tap-{{ vars.tap_version }}
     18 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     19 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To delete a build environment variable, use `-` after its name.

Example

```console
tanzu apps workload apply tanzu-java-web-app --build-env JAVA_VERSION-
🔎 Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: tanzu-java-web-app
   8,  8   |  namespace: default
   9,  9   |spec:
  10     - |  build:
  11     - |    env:
  12     - |    - name: JAVA_VERSION
  13     - |      value: "1.8"
  14, 10   |  source:
  15, 11   |    git:
  16, 12   |      ref:
  17, 13   |        tag: tap-{{ vars.tap_version }}
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-debug"></a> `--debug`

Sets the parameter variable debug to true in the workload.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --debug
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
     10 + |  params:
     11 + |  - name: debug
     12 + |    value: "true"
     13 + |  source:
     14 + |    git:
     15 + |      ref:
     16 + |        branch: main
     17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-dry-run"></a> `--dry-run`

Prepares all the steps to submit the workload to the cluster and stops before sending it, showing
an output of the final structure of the workload.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --build-env JAVA_VERSION=1.8 --param-yaml server=$'port: 8080\nmanagement-port: 8181' --dry-run
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: null
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: tanzu-java-web-app
  namespace: default
spec:
  build:
    env:
    - name: JAVA_VERSION
      value: "1.8"
  params:
  - name: server
    value:
      management-port: 8181
      port: 8080
  source:
    git:
      ref:
        tag: tap-{{ vars.tap_version }}
      url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: tanzu-java-web-app
status:
  supplyChainRef: {}
```

### <a id="apply-env"></a> `--env` / `-e`

 Sets the environment variables to the workload so the supply chain resources can use it to deploy
 the workload application.

 Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --env NAME="Tanzu Java App"
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
     10 + |  env:
     11 + |  - name: NAME
     12 + |    value: Tanzu Java App
     13 + |  source:
     14 + |    git:
     15 + |      ref:
     16 + |        tag: tap-{{ vars.tap_version }}
     17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To unset an environment variable, use `-` after its name.

```console
tanzu apps workload apply tanzu-java-web-app --env NAME-
🔎 Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: tanzu-java-web-app
   8,  8   |  namespace: default
   9,  9   |spec:
  10     - |  env:
  11     - |  - name: NAME
  12     - |    value: Tanzu Java App
  13, 10   |  source:
  14, 11   |    git:
  15, 12   |      ref:
  16, 13   |        tag: tap-{{ vars.tap_version }}
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-file"></a> `--file`, `-f`

Sets the workload specification file to create the workload. This comes from any other workload
specification passed by flags to the command set or overrides what is in the file. Another way to
use this flag is by using `-` in the command to receive workload definition through stdin.

For an example, see [Create a workload from a `workload.yaml` file or from a URL](../tutorials/create-update-workload.hbs.md#create-yaml-url).

```console
tanzu apps workload apply tanzu-java-web-app -f java-app-workload.yaml --param-yaml server=$'port: 9090\nmanagement-port: 9190'
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
      10 + |  build:
      11 + |    env:
      12 + |    - name: JAVA_VERSION
      13 + |      value: "1.8"
      14 + |  params:
      15 + |  - name: server
      16 + |    value:
      17 + |      management-port: 9190
      18 + |      port: 9090
      19 + |  source:
      20 + |    git:
      21 + |      ref:
      22 + |        tag: tap-{{ vars.tap_version }}
      23 + |      url: url: https://github.com/vmware-tanzu/application-accelerator-samples
      24 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-git-repo"></a> `--git-repo`

The Git repository from which the workload is created. Specify one or more of the following:`--git-tag`, `--git-commit`, or `--git-branch`. If you set this flag to an empty string, the whole
`spec.source.git` section is removed from workload definition.

For Git source, if all the flags are specified,`--git-tag`, `--git-commit`, and`--git-branch`, the
revision to which the workload checkouts depends on the source controller.

### <a id="apply-git-branch"></a> `--git-branch`

The branch in a Git repository from where the workload is created. You can specify `--git-commit` and
`--git-tag` with this flag.
To unset, define as an empty string when applying a workload:`--git-branch ""`.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web
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
   11 + |    git:
   12 + |      ref:
   13 + |        branch: main
   14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-git-tag"></a> `--git-tag`

The tag in a Git repository from which the workload is created.
To unset, define as an empty string when applying a workload: `--git-tag ""`.

### <a id="apply-git-commit"></a> `--git-commit`

Commit in Git repository from where the workload is resolved. Either `--git-branch` or `--git-tag`
can be specified with it too.
To unset, define as an empty string when applying a workload:`--git-commit ""`.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-commit 1c4cf82e499f7e46da182922d4097908d4817320 --type web
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
   11 + |    git:
   12 + |      ref:
   13 + |        commit: 1c4cf82e499f7e46da182922d4097908d4817320
   14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-image"></a> `--image` / `-i`

Sets the OSI image to be used as the workload application source instead of a Git repository

 Example

```console
tanzu apps workload apply tanzu-java-web-app --image private.repo.domain.com/tanzu-java-web-app --type web
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
     10 + |  image: private.repo.domain.com/tanzu-java-web-app
❓ Do you want to create this workload? [yN]: 
```

### <a id="apply-label"></a> `--label` / `-l`

Sets the label to be applied to the workload. To specify more than one label, set the flag multiple
times.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --label stage=production
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    stage: production
      8 + |  name: tanzu-java-web-app
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     16 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To unset labels, use `-` after their name.

Example

```console
tanzu apps workload apply tanzu-java-web-app --label stage-
🔎 Update workload:
...
   3,  3   |kind: Workload
   4,  4   |metadata:
   5,  5   |  labels:
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7     - |    stage: production
   8,  7   |  name: tanzu-java-web-app
   9,  8   |  namespace: default
  10,  9   |spec:
  11, 10   |  source:
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-limit-cpu"></a> `--limit-cpu`

The maximum CPU the workload pods are allowed to use.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --limit-cpu .2
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
   10 + |  resources:
   11 + |    limits:
   12 + |      cpu: 200m
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-limit-memory"></a> `--limit-memory`

The maximum memory the workload pods are allowed to use.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --limit-memory 200Mi
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
   10 + |  resources:
   11 + |    limits:
   12 + |      memory: 200Mi
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-live-update"></a> `--live-update`

Enable this to deploy the workload once, save changes to the code, and see those changes reflected
in the workload running on the cluster.

Example

An example with a Spring Boot application:

1. Clone the repository by running:

   ```console
   git clone https://github.com/vmware-tanzu/application-accelerator-samples
   ```

1. Change into the `tanzu-java-web-app` directory.
1. In `Tiltfile`, first change the `SOURCE_IMAGE` variable to use your registry and project.
1. At the very end of the file add:

   ```console
   allow_k8s_contexts('your-cluster-name')
   ```

1. Inside the directory, run:

   ```console
   tanzu apps workload apply tanzu-java-web-app --live-update --local-path . -s
   gcr.io/my-project/tanzu-java-web-app-live-update -y
   ```

   Expected output:

   ```console
   The files and directories listed in the .tanzuignore file are being excluded from the uploaded source code.
   Publishing source in "." to "gcr.io/my-project/tanzu-java-web-app-live-update"...
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
      12 + |    image: gcr.io/my-project/tanzu-java-web-app-live-update:latest@sha256:3c9fd738492a23ac532a709301fcf0c9aa2a8761b2b9347bdbab52ce9404264b

   👍 Created workload "tanzu-java-web-app"

   To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
   To get status: "tanzu apps workload get tanzu-java-web-app"

   ```

1. Run Tilt to deploy the workload.

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

### <a id="apply-local-path"></a> `--local-path`

Sets the path to a source in the local machine from where the workload creates an image to use as an
application source. The local path can be a directory, a JAR, a ZIP, or a WAR file. Java/Spring Boot
compiled binaries are also supported. This flag must be used with `--source-image` flag.

If Java/Spring compiled binary is passed instead of source code, the command takes
less time to apply the workload because the build pack skips the compiling steps and start uploading
the image.

When working with local source code, you can exclude files from the source code to be uploaded within
the image by creating a file `.tanzuignore` at the root of the source code.
The `.tanzuignore` file contains a list of file paths to exclude from the image including the file itself.
The directories must not end with the system path separator (`/` or `\`). If the file contains directories
that are not in the source code, they are ignored. Lines starting with a `#` hashtag are also ignored.

### <a id="apply-maven-artifact"></a> `--maven-artifact`

This artifact is an output of a Maven project build. This flag must be used with `--maven-version`
and `--maven-group`.

Example

```console
tanzu apps workload apply petc-mvn --maven-artifact petc --maven-version 2.6.1 --maven-group demo.com
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  name: petc-mvn
      6 + |  namespace: default
      7 + |spec:
      8 + |  params:
      9 + |  - name: maven
     10 + |    value:
     11 + |      artifactId: petc
     12 + |      groupId: demo.com
     13 + |      version: 2.6.1
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-maven-group"></a> `--maven-group`

This group identifies the project across all other Maven projects.

### <a id="apply-maven-type"></a> `--maven-type`

This specifies the type of artifact that the Maven project produces. This flag is optional
and is set by default as `jar` by the supply chain.

### <a id="apply-maven-version"></a> `--maven-version`

Definition of the current version of the Maven project.

### <a id="apply-source-image"></a> `--source-image`, `-s`

Registry path where the local source code is uploaded as an image.

Example

```console
tanzu apps workload apply spring-pet-clinic --local-path /home/user/workspace/spring-pet-clinic --source-image gcr.io/spring-community/spring-pet-clinic --type web
❓ Publish source in "/home/user/workspace/spring-pet-clinic" to "gcr.io/spring-community/spring-pet-clinic"? It might be visible to others who can pull images from that repository Yes
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "/home/user/workspace/spring-pet-clinic" to "gcr.io/spring-community/spring-pet-clinic"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    image:gcr.io/spring-community/spring-pet-clinic:latest@sha256:5feb0d9daf3f639755d8683ca7b647027cfddc7012e80c61dcdac27f0d7856a7
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-namespace"></a> `--namespace`, `-n`

Specifies the namespace in which the workload is created or updated in.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --namespace my-namespace
🔎 Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: tanzu-java-web-app
    8 + |  namespace: my-namespace
    9 + |spec:
   10 + |  source:
   11 + |    git:
   12 + |      ref:
   13 + |        branch: main
   14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
  15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-output"></a> `--output`, `-o`

Retrieves a workload after it's applied in the specified format; `yaml`, `yml`, `json`. If used with
the `--yes` flag, all prompts are skipped and it only returns the
workload definition. Use with the `--wait` or `--tail` flag to return the workload with its status.

Example

```console
tanzu apps workload apply rmq-sample-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1" --type web --output yaml
🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: rmq-sample-app
      8 + |  namespace: default
      9 + |spec:
     10 + |  serviceClaims:
     11 + |  - name: rmq
     12 + |    ref:
     13 + |      apiVersion: rabbitmq.com/v1beta1
     14 + |      kind: RabbitmqCluster
     15 + |      name: example-rabbitmq-cluster-1
     16 + |  source:
     17 + |    git:
     18 + |      ref:
     19 + |        branch: main
     20 + |      url: https://github.com/jhvhs/rabbitmq-sample
❓ Do you want to create this workload? [yN]: y
👍 Created workload "rmq-sample-app"

To see logs:   "tanzu apps workload tail rmq-sample-app --timestamp --since 1h"
To get status: "tanzu apps workload get rmq-sample-app"

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: "2023-04-04T15:18:13Z"
  generation: 1
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: rmq-sample-app
  namespace: default
  resourceVersion: "184169566"
  uid: 6588d398-b803-47e3-b31a-23d9a1a633a9
spec:
  serviceClaims:
  - name: rmq
    ref:
      apiVersion: rabbitmq.com/v1beta1
      kind: RabbitmqCluster
      name: example-rabbitmq-cluster-1
  source:
    git:
      ref:
        branch: main
      url: https://github.com/jhvhs/rabbitmq-sample
status:
  supplyChainRef: {}
```

### <a id="apply-param"></a> `--param` / `-p`

Additional parameters sent to the supply chain, the value is sent as a string. For complex YAML
and JSON objects use `--param-yaml`.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --param port=9090 --param management-port=9190
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
     10 + |  params:
     11 + |  - name: port
     12 + |    value: "9090"
     13 + |  - name: management-port
     14 + |    value: "9190"
     15 + |  source:
     16 + |    git:
     17 + |      ref:
     18 + |        branch: main
     19 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     20 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To unset parameters, use `-` after their name.

Example

```console
tanzu apps workload apply tanzu-java-web-app --param port-
🔎 Update workload:
...
   7,  7   |  name: tanzu-java-web-app
   8,  8   |  namespace: default
   9,  9   |spec:
  10, 10   |  params:
  11     - |  - name: port
  12     - |    value: "9090"
  13, 11   |  - name: management-port
  14, 12   |    value: "9190"
  15, 13   |  source:
  16, 14   |    git:
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-param-yaml"></a> `--param-yaml`

Additional parameters to be sent to the supply chain, the value is sent as a complex object.

 Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --param-yaml server=$'port: 9090\nmanagement-port: 9190'
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
     10 + |  params:
     11 + |  - name: server
     12 + |    value:
     13 + |      management-port: 9190
     14 + |      port: 9090
     15 + |  source:
     16 + |    git:
     17 + |      ref:
     18 + |        branch: main
     19 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     20 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To unset parameters, use `-` after their name.

Example

```console
tanzu apps workload apply tanzu-java-web-app --param-yaml server-
🔎 Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: tanzu-java-web-app
   8,  8   |  namespace: default
   9,  9   |spec:
  10     - |  params:
  11     - |  - name: server
  12     - |    value:
  13     - |      management-port: 9190
  14     - |      port: 9090
  15, 10   |  source:
  16, 11   |    git:
  17, 12   |      ref:
  18, 13   |        branch: main
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-registry-ca-cert"></a> `--registry-ca-cert`

Refers to the path of the self-signed certificate needed for the custom/private registry.
This is also populated with a default value through environment variables. If the environment
variable `TANZU_APPS_REGISTRY_CA_CERT` is set, it's not necessary to use it in the command.

See [Custom registry credentials](../getting-started/configuration.hbs.md#registry-flags-and-environment-variables)
for the supported environment variables.

Example

```console
tanzu apps workload apply my-workload --local-path . -s registry.url.nip.io/my-package/my-image --type web --registry-ca-cert path/to/cacert/mycert.nip.io.crt --registry-username my-username --registry-password my-password
❓ Publish source in "." to "registry.url.nip.io/my-package/my-image"? It might be visible to others who can pull images from that repository Yes
Publishing source in "." to "registry.url.nip.io/my-package/my-image"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: my-workload
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    image: registry.url.nip.io/my-package/my-image:latest@sha256:caeb7e3a0e3ae0659f74d01095b6fdfe0d3c4a12856a15ac67ad6cd3b9e43648
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-registry-password"></a> `--registry-password`

If credentials are needed, the user name and password values are set through the `--registry-password`
flag. The value of this flag can also be specified through `TANZU_APPS_REGISTRY_PASSWORD`.

### <a id="apply-registry-token"></a> `--registry-token`

Used for token authentication in the private registry. This flag is set as
`TANZU_APPS_REGISTRY_TOKEN` environment variable.

### <a id="apply-registry-username"></a> `--registry-username`

Often used with `--registry-password` to set private registry credentials. Can be provided using
`TANZU_APPS_REGISTRY_USERNAME` environment variable to avoid setting it every time in the command.

### <a id="apply-request-cpu"></a> `--request-cpu`

Refers to the minimum CPU the workload pods request to use.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --request-cpu .3
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
   10 + |  resources:
   11 + |    requests:
   12 + |      cpu: 300m
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-request-memory"></a> `--request-memory`

Refers to the minimum memory the workload pods are requesting to use.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --request-memory 300Mi
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
    10 + |  resources:
    11 + |    requests:
    12 + |      memory: 300Mi
    13 + |  source:
    14 + |    git:
    15 + |      ref:
    16 + |        branch: main
    17 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
    18 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

### <a id="apply-service-account"></a> `--service-account`

Refers to the service account to associate with the workload. A service account provides an
identity for a workload object.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --service-account petc-serviceaccount
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
     10 + |  serviceAccountName: petc-serviceaccount
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     16 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]:
```

To unset a service account, pass empty string.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --service-account ""
🔎 Update workload:
...
  6,  6   |    apps.tanzu.vmware.com/workload-type: web
  7,  7   |  name: tanzu-java-web-app
  8,  8   |  namespace: default
  9,  9   |spec:
 10     - |  serviceAccountName: petc-serviceaccount
 11, 10   |  source:
 12, 11   |    git:
 13, 12   |      ref:
 14, 13   |        branch: main
...
❓ Really update the workload "tanzu-java-web-app"? [yN]:
```

### <a id="apply-service-ref"></a> `--service-ref`

Binds a service to a workload to provide the information from a service resource to an application.

For more information, see [Tanzu Application Platform documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-getting-started-consume-services.html#stk-bind).

Example

```console
tanzu apps workload apply rmq-sample-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1"
🔎 Create workload:
     1 + |---
     2 + |apiVersion: carto.run/v1alpha1
     3 + |kind: Workload
     4 + |metadata:
     5 + |  name: rmq-sample-app
     6 + |  namespace: default
     7 + |spec:
     8 + |  serviceClaims:
     9 + |  - name: rmq
    10 + |    ref:
    11 + |      apiVersion: rabbitmq.com/v1beta1
    12 + |      kind: RabbitmqCluster
    13 + |      name: example-rabbitmq-cluster-1
    14 + |  source:
    15 + |    git:
    16 + |      ref:
    17 + |        branch: main
    18 + |      url: https://github.com/jhvhs/rabbitmq-sample
❓ Do you want to create this workload? [yN]:
```

To delete service binding, use the service name followed by `-`.

Example

```console
tanzu apps workload apply rmq-sample-app --service-ref rmq-
🔎 Update workload:
...
   4,  4   |metadata:
   5,  5   |  name: rmq-sample-app
   6,  6   |  namespace: default
   7,  7   |spec:
   8     - |  serviceClaims:
   9     - |  - name: rmq
  10     - |    ref:
  11     - |      apiVersion: rabbitmq.com/v1beta1
  12     - |      kind: RabbitmqCluster
  13     - |      name: example-rabbitmq-cluster-1
  14,  8   |  source:
  15,  9   |    git:
  16, 10   |      ref:
  17, 11   |        branch: main
...
❓ Really update the workload "rmq-sample-app"? [yN]:
```

### <a id="apply-subpath"></a> `--sub-path`

Defines which path is used as the root path to create and update the workload.

Example

- Git repository

    ```console
    tanzu apps workload apply subpathtester --git-repo https://github.com/path-to-repo/my-repo --git-branch main --type web --sub-path my-subpath
    🔎 Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  labels:
        6 + |    apps.tanzu.vmware.com/workload-type: web
        7 + |  name: subpathtester
        8 + |  namespace: default
        9 + |spec:
       10 + |  source:
       11 + |    git:
       12 + |      ref:
       13 + |        branch: main
       14 + |      url: https://github.com/path-to-repo/my-repo
       15 + |    subPath: my-subpath
    ❓ Do you want to create this workload? [yN]:
    ```

- Local path
  - In the directory of the project you want to create the workload from

      ```console
      tanzu apps workload apply my-workload --local-path . -s gcr.io/my-registry/my-workload-image --sub-path subpath_folder
      ❓ Publish source in "." to "gcr.io/my-registry/my-workload-image"? It might be visible to others who can pull images from that repository Yes
      Publishing source in "." to "gcr.io/my-registry/my-workload-image"...
      📥 Published source

      🔎 Create workload:
            1 + |---
            2 + |apiVersion: carto.run/v1alpha1
            3 + |kind: Workload
            4 + |metadata:
            5 + |  name: myworkload
            6 + |  namespace: default
            7 + |spec:
            8 + |  source:
            9 + |    image: gcr.io/my-registry/my-workload-image:latest@sha256:f28c5fedd0e902800e6df9605ce5e20a8e835df9e87b1a0aa256666ea179fc3f
           10 + |    subPath: subpath_folder
      ❓ Do you want to create this workload? [yN]:

      ```

### <a id="apply-tail"></a> `--tail`

Prints the logs of the workload creation in every step.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --tail
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

Waiting for workload "tanzu-java-web-app" to become ready...
+ tanzu-java-web-app-build-1-build-pod › prepare
tanzu-java-web-app-build-1-build-pod[prepare] Build reason(s): CONFIG
tanzu-java-web-app-build-1-build-pod[prepare] CONFIG:
tanzu-java-web-app-build-1-build-pod[prepare]   + env:
tanzu-java-web-app-build-1-build-pod[prepare]   + - name: BP_OCI_SOURCE
tanzu-java-web-app-build-1-build-pod[prepare]   +   value: main/d381fb658cb435a04e2271ca85bd3e8627a5e7e4
tanzu-java-web-app-build-1-build-pod[prepare]   resources: {}
tanzu-java-web-app-build-1-build-pod[prepare]   - source: {}
tanzu-java-web-app-build-1-build-pod[prepare]   + source:
tanzu-java-web-app-build-1-build-pod[prepare]   +   blob:
tanzu-java-web-app-build-1-build-pod[prepare]   +     url: http://source-controller.flux-system.svc.cluster.local./gitrepository/default/tanzu-java-web-app/1c4cf82e499f7e46da182922d4097908d4817320.tar.gz
...
...
...
```

### <a id="apply-tail-timestamp"></a> `--tail-timestamp`

Prints the logs of the workload creation in every step adding the time in which the log is occurring.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web --tail-timestamp
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: tanzu-java-web-app
❓ Do you want to create this workload? [yN]: y
👍 Created workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

Waiting for workload "tanzu-java-web-app" to become ready...
+ tanzu-java-web-app-build-1-build-pod › prepare
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.348418803-05:00 Build reason(s): CONFIG
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364719405-05:00 CONFIG:
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364761781-05:00   + env:
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364771861-05:00   + - name: BP_OCI_SOURCE
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364781718-05:00   +   value: main/d381fb658cb435a04e2271ca85bd3e8627a5e7e4
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364788374-05:00   resources: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.364795451-05:00   - source: {}
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.365344965-05:00   + source:
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.365364101-05:00   +   blob:
tanzu-java-web-app-build-1-build-pod[prepare] 2022-06-15T11:28:01.365372427-05:00   +     url: http://source-controller.flux-system.svc.cluster.local./gitrepository/default/tanzu-java-web-app/1c4cf82e499f7e46da182922d4097908d4817320.tar.gz
...
...
...
```

### <a id="apply-type"></a> `--type` / `-t`

Sets the type of workload by adding the label `apps.tanzu.vmware.com/workload-type`, which is used
as a matcher by supply chains. Use the `TANZU_APPS_TYPE` environment variable to have a default
value for this flag.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-branch main --type web
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
     15 + |    subPath: tanzu-java-web-app
```

### <a id="update-strategy-type"></a> `--update-strategy`

Specifies whether the update from file should replace or merge the current workload. The default is
merge.

>**Note** This flag is only applicable to the `tanzu apps workload apply` command. It is not
applicable to the `tanzu apps workload create` command.

Example

For example, there is a workload created from a file, which has in its `spec` the following:

```yaml
...
spec:
  resources:
    requests:
      memory: 1Gi
    limits:           # delete this line
      memory: 1Gi     # delete this line
      cpu: 500m       # delete this line
...
```

If the workload file is changed as specified in the comments, there are two ways to update the workload running in the cluster.

One, with `merge` update strategy.

```console
tanzu apps workload apply -f ./spring-petclinic.yaml # defaulting to merge

❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files will replace rather than merge existing configuration. The change will take place in the January 2024 TAP release (use "--update-strategy" to control strategy explicitly).

Workload is unchanged, skipping update
```

The other, with `replace` update strategy, which completely overwrites the workload in the cluster according to the new specifications in the file.

```console
tanzu apps workload apply -f ./spring-petclinic.yaml --update-strategy replace

❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files will replace rather than merge existing configuration. The change will take place in the January 2024 TAP release (use "--update-strategy" to control strategy explicitly).

🔎 Update workload:
...
  8,  8   |  name: spring-petclinic
  9,  9   |  namespace: default
 10, 10   |spec:
 11, 11   |  resources:
 12     - |    limits:
 13     - |      cpu: 500m
 14     - |      memory: 1Gi
 15, 12   |    requests:
 16, 13   |      memory: 1Gi
 17, 14   |  source:
 18, 15   |    git:
...
❓ Really update the workload "spring-petclinic"? [yN]:
```

### <a id="apply-wait"></a> `--wait`

Holds the command until the workload is ready.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }} --type web --wait
🔎 Update workload:
...
10, 10   |  source:
11, 11   |    git:
12, 12   |      ref:
13, 13   |        branch: main
    14 + |        tag: tap-{{ vars.tap_version }}
14, 15   |      url: https://github.com/vmware-tanzu/application-accelerator-samples
15, 16   |    subPath: tanzu-java-web-app
❓ Really update the workload "tanzu-java-web-app"? Yes
👍 Updated workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

Waiting for workload "tanzu-java-web-app" to become ready...
Workload "tanzu-java-web-app" is ready
```

### <a id="apply-wait-timeout"></a> `--wait-timeout`

Sets a timeout to wait for the workload to become ready.

Example

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-{{ vars.tap_version }}-take1 --type web --wait --wait-timeout 1m
🔎 Update workload:
...
10, 10   |  source:
11, 11   |    git:
12, 12   |      ref:
13, 13   |        branch: main
14     - |        tag: tap-{{ vars.tap_version }}
    14 + |        tag: tap-{{ vars.tap_version }}-take1
15, 15   |      url: https://github.com/vmware-tanzu/application-accelerator-samples
16, 16   |    subPath: tanzu-java-web-app
❓ Really update the workload "tanzu-java-web-app"? Yes
👍 Updated workload "tanzu-java-web-app"

To see logs:   "tanzu apps workload tail tanzu-java-web-app --timestamp --since 1h"
To get status: "tanzu apps workload get tanzu-java-web-app"

Waiting for workload "tanzu-java-web-app" to become ready...
Workload "tanzu-java-web-app" is ready
```

### <a id="apply-yes"></a> `--yes`, `-y`

Assumes `--yes` on all the survey prompts.

Example

```console
tanzu apps workload apply spring-pet-clinic --local-path/home/user/workspace/spring-pet-clinic --source-image gcr.io/spring-community/spring-pet-clinic --type web -y
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "/Users/dalfonso/Documents/src/java/tanzu-java-web-app" to "gcr.io/spring-community/spring-pet-clinic"...
📥 Published source

🔎 Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  source:
     11 + |    image: gcr.io/spring-community/spring-pet-clinic:latest@sha256:5feb0d9daf3f639755d8683ca7b647027cfddc7012e80c61dcdac27f0d7856a7
👍 Created workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic --timestamp --since 1h"
To get status: "tanzu apps workload get spring-pet-clinic"

```
