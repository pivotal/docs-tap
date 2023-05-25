# Workload Examples

Use the following flags with the Apps CLI plug-in.

## <a id='custom-registry'></a> Custom registry credentials

Either use a custom certificate on your system or pass the path to the certificate
through flags.

To pass the certificate through flags, specify:

- `--registry-ca-cert`, the path of the self-signed certificate needed for the
  custom or private registry. This is also populated with a default value through the environment
  variable `TANZU_APPS_REGISTRY_CA_CERT`.
- `--registry-password` use when the registry requires credentials to push. The value of
  this flag can also be specified through `TANZU_APPS_REGISTRY_PASSWORD`.
- `--registry-username` used with `--registry-password` to set the registry credentials. It
  can also be provided as the environment variable `TANZU_APPS_REGISTRY_USERNAME`.
- `--registry-token`, set when the registry authentication is done through a token. The value
  of this flag can also be taken from `TANZU_APPS_REGISTRY_TOKEN` environment variable.

For example:

```console
tanzu apps workload apply WORKLOAD --local-path PATH-TO-REPO -s registry.url.nip.io/PACKAGE/IMAGE --type web --registry-ca-cert PATH-TO-CA-CERT.nip.io.crt --registry-username USERNAME --registry-password PASSWORD

Alternatively, the same command can be run as:

```console
export TANZU_APPS_REGISTRY_CA_CERT=PATH-TO-CA-CERT.nip.io.crt
export TANZU_APPS_REGISTRY_PASSWORD=USERNAME
export TANZU_APPS_REGISTRY_USERNAME=PASSWORD

tanzu apps workload apply WORKLOAD --local-path PATH-TO-REPO -s registry.url.nip.io/PACKAGE/IMAGE
```
## <a id='live-updated-debug'></a> --live-update and --debug

Use the `--live-update` flag to ensure that local source code changes are reflected quickly
on the running workload. This is particularly valuable when iterating on features that require
the workload to be deployed and running to validate.

Live update is ideally situated for running from within one of our supported IDE extensions, but it
can also be utilized independently as shown in the following Spring Boot application example:

### Spring Boot application example

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

## <a id='export-usage'></a> --export

Use this flag to retrieve the workload definition with all the
extraneous, cluster-specific, properties/values removed. For example, the status and metadata text
boxes like `creationTimestamp`. This allows you to apply the workload definition to a different
environment without having to make significant edits.

This means that the workload definition includes only the text boxes that were specified by the
developer that created it (`--export` preserves the essence of the developer's intent for portability).

For example, if you create a workload with:

```console
tanzu apps workload apply rmq-sample-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1" -t web
```

When querying the workload with `--export`, the default export format in YAML is as follows:

```console
# with yaml format
    tanzu apps workload get rmq-sample-app --export
    ---
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
    labels:
        apps.tanzu.vmware.com/workload-type: web
    name: rmq-sample-app
    namespace: default
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

# with json format
    tanzu apps workload get rmq-sample-app --export --output json
    {
        "apiVersion": "carto.run/v1alpha1",
        "kind": "Workload",
        "metadata": {
            "labels": {
                "apps.tanzu.vmware.com/workload-type": "web"
            },
            "name": "rmq-sample-app",
            "namespace": "default"
        },
        "spec": {
            "serviceClaims": [
                {
                    "name": "rmq",
                    "ref": {
                        "apiVersion": "rabbitmq.com/v1beta1",
                        "kind": "RabbitmqCluster",
                        "name": "example-rabbitmq-cluster-1"
                    }
                }
            ],
            "source": {
                "git": {
                    "ref": {
                        "branch": "main"
                    },
                    "url": "https://github.com/jhvhs/rabbitmq-sample"
                }
            }
        }
    }
```

## <a id='export-usage'></a> --output

Use this flag to retrieve the workload including all the cluster-specifics. The
`--output` flag can also be used in conjunction with the `--export` flag to set the export format
as `json`, `yaml`, or `yml`.

```console
# with json format
tanzu apps workload get rmq-sample-app --output json # can also be used as tanzu apps workload get rmq-sample-app -ojson
    {
        "kind": "Workload",
        "apiVersion": "carto.run/v1alpha1",
        "metadata": {
            "name": "rmq-sample-app",
            "namespace": "default",
            "uid": "3619ff6d-9e73-473a-9112-891a6d8aee9e",
            "resourceVersion": "11657434",
            "generation": 2,
            "creationTimestamp": "2022-11-28T05:10:32Z",
            "labels": {
                "apps.tanzu.vmware.com/workload-type": "web"
            },
            "managedFields": [
                {
                    "manager": "v0.10.0+dev-002cc44e",
                    "operation": "Update",
                    "apiVersion": "carto.run/v1alpha1",
                    "time": "2022-11-28T05:10:32Z",
                    "fieldsType": "FieldsV1",
                    "fieldsV1": {
                        "f:metadata": {
                            "f:labels": {
                                ".": {},
                                "f:apps.tanzu.vmware.com/workload-type": {}
                            }
                        },
                        ...
                    }
                },
                ...
            ]
        },
        ...
            "status": {
            "observedGeneration": 2,
            "conditions": [
                {
                    "type": "SupplyChainReady",
                    "status": "True",
                    "lastTransitionTime": "2022-11-28T05:10:32Z",
                    "reason": "Ready",
                    "message": ""
                },
                {
                    "type": "ResourcesSubmitted",
                    "status": "True",
                    "lastTransitionTime": "2022-11-28T05:13:33Z",
                    "reason": "ResourceSubmissionComplete",
                    "message": ""
                },
                ...
            ],
            "supplyChainRef": {
                "kind": "ClusterSupplyChain",
                "name": "source-to-url"
            },
            "resources": [
                {
                    "name": "source-provider",
                    "stampedRef": {
                        "kind": "GitRepository",
                        "namespace": "default",
                        "name": "rmq-sample-app",
                        "apiVersion": "source.toolkit.fluxcd.io/v1beta1",
                        "resource": "gitrepositories.source.toolkit.fluxcd.io"
                    },
                    "templateRef": {
                        "kind": "ClusterSourceTemplate",
                        "name": "source-template",
                        "apiVersion": "carto.run/v1alpha1"
                    },
                ...
                }
            ...
            ]
            ...
        }
        ...
    }

