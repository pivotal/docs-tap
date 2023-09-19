# tanzu accelerator

This topic tells you how to use the Tanzu Accelerator CLI  plugin `tanzu accelerator apply` command
to create or update accelerators. Create or update accelerator resource using specified manifest file.

## Installation

## Usage

**CLI plugin:** accelerator | **Plugin version:** v1.0.0 | **Target:** Kubernetes

**Syntax:**

```console
tanzu kubernetes accelerator [command]
```

**Aliases:**

```console
  accelerator, acc
```

**Available Commands:**

```console
  apply               Apply accelerator resource
  create              Create a new accelerator
  delete              Delete an accelerator
  fragment            Fragment commands
  generate            Generate project from accelerator
  generate-from-local Generate project from a combination of registered and local artifacts
  get                 Get accelerator info
  list                List accelerators
  push                (DEPRECTAED) Push local path to source image
  update              Update an accelerator
```

**Flags:**

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
  -h, --help              help for accelerator
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### tanzu accelerator apply

This topic tells you how to use the Tanzu Accelerator CLI  plugin `tanzu accelerator apply` command
to create or update accelerators. Create or update accelerator resource using specified manifest file.

**Usage:**

**CLI plugin:** accelerator | **Plugin version:** v1.0.0 | **Target:** Kubernetes

**Syntax:**

```console
tanzu accelerator apply [flags]
```

**Examples:**

```console
tanzu accelerator apply --filename <path-to-resource-manifest>
```

**Flags:**

```console
  -f, --filename string    path of manifest file for the resource
  -h, --help               help for apply
  -n, --namespace string   namespace for the resource (default "accelerator-system")
```

### tanzu accelerator create

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator create` command
to create a new accelerator.

**Usage:**

Create a new accelerator resource with specified configuration.

Accelerator configuration options include:

- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags, and icon-url

The Git repository option is required. Metadata options are optional and override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.

```console
tanzu accelerator create [flags]
```

**Examples:**

```console
tanzu accelerator create <accelerator-name> --git-repository <URL> --git-branch <branch>
```

**Flags:**

```console
      --description string    description of this accelerator
      --display-name string   display name for the accelerator
      --git-branch string     Git repository branch to be used (default "main")
      --git-repo string       Git repository URL for the accelerator
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for create
      --icon-url string       URL for icon to use with the accelerator
      --interval string       interval for checking for updates to Git or image repository
      --local-path string     path to the directory containing the source for the accelerator
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   name of the source image for the accelerator
      --tags strings          tags that can be used to search for accelerators
```

### tanzu accelerator delete

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator delete` command
to delete an accelerator.

**Usage:**

Delete the accelerator resource with the specified name.

```console
tanzu accelerator delete [flags]
```

**Examples:**

```console
tanzu accelerator delete <accelerator-name>
```

**Flags:**

```console
  -h, --help               help for delete
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
```

### tanzu accelerator fragment

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator fragment`
command to manage fragments.

**Usage:**

Commands to manage accelerator fragments

**Examples:**

```console
tanzu accelerator fragment --help
```

**Available Commands:**

```console
  create      Create a new accelerator fragment
  delete      Delete an accelerator fragment
  get         Get accelerator fragment info
  list        List accelerator fragments
  update      Update an accelerator fragment
```

**Flags:**

```console
  -h, --help   help for fragment
```

#### tanzu accelerator fragment create

Create a new accelerator fragment resource with specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The Git repository option is required. Metadata options are optional and will override any values for
the same options specified in the accelerator metadata retrieved from the Git repository.

**Usage:**

  tanzu kubernetes accelerator fragment create [flags]

**Examples:**

  tanzu acceleratorent fragm create <fragment-name> --git-repository <URL> --git-branch <branch> --git-sub-path <sub-path>

**Flags:**

      --display-name string   display name for the accelerator fragment
      --git-branch string     Git repository branch to be used (default "main")
      --git-repo string       Git repository URL for the accelerator fragment
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for create
      --interval string       interval for checking for updates to Git or image repository
      --local-path string     (DEPRECATED) path to the directory containing the source for the accelerator fragment
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   (DEPRECATED) name of the source image for the accelerator

#### tanzu accelerator fragment delete

Delete the accelerator fragment resource with the specified name.

**Usage:**

```console
tanzu kubernetes accelerator fragment delete [flags]
```

**Examples:**

```console
tanzu accelerator fragment delete <fragment-name>
```

**Flags:**

```console
  -h, --help               help for delete
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
```

#### tanzu accelerator fragment get

Get accelerator fragment info.

**Usage:**

```console
  tanzu kubernetes accelerator fragment get [flags]
