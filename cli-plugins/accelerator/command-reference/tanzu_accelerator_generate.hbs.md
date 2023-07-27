## tanzu accelerator generate

This command generates a project from an accelerator.

### Synopsis

Generate a project from an accelerator using provided options and download project artifacts as a ZIP file.

Generation options are provided as a JSON string and should match the metadata options that are specified for the
accelerator used for the generation. The options can include "projectName" which defaults to the name of the accelerator.
This "projectName" will be used as the name of the generated ZIP file.

You can see the available options by using the "tanzu accelerator get <accelerator-name>" command.

Here is an example of an options JSON string that specifies the "projectName" and an "includeKubernetes" boolean flag:

    --options '{"projectName":"test", "includeKubernetes": true}'

You can also provide a file that specifies the JSON string using the --options-file flag.

The generate command needs access to the Application Accelerator server. You can specify the --server-url flag or set
an ACC_SERVER_URL environment variable. If you specify the --server-url flag it overrides the ACC_SERVER_URL
environment variable if it is set.


```
tanzu accelerator generate [flags]
```

### Examples

```
tanzu accelerator generate <accelerator-name> --options '{"projectName":"test"}'
```

### Options

```
  -h, --help                  help for generate
      --options string        options JSON string
      --options-file string   path to file containing options JSON string
      --output-dir string     directory that the zip file will be written to
      --server-url string     the URL for the Application Accelerator server
```

### Options inherited from parent commands

```
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
```

### SEE ALSO

* [tanzu accelerator](tanzu_accelerator.md)	 - Manage accelerators in a Kubernetes cluster