## with yaml format
tanzu apps workload get rmq-sample-app --output yaml # can also be used as tanzu apps workload get rmq-sample-app -oyaml
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: "2022-11-28T05:10:32Z"
  generation: 2
  labels:
    apps.tanzu.vmware.com/workload-type: web
  managedFields:
  - apiVersion: carto.run/v1alpha1
      ...
    manager: v0.10.0+dev-002cc44e
    operation: Update
    time: "2022-11-28T05:10:32Z"
  - apiVersion: carto.run/v1alpha1
    fieldsType: FieldsV1
    ...
    manager: cartographer
    operation: Update
    subresource: status
    time: "2022-11-28T05:10:36Z"
  name: rmq-sample-app
  namespace: default
  resourceVersion: "11657434"
  uid: 3619ff6d-9e73-473a-9112-891a6d8aee9e
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
  conditions:
  - lastTransitionTime: "2022-11-28T05:10:32Z"
    message: ""
    reason: Ready
    status: "True"
    type: SupplyChainReady
  ...
  observedGeneration: 2
  resources:
  ...
    name: source-provider
    outputs:
    - digest: sha256:97b2cb779b4ea31339595cd204a3fec0053805eeacbbd6d6dd23af7d3000a6ae
      lastTransitionTime: "2022-11-28T05:16:01Z"
      name: url
      preview: |
        http://fluxcd-source-controller.flux-system.svc.cluster.local./gitrepository/default/rmq-sample-app/73c6311eefbf724fee9ad6f4524fa24ec842ff34.tar.gz
    - digest: sha256:e7884b071fe1bbb2551d42a171043d061a7591e744705572136e689c2a154b7a
      lastTransitionTime: "2022-11-28T05:16:01Z"
      name: revision
      preview: |
        HEAD/73c6311eefbf724fee9ad6f4524fa24ec842ff34
    stampedRef:
      apiVersion: source.toolkit.fluxcd.io/v1beta1
      kind: GitRepository
      name: rmq-sample-app
      namespace: default
      resource: gitrepositories.source.toolkit.fluxcd.io
    templateRef:
      apiVersion: carto.run/v1alpha1
      kind: ClusterSourceTemplate
      name: source-template
  - conditions:
    - lastTransitionTime: "2022-11-28T05:13:25Z"
      message: ""
      reason: ResourceSubmissionComplete
      status: "True"
      type: ResourceSubmitted
    ...
    inputs:
    - name: source-provider
```

## <a id='subpath-usage'></a> --sub-path

Use this flag to support use cases where more than one application is in a single project or repository.

Use `--sub-path` when creating a workload from a Git repository

    ```console
    tanzu apps workload apply subpathtester --git-repo https://github.com/PATH-TO-REPO --git-branch main --type web --sub-path SUBPATH

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
       14 + |      url: https://github.com/path-to-repo/PATH-TO-REPO
       15 + |    subPath: SUBPATH
    ❓ Do you want to create this workload? [yN]:
    ```

Use `--sub-path` when you create a workload from local source code.
In the directory of the project you want to create the workload from:

      ```console
      tanzu apps workload apply WORKLOAD --local-path . -s gcr.io/REGISTRY/WORKLOAD-IMAGE --sub-path SUBPATH

      ❓ Publish source in "." to "gcr.io/REGISTRY/WORKLOAD-IMAGE"? It might be visible to others who can pull images from that repository Yes
      Publishing source in "." to "gcr.io/REGISTRY/WORKLOAD-IMAGE"...
      📥 Published source

      🔎 Create workload:
            1 + |---
            2 + |apiVersion: carto.run/v1alpha1
            3 + |kind: Workload
            4 + |metadata:
            5 + |  name: WORKLOAD
            6 + |  namespace: default
            7 + |spec:
            8 + |  source:
            9 + |    image: gcr.io/REGISTRY/my-workload-image:latest@sha256:f28c5fedd0e902800e6df9605ce5e20a8e835df9e87b1a0aa256666ea179fc3f
           10 + |    subPath: SUBPATH
      ❓ Do you want to create this workload? [yN]:

      ```

**Note** In cases where a workload must be created from local source code, to reduce the total amount
of code that is uploaded, set the `--local-path` value to point directly to the
directory containing the code rather than using `--sub-path`.

## <a id='tanzuignore-file-usage'></a> .tanzuignore file

There are many files and directories in projects that are not connected to running code
(these files are not part of the final running container). When creating a workload from local
source code, list these unused files and directories in the `.tanzuignore` file to avoid unnecessary
consumption of resources when uploading the source.

When iterating on code with the `--live-update` flag enabled, changes to directories or files
listed in `.tanzuignore` do not trigger the automatic re-deployment of the source code.

The following are some guidelines for the `.tanzuignore` file:

- The `.tanzuignore` file should include a reference to itself, as it provides no value when deployed.
- Directories must not end with the system separator `/`, or `\`.
- Comments using hashtag `#` can be included.
- If the `.tanzuignore` file contains files or directories that are not found in the source code, they
are ignored.

