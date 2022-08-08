# tanzu apps workload apply

`tanzu apps workload apply` is a command used to create/update workloads that will be deployed in a cluster through a supply chain.

## Default view

In the output of workload apply command, the specification for the workload is shown as if they were in a YAML file.

<details><summary>Example</summary>

```bash
tanzu apps workload apply pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web

Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: pet-clinic
    8 + |  namespace: default
    9 + |spec:
   10 + |  source:
   11 + |    git:
   12 + |      ref:
   13 + |        tag: tap-1.1
   14 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? Yes
Created workload "pet-clinic"

To see logs:   "tanzu apps workload tail pet-clinic"
To get status: "tanzu apps workload get pet-clinic"

```
</details>

In the first section, the definition of workload is displayed. It's followed by a dialog box asking whether the workload should be created or updated. In the last section, if workload is created or updated, a couple of hints/suggestions are displayed about the next set of commands that may be used for a follow up. Each flag used in this example is explained in detail in the following section.

## <a id='workload_apply_flags'></a> Workload Apply flags

### <a id="apply-annotation"></a> `--annotation`

Set the annotations to be applied to the workload, to specify more than one annotation set the flag multiple times. These annotations will be passed as parameters to be processed in the supply chain.
<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --annotation tag=tap-1.1 --annotation name="Spring pet clinic"
Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: spring-pet-clinic
    8 + |  namespace: default
    9 + |spec:
   10 + |  params:
   11 + |  - name: annotations
   12 + |    value:
   13 + |      name: Spring pet clinic
   14 + |      tag: tap-1.1
   15 + |  source:
   16 + |    git:
   17 + |      ref:
   18 + |        tag: tap-1.1
   19 + |      url: https://github.com/sample-accelerators/spring-petclinic
```
</details>

To delete an annotation, use `-` after it's name.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --annotation tag-
Update workload:
...
10, 10   |  params:
11, 11   |  - name: annotations
12, 12   |    value:
13, 13   |      name: Spring pet clinic
14     - |      tag: tap-1.1
15, 14   |  source:
16, 15   |    git:
17, 16   |      ref:
18, 17   |        tag: tap-1.1
...

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-app"></a> `--app`

The app of which the workload is part of. This will be part of the workload metadata section.

<details><summary>Example</summary>

```bash
tanzu apps workload apply pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --app spring-petclinic

Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    app.kubernetes.io/part-of: spring-petclinic
    7 + |    apps.tanzu.vmware.com/workload-type: web
    8 + |  name: pet-clinic
    9 + |  namespace: default
   10 + |spec:
   11 + |  source:
   12 + |    git:
   13 + |      ref:
   14 + |        tag: tap-1.1
   15 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? Yes
Created workload "pet-clinic"

To see logs:   "tanzu apps workload tail pet-clinic"
To get status: "tanzu apps workload get pet-clinic"

```
</details>

### <a id="apply-build-env"></a> `--build-env`

Sets environment variables to be used in the **build** phase by the build resources in the supply chain where some *build* specific behavior can be set or changed

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --build-env JAVA_VERSION=1.8
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  build:
     11 + |    env:
     12 + |    - name: JAVA_VERSION
     13 + |      value: "1.8"
     14 + |  source:
     15 + |    git:
     16 + |      ref:
     17 + |        tag: tap-1.1
     18 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload?
```
</details>

To delete a build environment variable, use `-` after its name.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --build-env JAVA_VERSION-
Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: spring-pet-clinic
   8,  8   |  namespace: default
   9,  9   |spec:
  10     - |  build:
  11     - |    env:
  12     - |    - name: JAVA_VERSION
  13     - |      value: "1.8"
  14, 10   |  source:
  15, 11   |    git:
  16, 12   |      ref:
  17, 13   |        tag: tap-1.1
...

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-debug"></a> `--debug`

Sets the param variable debug to true  in workload.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --debug
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  params:
     11 + |  - name: debug
     12 + |    value: "true"
     13 + |  source:
     14 + |    git:
     15 + |      ref:
     16 + |        branch: main
     17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-dry-run"></a> `--dry-run`

Prepares all the steps to submit the workload to the cluster and stops before sending it, showing as an output how the final structure of the workload.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --build-env JAVA_VERSION=1.8 --param-yaml server=$'port: 8080\nmanagement-port: 8181' --dry-run
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: null
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: spring-pet-clinic
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
        tag: tap-1.1
      url: https://github.com/sample-accelerators/spring-petclinic