```

**Examples:**

```console
  tanzu accelerator get <fragment-name>
```

**Flags:**

```console
  -h, --help               help for get
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
```

#### tanzu accelerator fragment list

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator fragment list`
to list accelerator fragments.

**Usage:**

List all accelerator fragments.

```console
tanzu accelerator fragment list [flags]
```

**Examples:**

```console
tanzu accelerator fragment list
```

**Flags:**

```console
  -h, --help               help for list
  -n, --namespace string   namespace for accelerator system (default "accelerator-system")
  -v, --verbose            include repository and show long URLs or image digests in the output
```

#### tanzu accelerator fragment update

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator fragment update`
command to update an accelerator fragment.

**Usage:**

Update an accelerator fragment resource with the specified name using the specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like display-name

The update command also provides a --reconcile flag that will force the accelerator fragment to be refreshed
with any changes made to the associated Git repository.

```console
tanzu accelerator fragment update [flags]
```

**Examples:**

```console
tanzu accelerator update <accelerator-name> --description "Lorem Ipsum"
```

**Flags:**

```console
      --display-name string   display name for the accelerator fragment
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator fragment
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for update
      --interval string       interval for checking for updates to Git repository
  -n, --namespace string      namespace for accelerator fragments (default "accelerator-system")
      --reconcile             trigger a reconciliation including the associated GitRepository resource
      --secret-ref string     name of secret containing credentials for private Git repository
```

### tanzu accelerator generate

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator generate`
command to generate a project from an accelerator.

**Usage:**

Generate a project from an accelerator using provided options and download project artifacts as a ZIP file.

Generation options are provided as a JSON string and should match the metadata options that are specified for the
accelerator used for the generation. The options can include "projectName" which defaults to the name of the accelerator.
This "projectName" will be used as the name of the generated ZIP file.

You can see the available options by using the "tanzu accelerator get <accelerator-name>" command.

Here is an example of an options JSON string that specifies the "projectName" and an "includeKubernetes" boolean flag:

    --options '{"projectName":"test", "includeKubernetes": true}'

You can also provide a file that specifies the JSON string using the --options-file flag.

The generate command needs access to the Application Accelerator server. You can specify the
`--server-url` flag or set an `ACC_SERVER_URL` environment variable.
If you specify the `--server-url` flag it overrides the `ACC_SERVER_URL`
environment variable if it is set.

```console
tanzu accelerator generate [flags]
```

**Examples:**

```console
tanzu accelerator generate <accelerator-name> --options '{"projectName":"test"}'
```

**Flags:**

```console
  -h, --help                  help for generate
      --options string        options JSON string
      --options-file string   path to file containing options JSON string
      --output-dir string     directory that the zip file will be written to
      --server-url string     the URL for the Application Accelerator server
```

### tanzu accelerator generate-from-local

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator generate-from-local`
command to generate a project from a combination of registered and local artifacts.

**Usage:**

Generate a project from a combination of local files and registered accelerators/fragments using provided
options and download project artifacts as a ZIP file.

Options values are provided as a JSON object and should match the declared options that are
specified for the accelerator used for the generation. The options can include "projectName" which
defaults to the name of the accelerator.
This "projectName" is used as the name of the generated ZIP file.

Here is an example of an options JSON string that specifies the "projectName" and an
"includeKubernetes" Boolean flag:

    --options '{"projectName":"test", "includeKubernetes": true}'

You can also provide a file that specifies the JSON string using the --options-file flag.

The generate-from-local command needs access to the Application Accelerator server. You can specify the --server-url flag or set
an `ACC_SERVER_URL` environment variable. If you specify the `--server-url` flag it overrides the
`ACC_SERVER_URL` environment variable if it is set.

```console
tanzu accelerator generate-from-local [flags]
```

**Examples:**

```console
tanzu accelerator generate-from-local --accelerator-path java-rest=workspace/java-rest --fragment-paths java-version=workspace/version --fragment-names tap-workload --options '{"projectName":"test"}'
```

**Flags:**

```console
      --accelerator-name string             name of the registered accelerator to use
      --accelerator-path "key=value" pair   key value pair of the name and path to the directory containing the accelerator
  -f, --force                               force clean and rewrite of output-dir
      --fragment-names strings              names of the registered fragments to use
      --fragment-paths stringToString       key value pairs of the name and path to the directory containing each fragment (default [])
  -h, --help                                help for generate-from-local
      --options string                      options JSON string (default "{}")
      --options-file string                 path to file containing options JSON string
  -o, --output-dir string                   the directory that the project will be created in (defaults to the project name)
      --server-url string                   the URL for the Application Accelerator server