### Example of a .tanzuignore file

```console
    .tanzuignore # must contain itself in order to be ignored
    # This is a comment
    this/is/a/folder/to/exclude

    this-is-a-file.ext
```

## <a id='dry-run'></a> --dry-run

Use the `--dry-run` flag to prepare all the steps to submit a workload to the cluster
but stop before sending it, and display an output of the final structure of the workload.

For example, when applying a workload from Git source:

```console
tanzu apps workload apply rmq-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1" -t web --dry-run
---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  creationTimestamp: null
  labels:
    apps.tanzu.vmware.com/workload-type: web
  name: rmq-app
  namespace: default
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

Certify how a workload is created or updated in the cluster based on the
current specifications passed through `--file workload.yaml` or command flags.

If there is an error applying the workload, this is shown with the `--dry-run` flag:

```console
tanzu apps workload create rmq-sample-app --git-repo https://github.com/jhvhs/rabbitmq-sample --git-branch main --service-ref "rmq=rabbitmq.com/v1beta1:RabbitmqCluster:example-rabbitmq-cluster-1" -t web --dry-run
Error: workload "default/rmq-sample-app" already exists
```

## <a id='update-strategy-usage'></a> --update-strategy

Use this flag to control whether configuration properties and values passed through
`--file workload.yaml` for an existing workload `merge` with, or `replace` (overwrite),
existing on-cluster properties or values set for a workload.

The `--update-strategy` flag accepts two values: `merge` (default), and `replace`.

With the default `merge`:

If the `--file workload.yaml` deletes an existing on-cluster property or value, that property is not
removed from the on-cluster definition.
If the `--file workload.yaml` includes a new property/value - it is added to the on-cluster workload
properties/values.
If the `--file workload.yaml` updates an existing value for a property, that property's value
on-cluster is updated.

With `replace`:

The on-cluster workload is updated to exactly what is specified in the `--file workload.yaml` definition.

The intent of the current default merge strategy is to prevent unintentional deletions of critical
properties from existing workloads.

**Note** The default value for the `--update-strategy flag` will change from merge to replace
in Tanzu Application Platform v1.7.0.

Examples of the outcomes of both `merge` and `replace` update strategies are provided in the
following examples:

- ```console
  # Export workload if there is no previous yaml definition
  tanzu apps workload get spring-petclinic --export > spring-petclinic.yaml

  # modify the workload definition
  vi rmq-sample-app.yaml
  ---
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    name: spring-petclinic
    labels:
      app.kubernetes.io/part-of: spring-petclinic
      apps.tanzu.vmware.com/workload-type: web
  spec:
    resources:
      requests:
        memory: 1Gi
      limits:           # delete this line
        memory: 1Gi     # delete this line
        cpu: 500m       # delete this line
    source:
      git:
        url: https://github.com/sample-accelerators/spring-petclinic
        ref:
          tag: tap-1.1
  ```

After saving the file, to verify how both of the update strategy options behave, run:

```console
tanzu apps workload apply -f ./spring-petclinic.yaml --update-strategy merge # if flag is not specified, merge is taken as default
```

This produces the following output:

```console
❗ WARNING: Configuration file update strategy is changing. By default, provided configuration files will replace rather than merge existing configuration. The change will take place in the January 2024 TAP release (use "--update-strategy" to control strategy explicitly).

Workload is unchanged, skipping update
```

By contrast, use `replace` as follows:

```console
tanzu apps workload apply -f ./spring-petclinic.yaml --update-strategy replace
```

This produces the following output:

```console
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

The lines that were deleted in the YAML file are deleted as well in the workload running in the
cluster. The only text boxes that remain exactly as they were created are the system populated
metadata text boxes (`resourceVersion`, `uuid`, `generation`, `creationTimestamp`,
`deletionTimestamp`).