status:
  supplyChainRef: {}
```
</details>

### <a id="apply-env"></a> `--env`

 Set the environment variables to the workload so the supply chain resources can used it to properly deploy the workload application

 <details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --env NAME="Spring Pet Clinic"
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  env:
     11 + |  - name: NAME
     12 + |    value: Spring Pet Clinic
     13 + |  source:
     14 + |    git:
     15 + |      ref:
     16 + |        tag: tap-1.1
     17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload?
```

To unset an environment variable, use `-` after its name.

```bash
tanzu apps workload apply spring-pet-clinic --env NAME-
Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: spring-pet-clinic
   8,  8   |  namespace: default
   9,  9   |spec:
  10     - |  env:
  11     - |  - name: NAME
  12     - |    value: Spring Pet Clinic
  13, 10   |  source:
  14, 11   |    git:
  15, 12   |      ref:
  16, 13   |        tag: tap-1.1
...

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-file"></a> `--file`, `-f`

Set a workload specification file to create the workload from, any other workload specification passed by flags to the command will set or override whatever is in the file. Another way to use this flag is using `-` in the command, to receive workload definition through standard input. Refer to [Working with Yaml Files](../../usage.md#a-idyaml-filesaworking-with-yaml-files) section to see an example.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic -f pet-clinic.yaml --param-yaml server=$'port: 9090\nmanagement-port: 9190'
Create workload:
       1 + |---
       2 + |apiVersion: carto.run/v1alpha1
       3 + |kind: Workload
       4 + |metadata:
       5 + |  labels:
       6 + |    apps.tanzu.vmware.com/workload-type: web
       7 + |  name: spring-pet-clinic
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
      22 + |        tag: tap-1.1
      23 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-git-repo"></a> `--git-repo`

Git repository from which the workload is going to be created. With this, `--git-tag`, `--git-commit` or `--git-branch` can be specified.

### <a id="apply-git-branch"></a> `--git-branch`

Branch in a Git repository from where the workload is going to be created. This may be specified along with a commit or a tag.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web
Create workload:
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
   11 + |    git:
   12 + |      ref:
   13 + |        branch: main
   14 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload?
```
</details>

### <a id="apply-git-tag"></a> `--git-tag`

Tag in a Git repository from which the workload is going to be created. Can be used with `--git-commit` or `--git-branch`

### <a id="apply-git-commit"></a> `--git-commit`

Commit in Git repo from where the workload is going to be resolved. Can be used with `--git-branch` or `git-tag`.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.2 --git-commit 207852f1e8ed239b6ec51a559c6e0f93a5cf54d1 --type web
Create workload:
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
   11 + |    git:
   12 + |      ref:
   13 + |        commit: 207852f1e8ed239b6ec51a559c6e0f93a5cf54d1
   14 + |        tag: tap-1.2
   15 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload?