```

### tanzu accelerator get

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator get`
command to get accelerator information.

**Usage:**

Get accelerator information.

You can choose to get the accelerator from the Application Accelerator server using `--server-url` flag
or from a Kubernetes context using `--from-context` flag. The default is to get accelerators from the
Kubernetes context. To override this, you can set the `ACC_SERVER_URL` environment variable with the
URL for the Application Accelerator server you want to access.

```console
tanzu accelerator get [flags]
```

**Examples:**

```console
tanzu accelerator get <accelerator-name> --from-context
```

**Flags:**

```console
      --from-context        retrieve resources from current context defined in kubeconfig
  -h, --help                help for get
  -n, --namespace string    namespace for accelerator system (default "accelerator-system")
      --server-url string   the URL for the Application Accelerator server
  -v, --verbose             include all fields and show long URLs in the output
```

### tanzu accelerator list

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator list`
command to list accelerators.

**Usage:**

List all accelerators.

You can choose to list the accelerators from the Application Accelerator server using --server-url flag
or from a Kubernetes context using `--from-context` flag. The default is to list accelerators from the
Kubernetes context. To override this, you can set the `ACC_SERVER_URL` environment variable with the URL for the Application Accelerator server you want to access.

```console
tanzu accelerator list [flags]
```

**Examples:**

```console
tanzu accelerator list
```

**Flags:**

```console
      --from-context        retrieve resources from the current context defined in kubeconfig
  -h, --help                help for list
  -n, --namespace string    namespace for accelerator system (default "accelerator-system")
      --server-url string   the URL for the Application Accelerator server
  -t, --tags strings        accelerator tags to match against
  -v, --verbose             include repository and show long URLs or image digests in the output
```

### tanzu accelerator push

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator push`
command to push source code from local path to source image.

**Usage:**

Push source code from local path to source image used by an accelerator

```console
tanzu accelerator push [flags]
```

**Examples:**

```console
tanzu accelerator push --local-path <local path> --source-image <image>
```

**Flags:**

```console
  -h, --help                  help for push
      --local-path string     path to the directory containing the source for the accelerator
      --source-image string   name of the source image for the accelerator
```

> **Note**  When you run the `tanzu accelerator push` command, `--source-image` is only required if
the registry being used is not handled by Local Source Proxy. For information about
Local Source Proxy, see
[Overview of Local Source Proxy](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/local-source-proxy-about.html) in the Tanzu Applicaiton Plaform documentation.

If Local Source Proxy cannot be configured, use a source image registry. Before deploying a
workload, you must authenticate with an image registry to store your source code.

### tanzu accelerator update

This topic tells you how to use the Tanzu Accelerator CLI `tanzu accelerator update`
command to update an accelerator.

**Usage:**

Update an accelerator resource with the specified name using the specified configuration.

Accelerator configuration options include:
- Git repository URL and branch/tag where accelerator code and metadata is defined
- Metadata like description, display-name, tags and icon-url

The update command also provides a `--reoncile` flag that will force the accelerator to be refreshed
with any changes made to the associated Git repository.

```console
tanzu accelerator update [flags]
```

**Examples:**

```console
tanzu accelerator update <accelerator-name> --description "Lorem Ipsum"
```

**Flags:**

```console
      --description string    description of this accelerator
      --display-name string   display name for the accelerator
      --git-branch string     Git repository branch to be used
      --git-repo string       Git repository URL for the accelerator
      --git-sub-path string   Git repository subPath to be used
      --git-tag string        Git repository tag to be used
  -h, --help                  help for update
      --icon-url string       URL for icon to use with the accelerator
      --interval string       interval for checking for updates to Git or image repository
  -n, --namespace string      namespace for accelerator system (default "accelerator-system")
      --reconcile             trigger a reconciliation including the associated GitRepository resource
      --secret-ref string     name of secret containing credentials for private Git or image repository
      --source-image string   name of the source image for the accelerator
      --tags strings          tags that can be used to search for accelerators
```
