# tanzu accelerator generate-from-local

Generate project from a combination of registered and local artifacts.

## Synopsis

Generate a project from a combination of local files and registered accelerators/fragments using provided
options and download project artifacts as a ZIP file.

Options values are provided as a JSON object and should match the declared options that are specified for the
accelerator used for the generation. The options can include "projectName" which defaults to the name of the accelerator.
This "projectName" is used as the name of the generated ZIP file.

Here is an example of an options JSON string that specifies the "projectName" and an "includeKubernetes" Boolean flag:

    --options '{"projectName":"test", "includeKubernetes": true}'

You can also provide a file that specifies the JSON string using the --options-file flag.

The generate-from-local command needs access to the Application Accelerator server. You can specify the --server-url flag or set
an ACC_SERVER_URL environment variable. If you specify the --server-url flag it overrides the ACC_SERVER_URL
environment variable if it is set.

```console
tanzu accelerator generate-from-local [flags]
```

## Examples

```console
tanzu accelerator generate-from-local --accelerator-path java-rest=workspace/java-rest --fragment-paths java-version=workspace/version --fragment-names tap-workload --options '{"projectName":"test"}'
```

## Options

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

## Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

## SEE ALSO

[tanzu accelerator](tanzu_accelerator.md)