```
</details>

### <a id="apply-image"></a> `--image`

Sets the OSI image to be used as the workload application source instead of a Git repository

 <details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --image private.repo.domain.com/spring-pet-clinic --type web
Create workload:
       1 + |---
       2 + |apiVersion: carto.run/v1alpha1
       3 + |kind: Workload
       4 + |metadata:
       5 + |  labels:
       6 + |    apps.tanzu.vmware.com/workload-type: web
       7 + |  name: spring-pet-clinic
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
      22 + |        tag: tap-1.1
      23 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-label"></a> `--label`

Set the label to be applied to the workload, to specify more than one label set the flag multiple times

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --label stage=production
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |    stage: production
      8 + |  name: spring-pet-clinic
      9 + |  namespace: default
     10 + |spec:
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

  To unset labels, use `-` after their name.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --label stage-
Update workload:
...
   3,  3   |kind: Workload
   4,  4   |metadata:
   5,  5   |  labels:
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7     - |    stage: production
   8,  7   |  name: spring-pet-clinic
   9,  8   |  namespace: default
  10,  9   |spec:
  11, 10   |  source:
...

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-limit-cpu"></a> `--limit-cpu`

 Refers to the maximum CPU the workload pods are allowed to use.

 <details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --limit-cpu .2
Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: spring-pet-clinic
    8 + |  namespace: default
    9 + |spec:
   10 + |  resources:
   11 + |    limits:
   12 + |      cpu: 200m
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-limit-memory"></a> `--limit-memory`

Refers to the maximum memory the workload pods are allowed to use.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --limit-memory 200Mi
Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: spring-pet-clinic
    8 + |  namespace: default
    9 + |spec:
   10 + |  resources:
   11 + |    limits:
   12 + |      memory: 200Mi
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-live-update"></a> `--live-update`

Enable to deploy a workload once, save changes to the code, and see those changes reflected within seconds in the workload running on the cluster.

<details><summary>Example</summary>

  - A usage example with a spring boot application.
    - Clone repo in https://github.com/sample-accelerators/tanzu-java-web-app
    - In `Tiltfile`, first change the `SOURCE_IMAGE` variable to use your registry and project. After that, at the very end of the file add
    ```bash
    allow_k8s_contexts('your-cluster-name')
    ```
    - Then, inside folder, run:
    ```bash
    tanzu apps workload apply tanzu-java-web-app --live-update --local-path . -s gcr.io/my-project/tanzu-java-web-app-live-update -y

    The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
    Publishing source in "." to "gcr.io/my-project/tanzu-java-web-app-live-update"...
    Published source
    Create workload:
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

    Created workload "tanzu-java-web-app"

    To see logs:   "tanzu apps workload tail tanzu-java-web-app"
    To get status: "tanzu apps workload get tanzu-java-web-app"

    ```
    - Run Tilt to deploy the workload.
    ```bash
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
    tanzu-java-w… │ 	Cannot extract live updates on this build graph structure
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
</details>

### <a id="apply-local-path"></a> `--local-path`

Sets the path to a source in the local machine from where the workload creates an image to use as an application source. The local path may be a directory, a JAR, a ZIP, or a WAR file. Java/Spring Boot compiled binaries are also supported. This flag must be used with `--source-image` flag.

>**Note:** If Java/Spring compiled binary is passed instead of source code, the command will take less time to apply the workload since buildpack will skip the compiling steps and will simply start uploading the image.

When working with local source code, you can exclude files from the source code to be uploaded within the image by creating a file `.tanzuignore` at the root of the source code.
The `.tanzuignore` file contains a list of file paths to exclude from the image including the file itself and the directories must not end with the system path separator (`/` or `\`). If the file contains directories that are not in the source code, they are ignored and lines starting with `#` character.

### <a id="apply-source-image"></a> `--source-image`, `-s`

Registry path where the local source code will be uploaded as an image.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --local-path /home/user/workspace/spring-pet-clinic --source-image gcr.io/spring-community/spring-pet-clinic --type web
? Publish source in "/home/user/workspace/spring-pet-clinic" to "gcr.io/spring-community/spring-pet-clinic"? It may be visible to others who can pull images from that repository Yes
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "/home/user/workspace/spring-pet-clinic" to "gcr.io/spring-community/spring-pet-clinic"...
Published source
Create workload:
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

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-namespace"></a> `--namespace`, `-n`

Specifies the namespace in which the workload is to be created or updated.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --namespace my-namespace
Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: spring-pet-clinic
    8 + |  namespace: my-namespace
    9 + |spec:
   10 + |  source:
   11 + |    git:
   12 + |      ref:
   13 + |        branch: main
   14 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-param"></a> `--param`

Additional parameters to be sent to the supply chain, the value is sent as a string, for complex YAML or JSON objects use `--param-yaml`

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --param port=9090 --param management-port=9190
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
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
     19 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

To unset parameters, use `-` after their name.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --param port-
Update workload:
...
   7,  7   |  name: spring-pet-clinic
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

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-param-yaml"></a> `--param-yaml`

Additional parameters to be sent to the supply chain, the value is sent as a complex object.

 <details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --param-yaml server=$'port: 9090\nmanagement-port: 9190'
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
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
     19 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

To unset parameters, use `-` after their name.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --param-yaml server-
Update workload:
...
   6,  6   |    apps.tanzu.vmware.com/workload-type: web
   7,  7   |  name: spring-pet-clinic
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

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-request-cpu"></a> `--request-cpu`

Refers to the minimum CPU the workload pods are requesting to use.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --request-cpu .3
Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: spring-pet-clinic
    8 + |  namespace: default
    9 + |spec:
   10 + |  resources:
   11 + |    requests:
   12 + |      cpu: 300m
   13 + |  source:
   14 + |    git:
   15 + |      ref:
   16 + |        branch: main
   17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-request-memory"></a> `--request-memory`

Refers to the minimum memory the workload pods are requesting to use.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --request-memory 300Mi
Create workload:
     1 + |---
     2 + |apiVersion: carto.run/v1alpha1
     3 + |kind: Workload
     4 + |metadata:
     5 + |  labels:
     6 + |    apps.tanzu.vmware.com/workload-type: web
     7 + |  name: spring-pet-clinic
     8 + |  namespace: default
     9 + |spec:
    10 + |  resources:
    11 + |    requests:
    12 + |      memory: 300Mi
    13 + |  source:
    14 + |    git:
    15 + |      ref:
    16 + |        branch: main
    17 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

### <a id="apply-service-account"></a> `--service-account`

Refers to the service account to be associated with the workload. A service account provides an identity for a workload object.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --service-account petc-serviceaccount
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    apps.tanzu.vmware.com/workload-type: web
      7 + |  name: spring-pet-clinic
      8 + |  namespace: default
      9 + |spec:
     10 + |  serviceAccountName: petc-serviceaccount
     11 + |  source:
     12 + |    git:
     13 + |      ref:
     14 + |        branch: main
     15 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? (y/N)
```
</details>

To unset a service account, pass empty string.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --service-account ""
Update workload:
...
  6,  6   |    apps.tanzu.vmware.com/workload-type: web
  7,  7   |  name: spring-pet-clinic
  8,  8   |  namespace: default
  9,  9   |spec:
 10     - |  serviceAccountName: petc-serviceaccount
 11, 10   |  source:
 12, 11   |    git:
 13, 12   |      ref:
 14, 13   |        branch: main
...

? Really update the workload "spring-pet-clinic"? (y/N)
```
</details>

### <a id="apply-service-ref"></a> `--service-ref`

Binds a service to a workload to provide the info from a service resource to an application.

**Note:** For more information see [Tanzu Application Platform documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-getting-started-consume-services.html#stk-bind).

<details><summary>Example</summary>

```bash
tanzu apps workload apply rmq-sample-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1"
Create workload:
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

? Do you want to create this workload? (y/N)
```
</details>

To delete service binding, use the service name followed by `-`.

<details><summary>Example</summary>

```bash
tanzu apps workload apply rmq-sample-app --service-ref rmq-
Update workload:
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

? Really update the workload "rmq-sample-app"? (y/N)
```
</details>

### <a id="apply-subpath"></a> `--sub-path`

It's used to define which path is going to be used as root to create and update the workload.

<details><summary>Example</summary>

  - Git repo
    ```bash
    tanzu apps workload apply subpathtester --git-repo https://github.com/path-to-repo/my-repo --git-branch main --type web --sub-path my-subpath

    Create workload:
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

    ? Do you want to create this workload? (y/N)
    ```

  - Local path
      - In the folder of the project you want to create the workload from
      ```bash
      tanzu apps workload apply my-workload --local-path . -s gcr.io/my-registry/my-workload-image --sub-path subpath_folder
      ? Publish source in "." to "gcr.io/my-registry/my-workload-image"? It may be visible to others who can pull images from that repository Yes
      Publishing source in "." to "gcr.io/my-registry/my-workload-image"...
      Published source
      Create workload:
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

      ? Do you want to create this workload? (y/N)

      ```
</details>

### <a id="apply-tail"></a> `--tail`

Prints the logs of the workload creation in every step.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --tail
Create workload:
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? Yes
Created workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic"
To get status: "tanzu apps workload get spring-pet-clinic"

Waiting for workload "spring-pet-clinic" to become ready...
+ spring-pet-clinic-build-1-build-pod › prepare
spring-pet-clinic-build-1-build-pod[prepare] Build reason(s): CONFIG
spring-pet-clinic-build-1-build-pod[prepare] CONFIG:
spring-pet-clinic-build-1-build-pod[prepare] 	+ env:
spring-pet-clinic-build-1-build-pod[prepare] 	+ - name: BP_OCI_SOURCE
spring-pet-clinic-build-1-build-pod[prepare] 	+   value: main/d381fb658cb435a04e2271ca85bd3e8627a5e7e4
spring-pet-clinic-build-1-build-pod[prepare] 	resources: {}
spring-pet-clinic-build-1-build-pod[prepare] 	- source: {}
spring-pet-clinic-build-1-build-pod[prepare] 	+ source:
spring-pet-clinic-build-1-build-pod[prepare] 	+   blob:
spring-pet-clinic-build-1-build-pod[prepare] 	+     url: http://source-controller.flux-system.svc.cluster.local./gitrepository/default/spring-pet-clinic/d381fb658cb435a04e2271ca85bd3e8627a5e7e4.tar.gz
...
...
...
```
</details>

### <a id="apply-tail-timestamp"></a> `--tail-timestamp`

Prints the logs of the workload creation in every step adding the time in which the log is occurring.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web --tail-timestamp
Create workload:
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/sample-accelerators/spring-petclinic

? Do you want to create this workload? Yes
Created workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic"
To get status: "tanzu apps workload get spring-pet-clinic"

Waiting for workload "spring-pet-clinic" to become ready...
+ spring-pet-clinic-build-1-build-pod › prepare
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.348418803-05:00 Build reason(s): CONFIG
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364719405-05:00 CONFIG:
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364761781-05:00 	+ env:
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364771861-05:00 	+ - name: BP_OCI_SOURCE
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364781718-05:00 	+   value: main/d381fb658cb435a04e2271ca85bd3e8627a5e7e4
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364788374-05:00 	resources: {}
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.364795451-05:00 	- source: {}
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.365344965-05:00 	+ source:
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.365364101-05:00 	+   blob:
spring-pet-clinic-build-1-build-pod[prepare] 2022-06-15T11:28:01.365372427-05:00 	+     url: http://source-controller.flux-system.svc.cluster.local./gitrepository/default/spring-pet-clinic/d381fb658cb435a04e2271ca85bd3e8627a5e7e4.tar.gz
...
...
...
```
</details>

### <a id="apply-type"></a> `--type`

Sets the type of the workload by adding the label `apps.tanzu.vmware.com/workload-type`, which is very common to be used as a matcher by supply chains.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-branch main --type web
Create workload:
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
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/sample-accelerators/spring-petclinic
```
</details>

### <a id="apply-wait"></a> `--wait`

Holds until workload is ready.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --wait
Update workload:
...
10, 10   |  source:
11, 11   |    git:
12, 12   |      ref:
13, 13   |        branch: main
    14 + |        tag: tap-1.1
14, 15   |      url: https://github.com/sample-accelerators/spring-petclinic

? Really update the workload "spring-pet-clinic"? Yes
Updated workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic"
To get status: "tanzu apps workload get spring-pet-clinic"

Waiting for workload "spring-pet-clinic" to become ready...
Workload "spring-pet-clinic" is ready
```
</details>

### <a id="apply-wait-timeout"></a> `--wait-timeout`

Sets a timeout to wait for workload to become ready.

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --git-repo https://github.com/sample-accelerators/spring-petclinic --git-tag tap-1.1 --type web --wait --wait-timeout 1m
Update workload:
...
10, 10   |  source:
11, 11   |    git:
12, 12   |      ref:
13, 13   |        branch: main
14     - |        tag: tap-1.2
    14 + |        tag: tap-1.1
15, 15   |      url: https://github.com/sample-accelerators/spring-petclinic

? Really update the workload "spring-pet-clinic"? Yes
Updated workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic"
To get status: "tanzu apps workload get spring-pet-clinic"

Waiting for workload "spring-pet-clinic" to become ready...
Workload "spring-pet-clinic" is ready
```
</details>

### <a id="apply-yes"></a> `--yes`, `-y`

Assume yes on all the survey prompts

<details><summary>Example</summary>

```bash
tanzu apps workload apply spring-pet-clinic --local-path/home/user/workspace/spring-pet-clinic --source-image gcr.io/spring-community/spring-pet-clinic --type web -y
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "/Users/dalfonso/Documents/src/java/tanzu-java-web-app" to "gcr.io/spring-community/spring-pet-clinic"...
Published source
Create workload:
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

Created workload "spring-pet-clinic"

To see logs:   "tanzu apps workload tail spring-pet-clinic"
To get status: "tanzu apps workload get spring-pet-clinic"

```
</details>
